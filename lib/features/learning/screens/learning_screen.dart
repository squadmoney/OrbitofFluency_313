import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/learning_provider.dart';
import '../widgets/all_reviewed_view.dart';
import '../widgets/card_stack.dart';
import '../widgets/learning_empty_state.dart';
import '../widgets/progress_counter.dart';

class LearningScreen extends ConsumerWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(learningProvider);
    final notifier = ref.read(learningProvider.notifier);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundBlue,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _NavBar(
                displayIndex: state.displayIndex,
                totalCards: state.totalCards,
              ),
              const SizedBox(height: 24),
              if (state.cards.isEmpty)
                const Expanded(
                  child: LearningEmptyState(),
                )
              else if (state.allReviewed)
                Expanded(
                  child: AllReviewedView(
                    onReviewAgain: notifier.reviewAgain,
                  ),
                )
              else
                _CardSection(
                  state: state,
                  onToggleDescription: notifier.toggleDescription,
                  onNextCard: notifier.nextCard,
                ),
              // Bottom spacer to clear custom tab bar
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Nav bar row
// ---------------------------------------------------------------------------

class _NavBar extends StatelessWidget {
  final int displayIndex;
  final int totalCards;

  const _NavBar({required this.displayIndex, required this.totalCards});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Learning',
          style: AppTypography.h3Medium.copyWith(color: AppColors.textPrimary),
        ),
        ProgressCounter(current: displayIndex, total: totalCards),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Card + swipe controls column
// ---------------------------------------------------------------------------

class _CardSection extends StatelessWidget {
  final LearningState state;
  final VoidCallback onToggleDescription;
  final void Function({required bool gotIt}) onNextCard;

  const _CardSection({
    required this.state,
    required this.onToggleDescription,
    required this.onNextCard,
  });

  @override
  Widget build(BuildContext context) {
    if (state.currentCard == null) return const SizedBox.shrink();

    return CardStack(
      cards: state.cards,
      currentIndex: state.currentIndex,
      isDescriptionShown: state.isDescriptionShown,
      onToggleDescription: onToggleDescription,
      onNextCard: onNextCard,
    );
  }
}
