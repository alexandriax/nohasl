import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/curriculum.dart';
import 'state/learning_store.dart';
import 'ui/design.dart';
import 'ui/learning_pages.dart';
import 'ui/conversation_page.dart';
import 'ui/practice_lab.dart';
import 'ui/review_hub.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = LearningStore(await SharedPreferences.getInstance());
  runApp(NohaslApp(store: store));
}

class NohaslApp extends StatelessWidget {
  const NohaslApp({super.key, required this.store});
  final LearningStore store;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'nohasl — A little practice. A world of connection.',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      fontFamily: 'Manrope',
      colorScheme: ColorScheme.fromSeed(
        seedColor: green,
        primary: green,
        surface: paper,
      ),
      dividerColor: line,
      textTheme: TextTheme(
        bodyMedium: ts(14),
        bodyLarge: ts(16),
        titleLarge: ts(24, weight: FontWeight.w700),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
        elevation: 0,
      ),
      tooltipTheme: TooltipThemeData(textStyle: ts(12, color: Colors.white)),
    ),
    home: AppShell(store: store),
  );
}

const navItems = [
  ('Overview', Icons.grid_view_rounded),
  ('Learning path', Icons.route_rounded),
  ('Practice studio', Icons.gesture_rounded),
  ('Stories', Icons.auto_stories_outlined),
  ('Sign library', Icons.search_rounded),
  ('My progress', Icons.insights_rounded),
  ('Conversation room', Icons.forum_outlined),
  ('Review & portfolio', Icons.history_edu_outlined),
];

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.store});
  final LearningStore store;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int page = 0;
  final contentScroll = ScrollController();
  @override
  void dispose() {
    contentScroll.dispose();
    super.dispose();
  }

  void navigate(int index) {
    if (contentScroll.hasClients) contentScroll.jumpTo(0);
    setState(() => page = index);
  }

  void launch(Lesson lesson) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LessonPlayer(lesson: lesson, store: widget.store),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.store,
    builder: (context, _) => LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 1000;
        return Scaffold(
          drawer: desktop
              ? null
              : Drawer(
                  backgroundColor: paper,
                  child: SafeArea(child: sidebar(closeDrawer: true)),
                ),
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (desktop) SizedBox(width: 232, child: sidebar()),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 84,
                        padding: EdgeInsets.symmetric(
                          horizontal: desktop ? 38 : 20,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: line)),
                        ),
                        child: Row(
                          children: [
                            if (!desktop)
                              Builder(
                                builder: (context) => IconButton(
                                  tooltip: 'Open navigation',
                                  onPressed: () =>
                                      Scaffold.of(context).openDrawer(),
                                  icon: const Icon(Icons.menu_rounded),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                navItems[page].$1,
                                style: ts(14, weight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (constraints.maxWidth > 500) ...[
                              Icon(
                                Icons.local_fire_department_outlined,
                                color: green,
                                size: 19,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${widget.store.streak} day streak',
                                style: ts(12, weight: FontWeight.w700),
                              ),
                              const SizedBox(width: 24),
                              Container(width: 1, height: 20, color: line),
                              const SizedBox(width: 24),
                            ],
                            const Icon(
                              Icons.bolt_rounded,
                              color: Color(0xFFB48A28),
                              size: 19,
                            ),
                            Text(
                              '${widget.store.xp} XP',
                              style: ts(12, weight: FontWeight.w700),
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              tooltip: 'Learning preferences',
                              onPressed: () =>
                                  showPreferences(context, widget.store),
                              icon: const CircleAvatar(
                                radius: 18,
                                backgroundColor: mint,
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  color: green,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Scrollbar(
                          controller: contentScroll,
                          child: SingleChildScrollView(
                            primary: false,
                            key: ValueKey(page),
                            controller: contentScroll,
                            padding: EdgeInsets.fromLTRB(
                              desktop ? 38 : 20,
                              desktop ? 32 : 25,
                              desktop ? 38 : 20,
                              32,
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1280,
                                ),
                                child: switch (page) {
                                  0 => Dashboard(
                                    store: widget.store,
                                    onNavigate: navigate,
                                    onLesson: launch,
                                  ),
                                  1 => LearningPath(
                                    store: widget.store,
                                    onLesson: launch,
                                  ),
                                  2 => PracticeLab(store: widget.store),
                                  3 => StoriesPage(
                                    store: widget.store,
                                    onLesson: launch,
                                  ),
                                  4 => LibraryPage(store: widget.store),
                                  6 => ConversationPage(store: widget.store),
                                  7 => ReviewHub(store: widget.store),
                                  _ => ProgressPage(
                                    store: widget.store,
                                    onNavigate: navigate,
                                  ),
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  height: 68,
                  selectedIndex: page < 3
                      ? page
                      : page == 6
                      ? 3
                      : 4,
                  onDestinationSelected: (v) => navigate(
                    v < 3
                        ? v
                        : v == 3
                        ? 6
                        : 7,
                  ),
                  backgroundColor: paper,
                  indicatorColor: mint,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.grid_view_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.route_rounded),
                      label: 'Learn',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.gesture_rounded),
                      label: 'Practice',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.forum_outlined),
                      label: 'Talk',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.history_edu_outlined),
                      label: 'Review',
                    ),
                  ],
                ),
        );
      },
    ),
  );
  Widget sidebar({bool closeDrawer = false}) => LayoutBuilder(
    builder: (context, bounds) => SingleChildScrollView(
      primary: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: bounds.maxHeight),
        child: IntrinsicHeight(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: line)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 31, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.gesture_rounded,
                          color: lime,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'nohasl',
                            style: ts(
                              27,
                              weight: FontWeight.w800,
                              spacing: -1.4,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 3, bottom: 14),
                        child: Text(
                          '✦',
                          style: TextStyle(color: green, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 46),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'YOUR LEARNING SPACE',
                    style: ts(
                      9,
                      color: muted,
                      weight: FontWeight.w800,
                      spacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                for (var i = 0; i < navItems.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Material(
                      color: page == i ? mint : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          navigate(i);
                          if (closeDrawer) Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                navItems[i].$2,
                                color: page == i ? green : muted,
                                size: 20,
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Text(
                                  navItems[i].$1,
                                  style: ts(
                                    12,
                                    color: page == i ? green : muted,
                                    weight: page == i
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (i == 2)
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF0E7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        color: green,
                        size: 22,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'A little, every day.',
                        style: ts(13, weight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Make room for connection. Your next few minutes count.',
                        style: ts(11, color: muted, height: 1.7),
                      ),
                      const SizedBox(height: 9),
                      InkWell(
                        onTap: () => showPreferences(context, widget.store),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Set your daily goal  ↗',
                            style: ts(
                              11,
                              color: green,
                              weight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                TextButton.icon(
                  onPressed: () => showPreferences(context, widget.store),
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: Text('Preferences', style: ts(12, color: muted)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'ASL. A world of connection.',
                    style: ts(9, color: muted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
    required this.store,
    required this.onNavigate,
    required this.onLesson,
  });
  final LearningStore store;
  final ValueChanged<int> onNavigate;
  final ValueChanged<Lesson> onLesson;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final wide = c.maxWidth > 840;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'A LITTLE PRACTICE. A WORLD OF CONNECTION.',
                  style: ts(
                    9,
                    color: green,
                    weight: FontWeight.w800,
                    spacing: 1.7,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            store.completed.isEmpty
                ? 'Your next chapter starts here.'
                : 'Good to see you again.',
            style: ts(
              c.maxWidth < 600 ? 29 : 35,
              weight: FontWeight.w800,
              spacing: -1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find your voice in a whole new way. Let’s get your hands moving.',
            style: ts(13, color: muted),
          ),
          const SizedBox(height: 27),
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 72, child: mainColumn(context)),
                const SizedBox(width: 24),
                Expanded(flex: 28, child: sideColumn(context)),
              ],
            )
          else ...[
            mainColumn(context),
            const SizedBox(height: 24),
            sideColumn(context),
          ],
          const SizedBox(height: 26),
          Row(
            children: [
              const Icon(Icons.spa_outlined, size: 16, color: green),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'A visual language. A living culture. A journey worth taking.',
                  style: ts(11, color: muted),
                ),
              ),
              const Pill(
                'EARLY PREVIEW',
                color: Color(0xFFEEF0E8),
                foreground: muted,
              ),
            ],
          ),
        ],
      );
    },
  );
  Widget mainColumn(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ActionChip(
            avatar: const Icon(Icons.forum_outlined, size: 16),
            label: Text(
              'Start a conversation',
              style: ts(11, color: green, weight: FontWeight.w700),
            ),
            onPressed: () => onNavigate(6),
          ),
          ActionChip(
            avatar: const Icon(Icons.replay_rounded, size: 16),
            label: Text(
              '${store.dueReviewCount} reviews due',
              style: ts(11, color: green, weight: FontWeight.w700),
            ),
            onPressed: () => onNavigate(7),
          ),
        ],
      ),
      const SizedBox(height: 15),
      LayoutBuilder(
        builder: (context, c) => Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: mint,
            borderRadius: BorderRadius.circular(23),
          ),
          child: Stack(
            children: [
              if (c.maxWidth > 600)
                Positioned(
                  right: -20,
                  bottom: -13,
                  width: c.maxWidth * .44,
                  height: 288,
                  child: const HandsArt(),
                ),
              Padding(
                padding: const EdgeInsets.all(28),
                child: SizedBox(
                  width: c.maxWidth > 600 ? c.maxWidth * .52 : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Pill(
                        'YOUR JOURNEY, ONE SIGN AT A TIME',
                        color: Color(0xFFD5E8C4),
                        foreground: green,
                      ),
                      const SizedBox(height: 19),
                      Text(
                        'Small gestures.\nBig connections.',
                        style: ts(
                          c.maxWidth > 600 ? 35 : 32,
                          weight: FontWeight.w800,
                          height: 1.13,
                          spacing: -1.2,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'From your first hello to stories only you can tell. Build confidence, one practice at a time.',
                        style: ts(
                          12,
                          color: const Color(0xFF5E745E),
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ActionButton(
                        store.completed.isEmpty
                            ? 'Start my journey'
                            : 'Continue learning',
                        onTap: () => onLesson(store.nextLesson),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: green,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${store.nextLesson.minutes} min  ·  At your own pace',
                            style: ts(10, color: green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 27),
      sectionTitle(
        'Make it a daily thing.',
        trailing: 'Explore practice',
        onTap: () => onNavigate(2),
      ),
      const SizedBox(height: 15),
      LayoutBuilder(
        builder: (context, c) {
          final cards = [
            activityCard(
              'The practice studio',
              'Hands up. Camera on.\nConfidence, in the making.',
              Icons.front_hand_outlined,
              peach,
              () => onNavigate(2),
              'LET’S GET HANDS-ON',
            ),
            activityCard(
              'A story worth signing',
              'Step into everyday moments.\nBe part of the conversation.',
              Icons.auto_stories_outlined,
              const Color(0xFFE8E5F2),
              () => onNavigate(3),
              'LEARN THROUGH STORIES',
            ),
          ];
          return c.maxWidth > 500
              ? Row(
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 16),
                    Expanded(child: cards[1]),
                  ],
                )
              : Column(
                  children: [cards[0], const SizedBox(height: 14), cards[1]],
                );
        },
      ),
      const SizedBox(height: 27),
      sectionTitle(
        'Your learning path',
        trailing: 'View full path',
        onTap: () => onNavigate(1),
      ),
      const SizedBox(height: 14),
      Surface(
        padding: const EdgeInsets.all(21),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: mint,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.eco_outlined, color: green),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LEVEL 01 · FOUNDATIONS',
                        style: ts(
                          9,
                          color: green,
                          weight: FontWeight.w800,
                          spacing: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Every connection begins with hello.',
                        style: ts(13, weight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Open learning path',
                  onPressed: () => onNavigate(1),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 22),
            LinearProgressIndicator(
              value:
                  courseLevels.first.units
                      .expand((u) => u.lessons)
                      .where((l) => store.completed.contains(l.id))
                      .length /
                  courseLevels.first.units.expand((u) => u.lessons).length,
              color: green,
              backgroundColor: line,
              minHeight: 6,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${store.completed.where((id) => courseLevels.first.units.any((u) => u.lessons.any((l) => l.id == id))).length} of ${courseLevels.first.units.expand((u) => u.lessons).length} activities explored',
                    style: ts(10, color: muted),
                  ),
                ),
                Text(
                  'Build your foundation',
                  style: ts(10, color: green, weight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
  Widget sideColumn(BuildContext context) => Column(
    children: [
      Surface(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Your daily intention',
                    style: ts(13, weight: FontWeight.w800),
                  ),
                ),
                const Icon(Icons.wb_sunny_outlined, color: green, size: 19),
              ],
            ),
            const SizedBox(height: 23),
            Center(
              child: SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 132,
                      height: 132,
                      child: CircularProgressIndicator(
                        value: (store.todayMinutes / store.dailyGoal).clamp(
                          0,
                          1,
                        ),
                        strokeWidth: 8,
                        backgroundColor: const Color(0xFFEBEFE4),
                        color: green,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${store.todayMinutes}',
                          style: ts(39, weight: FontWeight.w800, spacing: -1),
                        ),
                        Text(
                          'of ${store.dailyGoal} minutes',
                          style: ts(10, color: muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 19),
            Center(
              child: Text(
                store.todayMinutes == 0
                    ? 'A fresh start feels good.'
                    : 'Look at you showing up.',
                style: ts(12, weight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 7),
            Center(
              child: Text(
                'A few focused minutes go a long way.',
                textAlign: TextAlign.center,
                style: ts(10, color: muted),
              ),
            ),
            const SizedBox(height: 20),
            weekRow(store),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department_outlined,
                  color: Color(0xFFB07A47),
                  size: 19,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    '${store.streak} day streak',
                    style: ts(11, weight: FontWeight.w700),
                  ),
                ),
                Text('You’ve got this', style: ts(9, color: muted)),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(23),
        decoration: BoxDecoration(
          color: ink,
          borderRadius: BorderRadius.circular(21),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: lime,
                  size: 19,
                ),
                const SizedBox(width: 8),
                Text(
                  'MORE THAN HANDS',
                  style: ts(
                    9,
                    color: lime,
                    weight: FontWeight.w800,
                    spacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Your face is part\nof the conversation.',
              style: ts(
                20,
                color: Colors.white,
                weight: FontWeight.w700,
                height: 1.35,
                spacing: -.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'In ASL, expression carries meaning. Your eyebrows, gaze, and body all have something to say.',
              style: ts(11, color: const Color(0xFFBACAC1), height: 1.8),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => onLesson(
                allLessons.firstWhere(
                  (l) => l.title.toLowerCase().contains('face'),
                  orElse: () => starterLesson,
                ),
              ),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                'Explore the foundations  ↗',
                style: ts(11, color: lime, weight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    ],
  );
  Widget activityCard(
    String title,
    String body,
    IconData icon,
    Color color,
    VoidCallback onTap,
    String kicker,
  ) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(19),
      side: const BorderSide(color: line),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(21),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: ink, size: 23),
                ),
                const Spacer(),
                const Icon(Icons.north_east_rounded, color: muted, size: 18),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              kicker,
              style: ts(8, color: muted, weight: FontWeight.w800, spacing: 1),
            ),
            const SizedBox(height: 6),
            Text(title, style: ts(17, weight: FontWeight.w800, spacing: -.4)),
            const SizedBox(height: 8),
            Text(body, style: ts(11, color: muted, height: 1.8)),
          ],
        ),
      ),
    ),
  );
}

Widget sectionTitle(String text, {String? trailing, VoidCallback? onTap}) =>
    Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: ts(18, weight: FontWeight.w800, spacing: -.5),
          ),
        ),
        if (trailing != null)
          TextButton(
            onPressed: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trailing,
                  style: ts(10, color: green, weight: FontWeight.w700),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.north_east_rounded, size: 12),
              ],
            ),
          ),
      ],
    );
