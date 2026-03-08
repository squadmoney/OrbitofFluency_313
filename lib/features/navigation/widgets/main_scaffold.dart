import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../collections/screens/collections_screen.dart';
import '../../learning/screens/learning_screen.dart';
import '../../new_card/screens/new_card_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../statistics/screens/statistics_screen.dart';
import '../providers/navigation_provider.dart';
import 'app_tab_bar.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  late final CupertinoTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sync provider → controller so programmatic tab switching works
    ref.listen<int>(currentTabIndexProvider, (_, newIndex) {
      if (_tabController.index != newIndex) {
        _tabController.index = newIndex;
      }
    });

    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        // Hidden standard tab bar — we use our custom AppTabBar via tabBuilder
        // Height set to 0 so it doesn't show, but CupertinoTabScaffold requires it.
        height: 0,
        border: null,
        backgroundColor: const Color(0x00000000),
        items: const [
          BottomNavigationBarItem(icon: SizedBox.shrink()),
          BottomNavigationBarItem(icon: SizedBox.shrink()),
          BottomNavigationBarItem(icon: SizedBox.shrink()),
          BottomNavigationBarItem(icon: SizedBox.shrink()),
          BottomNavigationBarItem(icon: SizedBox.shrink()),
        ],
        onTap: (index) {
          ref.read(currentTabIndexProvider.notifier).state = index;
        },
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return _TabScreen(tabIndex: index);
          },
        );
      },
    );
  }
}

/// Wraps each tab's content with the custom AppTabBar at the bottom.
class _TabScreen extends ConsumerWidget {
  final int tabIndex;

  const _TabScreen({required this.tabIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabIndexProvider);

    return Stack(
      children: [
        // Tab content with bottom padding so content clears the tab bar
        Positioned.fill(
          child: _tabContent(tabIndex),
        ),
        // Custom tab bar pinned at the bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AppTabBar(
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(currentTabIndexProvider.notifier).state = index;
            },
          ),
        ),
      ],
    );
  }

  Widget _tabContent(int index) {
    switch (index) {
      case 0:
        return const LearningScreen();
      case 1:
        return const CollectionsScreen();
      case 2:
        return const NewCardScreen();
      case 3:
        return const StatisticsScreen();
      case 4:
        return const SettingsScreen();
      default:
        return const _PlaceholderScreen(title: 'Learn');
    }
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
        border: null,
      ),
      child: const SafeArea(
        child: Center(
          child: Text('Coming soon'),
        ),
      ),
    );
  }
}
