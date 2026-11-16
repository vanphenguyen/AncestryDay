import 'package:flutter/material.dart';

import '../app.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'people_screen.dart';

/// The three tabs: what is coming, the family's book of remembrance days,
/// and the lunar calendar.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Coming back to the app: roll over to the new day and put the next
    // reminders on the phone's schedule.
    if (state == AppLifecycleState.resumed) AppScope.of(context).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppScope.textsOf(context).l10n;
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [
          HomeScreen(),
          SafeArea(bottom: false, child: PeopleScreen()),
          SafeArea(bottom: false, child: CalendarScreen()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.spa_outlined),
            selectedIcon: const Icon(Icons.spa),
            label: l10n.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.tabPeople,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: l10n.tabCalendar,
          ),
        ],
      ),
    );
  }
}
