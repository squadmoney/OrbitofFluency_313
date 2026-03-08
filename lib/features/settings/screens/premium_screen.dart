import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../premka.dart';
import '../widgets/premium_cta_button.dart';
import '../widgets/premium_feature_card.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundBlue,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Premium', style: AppTypography.h3Medium),
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
                children: const [
                  PremiumIllustration(),
                  SizedBox(height: AppSpacing.sectionGap),
                  _PremiumHeadline(),
                  SizedBox(height: AppSpacing.smallGap),
                  _PremiumSubtitle(),
                  SizedBox(height: AppSpacing.sectionGap),
                  PremiumFeatureCard(label: 'Unlimited sets and cards'),
                  SizedBox(height: AppSpacing.itemGap),
                  PremiumFeatureCard(label: 'PDF & Markdown progress export'),
                  SizedBox(height: AppSpacing.itemGap),
                  PremiumFeatureCard(label: 'Unlimited categories'),
                  // Bottom spacer so content clears the fixed button
                  SizedBox(height: 120),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _PremiumBottomSection(
              onPressed: () async {
                ref.read(boolProvider.notifier).state = true;
               
                await buyPremium(context, ref);
                ref.read(boolProvider.notifier).state = false;
              },
            ),
          ),
        ],
      ),
    );
  }
}

final boolProvider = StateProvider<bool>((ref) => false);

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _PremiumHeadline extends StatelessWidget {
  const _PremiumHeadline();

  @override
  Widget build(BuildContext context) {
    return Text(
      'More opportunities for learning',
      style: AppTypography.h2SemiBold,
      textAlign: TextAlign.center,
    );
  }
}

class _PremiumSubtitle extends StatelessWidget {
  const _PremiumSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Premium unlocks advanced features for comfortable and regular learning.',
      style: AppTypography.bodyBold,
      textAlign: TextAlign.center,
    );
  }
}

class _PremiumBottomSection extends ConsumerWidget {
  final VoidCallback onPressed;

  const _PremiumBottomSection({required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(boolProvider);
    return Container(
      color: AppColors.backgroundBlue,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.smallGap,
        AppSpacing.screenPadding,
        MediaQuery.of(context).padding.bottom + AppSpacing.screenPadding,
      ),
      child: isLoading ? const CupertinoActivityIndicator() : PremiumCtaButton(onPressed: onPressed),
    );
  }
}

class PremiumIllustration extends StatelessWidget {
  const PremiumIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/badge.png',
      width: 192,
      height: 192,
    );
  }
}
