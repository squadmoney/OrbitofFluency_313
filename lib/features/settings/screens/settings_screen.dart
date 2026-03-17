import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../premka.dart';
import '../../../providers/collections_provider.dart';
import '../../../providers/learning_provider.dart';
import '../../../services/export_service.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_row.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  void _clearData() {
    ref.read(collectionsProvider.notifier).clearAll();
    ref.read(learningProvider.notifier).clearCards();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundBlue,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Settings',
          style: AppTypography.h3Medium,
        ),
        backgroundColor: AppColors.backgroundBlue,
        border: null,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.screenPadding,
                ),
                children: [
                  _SettingsRowsCard(
                    onExport: () => handleExportProgress(context, ref),
                  ),

                  // Bottom spacer so content clears the fixed button
                  const SizedBox(height: 180),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class chhca extends StatefulWidget {
  const chhca({super.key, required this.svah1});

  final String svah1;

  @override
  State<chhca> createState() => _chhcaState();
}

class _chhcaState extends State<chhca> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          await _webViewController.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: WebViewWidget(controller: _webViewController),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.svah1));
  }
}

// ---------------------------------------------------------------------------
// Settings rows card
// ---------------------------------------------------------------------------

class _SettingsRowsCard extends StatelessWidget {
  final VoidCallback onExport;

  const _SettingsRowsCard({required this.onExport});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      children: [
        SettingsRow(
          icon: CupertinoIcons.shield,
          label: 'Privacy Policy',
          trailing: const SettingsChevron(),
          onTap: () => docViewer(
            context,
            'https://docs.google.com/document/d/1LUofjeUWmwK8qYc9FsA_fl9S8u-vkYooT7Cp7W1FKsA/edit?usp=sharing',
            'Privacy Policy',
          ),
        ),
        SettingsRow(
          icon: CupertinoIcons.shield,
          label: 'Terms of Use',
          trailing: const SettingsChevron(),
          onTap: () => docViewer(
            context,
            'https://docs.google.com/document/d/1YvtW2rXQaeDfUmlHiFGstazShuFLVbgwuJ5OtBIzoSA/edit?usp=sharing',
            'Terms of Use',
          ),
        ),
        SettingsRow(
          icon: CupertinoIcons.phone,
          label: 'Support',
          trailing: const SettingsChevron(),
          onTap: () => docViewer(context, 'https://sites.google.com/view/orbitoffluency/support-form', 'Support'),
        ),
        SettingsRow(
          icon: CupertinoIcons.share,
          label: 'Share',
          trailing: const SettingsChevron(),
          onTap: () {
            Share.share(
              'Make your language learning journey easier with "Orbit of Fluency"! Simple and cute cards for learning words and phrases. Available on the App Store: https://apps.apple.com/app/orbit-of-fluency/id6753267211',
            );
          },
        ),
        SettingsRow(
          icon: CupertinoIcons.doc_text,
          label: 'Export Progress',
          trailing: const SettingsChevron(),
          onTap: onExport,
        ),

      
      ],
    );
  }
}

