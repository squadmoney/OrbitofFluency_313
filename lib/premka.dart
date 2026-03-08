import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'features/settings/screens/premium_screen.dart' as premium_nav;

const MethodChannel _channel = MethodChannel('in_app_purchase_channel');

// ---------------------------------------------------------------------------
// Free-tier limits
// ---------------------------------------------------------------------------

const int freeMaxCollections = 3;
const int freeMaxCardsPerCollection = 20;

/// Navigates directly to the Premium paywall screen.
void showPremiumGate(BuildContext context, String message) {
  Navigator.of(context, rootNavigator: true).push(
    CupertinoPageRoute(
      builder: (_) => const premium_nav.PremiumScreen(),
    ),
  );
}

Future<void> buyPremium(BuildContext context, WidgetRef ref) async {
  final isActive = await _channel.invokeMethod<bool>('isPremiumActive') ?? false;

  if (!context.mounted) return;

  if (isActive) {
    // User already has an active subscription
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Success!'),
        content: const Text('You already have premium access'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Ok'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
    ref.read(premProvider.notifier).enablePremium();
  } else {
    final result = await _channel.invokeMethod<bool>('buyPremium') ?? false;

    if (!context.mounted) return;

    if (result) {
      ref.read(premProvider.notifier).enablePremium();
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Success!'),
          content: const Text('Your premium access has been activated!'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Purchase Failed'),
          content: const Text('There was a problem purchasing premium access. Please try again.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      );
    }
  }
}

Future<void> restorePremium(BuildContext context, WidgetRef ref) async {
  await _channel.invokeMethod<bool>('restorePurchases');
  final isActive = await _channel.invokeMethod<bool>('isPremiumActive') ?? false;

  if (!context.mounted) return;

  if (isActive) {
    ref.read(premProvider.notifier).enablePremium();
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Success!'),
        content: const Text('Your premium access has been restored'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Ok'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  } else {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Restore Failed'),
        content: const Text('Your premium access is not found.\nPlease contact support.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Ok'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }
}

final premProvider = StateNotifierProvider<PremController, bool>((ref) => PremController());

class PremController extends StateNotifier<bool> {
  PremController() : super(false) {
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final isActive = await _channel.invokeMethod<bool>('isPremiumActive') ?? false;
    state = isActive;
  }

  Future<void> enablePremium() async {
    state = true;
    (await SharedPreferences.getInstance()).setBool('isPremium', true);
  }

  // toggle premium status
  Future<void> togglePremium() async {
    state = !state;
    (await SharedPreferences.getInstance()).setBool('isPremium', state);
  }
}


// always use 'todo' as argument for this function when you need to show a document viewer
// not an 'example.com' or 'google.com'
void docViewer(BuildContext context, String url, String title) {
  showCupertinoSheet(
    context: context,
    enableDrag: false,
    builder: (context) {
      return DocViewerWidget(url: url, title: title);
    },
  );
}

class DocViewerWidget extends StatefulWidget {
  const DocViewerWidget({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  State<DocViewerWidget> createState() => _DocViewerWidgetState();
}

class _DocViewerWidgetState extends State<DocViewerWidget> {
  late WebViewController _docViewController;
  late Uri _initialUri;
  late String _allowedDomain;

  @override
  void initState() {
    super.initState();

    _initialUri = Uri.parse(widget.url);
    _allowedDomain = _initialUri.host;

    _docViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final requestUri = Uri.parse(request.url);
            final requestDomain = requestUri.host;

            // Разрешаем навигацию только в пределах того же домена
            if (requestDomain == _allowedDomain ||
                requestDomain.endsWith('.$_allowedDomain') ||
                _allowedDomain.endsWith('.$requestDomain')) {
              return NavigationDecision.navigate;
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(_initialUri);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemGrey6,
        middle: Text(widget.title),
        automaticallyImplyLeading: false,
        trailing: CupertinoButton(onPressed: () => Navigator.pop(context), child: const Icon(CupertinoIcons.xmark)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: WebViewWidget(controller: _docViewController),
      ),
    );
  }
}