Widget weekRow(LearningStore store) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: List.generate(7, (i) {
    final now = DateTime.now();
    final day = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1 - i));
    final done = store.activity.containsKey(store.dateKey(day));
    return Column(
      children: [
        Text(
          ['M', 'T', 'W', 'T', 'F', 'S', 'S'][i],
          style: ts(9, color: muted),
        ),
        const SizedBox(height: 7),
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(
            color: done
                ? green
                : i == now.weekday - 1
                ? mint
                : const Color(0xFFF2F4EC),
            shape: BoxShape.circle,
            border: i == now.weekday - 1 ? Border.all(color: green) : null,
          ),
          child: Icon(
            done ? Icons.check : Icons.circle,
            size: done ? 13 : 4,
            color: done ? Colors.white : const Color(0xFFC8D1C1),
          ),
        ),
      ],
    );
  }),
);

Future<void> showPreferences(
  BuildContext context,
  LearningStore store,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  backgroundColor: paper,
  builder: (context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.fromLTRB(28, 10, 28, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Make this your space.',
              style: ts(25, weight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              'Progress stays on this device. Camera frames are never stored or uploaded.',
              style: ts(12, color: muted),
            ),
            const SizedBox(height: 25),
            Text('Daily practice goal', style: ts(14, weight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                for (final goal in [5, 10, 15, 20])
                  ChoiceChip(
                    label: Text('$goal min'),
                    selected: store.dailyGoal == goal,
                    onSelected: (_) => store.setGoal(goal),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Gentle sound cues',
                style: ts(14, weight: FontWeight.w700),
              ),
              subtitle: Text(
                'Optional system sounds for lesson steps.\nAll feedback is also visual.',
                style: ts(11, color: muted),
              ),
              value: store.sound,
              onChanged: store.setSound,
            ),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'An early look at a bigger journey',
              style: ts(14, weight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'This preview includes authored lesson concepts and self-review practice. Fluent-signer video lessons and validated sign assessment are planned. The expanded program includes guided practice, self-reported retrieval scheduling, and on-device conversation scenarios on compatible Apple devices. Course completion measures participation, not proficiency.',
              style: ts(12, color: muted, height: 1.8),
            ),
            if (store.storageError)
              Text(
                'We could not save your latest changes to this device.',
                style: ts(12, color: Colors.red),
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Reset local progress?'),
                    content: const Text(
                      'This clears lesson completion, practice activity and saved signs on this device.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Keep progress'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) await store.reset();
              },
              child: const Text('Reset local progress'),
            ),
          ],
        ),
      ),
    ),
  ),
);
