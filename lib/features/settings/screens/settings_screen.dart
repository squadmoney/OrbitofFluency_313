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
import '../widgets/premium_cta_button.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_row.dart';
import 'premium_screen.dart';

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
        middle: GestureDetector(
          onTap: () => ref.read(premProvider.notifier).togglePremium(),
          child: Text(
            'Settings',
            style: AppTypography.h3Medium,
          ),
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
                    onRestore: () => restorePremium(context, ref),
                    onExport: () => handleExportProgress(context, ref),
                  ),

                  // Bottom spacer so content clears the fixed button
                  const SizedBox(height: 180),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: _SettingsBottomSection(
              onBuyPremium: () => Navigator.of(
                context,
                rootNavigator: true,
              ).push(CupertinoPageRoute(builder: (_) => const PremiumScreen())),
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
  final VoidCallback onRestore;
  final VoidCallback onExport;

  const _SettingsRowsCard({required this.onRestore, required this.onExport});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      children: [
        SettingsRow(
          icon: CupertinoIcons.shield,
          label: 'Privacy Policy',
          trailing: const SettingsChevron(),
          onTap: () => docViewer(context, 'https://docs.google.com/document/d/1LUofjeUWmwK8qYc9FsA_fl9S8u-vkYooT7Cp7W1FKsA/edit?usp=sharing', 'Privacy Policy'),
        ),
        SettingsRow(
          icon: CupertinoIcons.shield,
          label: 'Terms of Use',
          trailing: const SettingsChevron(),
          onTap: () => docViewer(context, 'https://docs.google.com/document/d/1YvtW2rXQaeDfUmlHiFGstazShuFLVbgwuJ5OtBIzoSA/edit?usp=sharing', 'Terms of Use'),
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

        SettingsRow(
          icon: CupertinoIcons.arrow_2_circlepath,
          label: 'Restore',
          trailing: const SettingsChevron(),
          onTap: onRestore,
          showDivider: false,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pinned bottom section with Buy Premium button
// ---------------------------------------------------------------------------

class _DebugCard extends StatelessWidget {
  final VoidCallback onClearData;
  final VoidCallback onLoadMocks;
  final bool isLoading;

  const _DebugCard({
    required this.onClearData,
    required this.onLoadMocks,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.smallGap),
          child: Text('Debug', style: AppTypography.caption),
        ),
        SettingsRow(
          icon: CupertinoIcons.trash,
          label: 'Clear All Data',
          trailing: const SettingsChevron(),
          onTap: onClearData,
        ),
        SettingsRow(
          icon: CupertinoIcons.cube_box,
          label: isLoading ? 'Loading...' : 'Load 50 Mock Cards',
          trailing: isLoading ? const CupertinoActivityIndicator() : const SettingsChevron(),
          onTap: isLoading ? null : onLoadMocks,
          showDivider: false,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pinned bottom section with Buy Premium button
// ---------------------------------------------------------------------------

class _SettingsBottomSection extends StatelessWidget {
  final VoidCallback onBuyPremium;

  const _SettingsBottomSection({required this.onBuyPremium});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundBlue,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.smallGap,
        AppSpacing.screenPadding,
        MediaQuery.of(context).padding.bottom + AppSpacing.screenPadding,
      ),
      child: PremiumCtaButton(onPressed: onBuyPremium),
    );
  }
}
