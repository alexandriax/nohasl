import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/curriculum.dart';
import '../state/learning_store.dart';
import '../features/practice/camera_stage.dart';
import 'design.dart';
import 'program_explorer.dart';

String modeLabel(LessonMode mode) => switch (mode) {
  LessonMode.guided => 'Guided lesson',
  LessonMode.camera => 'Camera practice',
  LessonMode.story => 'Story moment',
  LessonMode.conversation => 'Conversation',
  LessonMode.recall => 'Recall challenge',
};
IconData modeIcon(LessonMode mode) => switch (mode) {
  LessonMode.guided => Icons.play_circle_outline_rounded,
  LessonMode.camera => Icons.videocam_outlined,
  LessonMode.story => Icons.auto_stories_outlined,
  LessonMode.conversation => Icons.forum_outlined,
  LessonMode.recall => Icons.style_outlined,
};
Widget pageIntro(String eyebrow, String title, String subtitle) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      eyebrow,
      style: ts(9, color: green, weight: FontWeight.w800, spacing: 1.6),
    ),
    const SizedBox(height: 10),
    Text(title, style: ts(31, weight: FontWeight.w800, spacing: -1.2)),
    const SizedBox(height: 9),
    Text(subtitle, style: ts(13, color: muted, height: 1.7)),
    const SizedBox(height: 27),
  ],
);

class LearningPath extends StatelessWidget {
  const LearningPath({super.key, required this.store, required this.onLesson});
  final LearningStore store;
  final ValueChanged<Lesson> onLesson;
  @override
  Widget build(BuildContext context) =>
      ProgramExplorer(store: store, onLesson: onLesson);
}

Widget lessonRow(Lesson lesson, bool completed, VoidCallback onTap) => Material(
  color: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: const BorderSide(color: line),
  ),
  clipBehavior: Clip.antiAlias,
  child: InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: completed ? mint : paper,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              completed ? Icons.check_rounded : modeIcon(lesson.mode),
              color: green,
              size: 21,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.title, style: ts(13, weight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  '${modeLabel(lesson.mode)} · ${lesson.minutes} min · ${lesson.xp} XP',
                  style: ts(10, color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            completed ? Icons.replay_rounded : Icons.arrow_forward_rounded,
            color: muted,
            size: 19,
          ),
        ],
      ),
    ),
  ),
);

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});
  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  String prompt = 'Visual attention';
  final prompts = [
    'Visual attention',
    'Your introduction',
    'A familiar sign',
    'Facial expression',
    'Tell a short story',
  ];
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pageIntro(
        'THE PRACTICE STUDIO',
        'Confidence looks good on you.',
        'A little space to try, repeat, and find your rhythm. Your camera is your mirror.',
      ),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final p in prompts)
            ChoiceChip(
              label: Text(p, style: ts(11)),
              selected: prompt == p,
              onSelected: (_) => setState(() => prompt = p),
            ),
        ],
      ),
      const SizedBox(height: 22),
      CameraStage(key: ValueKey(prompt), signWord: prompt),
      const SizedBox(height: 22),
      LayoutBuilder(
        builder: (context, c) {
          final tips = [
            tipCard(
              '01',
              'Frame your signing space',
              'Keep your face, both hands, and upper body visible.',
              Icons.crop_free_rounded,
            ),
            tipCard(
              '02',
              'Bring the whole expression',
              'Notice your gaze and posture alongside your hands.',
              Icons.face_outlined,
            ),
            tipCard(
              '03',
              'Reflect, then try again',
              'Compare with a trusted fluent-signer reference.',
              Icons.replay_rounded,
            ),
          ];
          return c.maxWidth > 650
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < 3; i++) ...[
                      Expanded(child: tips[i]),
                      if (i < 2) const SizedBox(width: 15),
                    ],
                  ],
                )
              : Column(
                  children: [
                    for (final tip in tips) ...[
                      tip,
                      const SizedBox(height: 12),
                    ],
                  ],
                );
        },
      ),
      const SizedBox(height: 15),
      Text(
        'Mirror practice is self-review. This preview does not recognize or grade ASL signs. No video or audio is recorded.',
        style: ts(11, color: muted, height: 1.7),
      ),
    ],
  );
  Widget tipCard(String number, String title, String body, IconData icon) =>
      Surface(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: green, size: 23),
                const Spacer(),
                Text(number, style: ts(10, color: muted)),
              ],
            ),
            const SizedBox(height: 14),
            Text(title, style: ts(13, weight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(body, style: ts(11, color: muted, height: 1.8)),
          ],
        ),
      );
}

class LessonPlayer extends StatefulWidget {
  const LessonPlayer({super.key, required this.lesson, required this.store});
  final Lesson lesson;
  final LearningStore store;
  @override
  State<LessonPlayer> createState() => _LessonPlayerState();
}

class _LessonPlayerState extends State<LessonPlayer>
    with WidgetsBindingObserver {
  int step = 0;
  int? answer;
  bool checked = false;
  bool finished = false;
  bool saving = false;
  final watch = Stopwatch();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    watch.start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !finished) {
      watch.start();
    } else {
      watch.stop();
    }
  }

  @override
  void dispose() {
    watch.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> next() async {
    if (saving || finished) return;
    final item = widget.lesson.steps[step];
    if (item.choices.isNotEmpty && !checked) {
      setState(() => checked = true);
      return;
    }
    if (item.correctChoice != null && answer != item.correctChoice) return;
    if (widget.store.sound) unawaited(SystemSound.play(SystemSoundType.click));
    unawaited(HapticFeedback.selectionClick());
    if (step < widget.lesson.steps.length - 1) {
      setState(() {
        step++;
        answer = null;
        checked = false;
      });
    } else {
      setState(() => saving = true);
      watch.stop();
      await widget.store.complete(
        widget.lesson,
        activeSeconds: watch.elapsed.inSeconds,
      );
      if (mounted) {
        setState(() {
          saving = false;
          finished = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final item = lesson.steps[step];
    final unit = courseLevels
        .expand((l) => l.units)
        .where((u) => u.lessons.any((l) => l.id == lesson.id))
        .firstOrNull;
    final correct = item.correctChoice == null || answer == item.correctChoice;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Close lesson',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(lesson.title, style: ts(14, weight: FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Pill(
              finished ? 'COMPLETE' : '${step + 1} / ${lesson.steps.length}',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: finished
                  ? completion()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: (step + 1) / lesson.steps.length,
                          backgroundColor: line,
                          color: green,
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 5,
                        ),
                        const SizedBox(height: 28),
                        if (lesson.requiresReferenceVideo && step == 0) ...[
                          Surface(
                            color: peach,
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bring a fluent-signer reference',
                                  style: ts(15, weight: FontWeight.w800),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'This activity needs an authentic sign demonstration or partner. Reviewed in-app signer media is pending. Use a trusted source before practicing unfamiliar language.',
                                  style: ts(12, height: 1.8),
                                ),
                                if (unit != null)
                                  TextButton.icon(
                                    onPressed: () =>
                                        showReferences(context, unit),
                                    icon: const Icon(
                                      Icons.open_in_new_rounded,
                                      size: 16,
                                    ),
                                    label: const Text(
                                      'Open educator references',
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                        Pill(
                          modeLabel(lesson.mode).toUpperCase(),
                          icon: modeIcon(lesson.mode),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          item.title,
                          style: ts(30, weight: FontWeight.w800, spacing: -1),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          item.body,
                          style: ts(
                            15,
                            color: const Color(0xFF5C6D63),
                            height: 1.9,
                          ),
                        ),
                        const SizedBox(height: 26),
                        if (item.signWord != null ||
                            step == lesson.steps.length - 1) ...[
                          CameraStage(
                            key: ValueKey('$step'),
                            signWord: item.signWord ?? lesson.title,
                          ),
                          const SizedBox(height: 24),
                        ],
                        Surface(
                          color: mint,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.tips_and_updates_outlined,
                                color: green,
                                size: 21,
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Text(
                                  item.prompt,
                                  style: ts(
                                    14,
                                    color: green,
                                    weight: FontWeight.w600,
                                    height: 1.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        for (var i = 0; i < item.choices.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Material(
                              color: answer == i
                                  ? checked
                                        ? (correct ? mint : peach)
                                        : mint
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                  color: answer == i ? green : line,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => setState(() {
                                  answer = i;
                                  checked = false;
                                }),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Row(
                                    children: [
                                      Icon(
                                        answer == i
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        color: green,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 13),
                                      Expanded(
                                        child: Text(
                                          item.choices[i],
                                          style: ts(
                                            13,
                                            weight: FontWeight.w600,
                                            height: 1.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (checked) ...[
                          const SizedBox(height: 8),
                          Text(
                            correct
                                ? 'That’s the idea. Take it into your next practice.'
                                : 'Take another look at the lesson, then try a different answer.',
                            style: ts(
                              13,
                              color: correct ? green : const Color(0xFFA76634),
                              weight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (step > 0)
                              TextButton(
                                onPressed: () => setState(() {
                                  step--;
                                  answer = null;
                                  checked = false;
                                }),
                                child: const Text('Back'),
                              ),
                            const Spacer(),
                            ActionButton(
                              saving
                                  ? 'Saving…'
                                  : item.choices.isNotEmpty && !checked
                                  ? 'Check answer'
                                  : step == lesson.steps.length - 1
                                  ? 'Complete reflection'
                                  : 'Continue',
                              onTap:
                                  saving ||
                                      (item.choices.isNotEmpty &&
                                          answer == null) ||
                                      (checked && !correct)
                                  ? null
                                  : next,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Authored preview · Camera work is self-review. Participation earns XP; it does not certify sign accuracy.',
                          style: ts(10, color: muted),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget completion() => Column(
    children: [
      const SizedBox(height: 35),
      Container(
        width: 95,
        height: 95,
        decoration: const BoxDecoration(color: mint, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, color: green, size: 48),
      ),
      const SizedBox(height: 27),
      Text(
        'One step closer.',
        style: ts(36, weight: FontWeight.w800, spacing: -1),
      ),
      const SizedBox(height: 12),
      Text(
        'You made time for connection.\nThat’s something to feel good about.',
        textAlign: TextAlign.center,
        style: ts(15, color: muted, height: 1.8),
      ),
      const SizedBox(height: 24),
      Pill(
        widget.store.storageError
            ? 'Progress held in memory · Could not save'
            : '${widget.lesson.xp} XP lesson · Progress saved',
        icon: Icons.bolt_rounded,
      ),
      const SizedBox(height: 24),
      Surface(
        child: Column(
          children: [
            Text(
              'Take it into the world',
              style: ts(17, weight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              'Return to a trusted fluent-signer example and practice with feedback. A completed lesson is a starting point for conversation.',
              textAlign: TextAlign.center,
              style: ts(13, color: muted, height: 1.8),
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      ActionButton('Back to my journey', onTap: () => Navigator.pop(context)),
    ],
  );
}

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key, required this.store, required this.onLesson});
  final LearningStore store;
  final ValueChanged<Lesson> onLesson;
  @override
  Widget build(BuildContext context) {
    final stories = courseLevels
        .expand((l) => l.units.take(2))
        .expand((u) => u.lessons)
        .where(
          (l) =>
              l.mode == LessonMode.story || l.mode == LessonMode.conversation,
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pageIntro(
          'LITTLE STORIES. REAL CONNECTIONS.',
          'Step into the conversation.',
          'Everyday places. New perspectives. Practice the moments that bring us together.',
        ),
        LayoutBuilder(
          builder: (context, c) => Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              for (var i = 0; i < 3; i++)
                SizedBox(
                  width: c.maxWidth > 850
                      ? (c.maxWidth - 40) / 3
                      : c.maxWidth > 550
                      ? (c.maxWidth - 20) / 2
                      : c.maxWidth,
                  child: storyCard(context, i),
                ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'Keep the conversation going',
          style: ts(20, weight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Guided scenarios to build your visual conversation habits.',
          style: ts(12, color: muted),
        ),
        const SizedBox(height: 19),
        for (final lesson in stories)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: lessonRow(
              lesson,
              store.completed.contains(lesson.id),
              () => onLesson(lesson),
            ),
          ),
      ],
    );
  }

  Widget storyCard(BuildContext context, int i) {
    final titles = [
      'An afternoon at the café',
      'A new face next door',
      'The weekend plan',
    ];
    final subtitles = [
      'A warm welcome starts with attention.',
      'Meet someone new. Find a shared connection.',
      'Make a plan, together. Leave room for surprises.',
    ];
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
        side: const BorderSide(color: line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => StoryPlayer(scene: i)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(aspectRatio: 1.8, child: SceneArt(scene: i)),
            Padding(
              padding: const EdgeInsets.all(21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Pill(
                    'EPISODE 0${i + 1} · INTERACTIVE',
                    color: [peach, mint, const Color(0xFFE8E5F2)][i],
                  ),
                  const SizedBox(height: 14),
                  Text(titles[i], style: ts(17, weight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(subtitles[i], style: ts(11, color: muted, height: 1.8)),
                  const SizedBox(height: 19),
                  Row(
                    children: [
                      Text(
                        'Enter the story',
                        style: ts(12, color: green, weight: FontWeight.w800),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryPlayer extends StatefulWidget {
  const StoryPlayer({super.key, required this.scene});
  final int scene;
  @override
  State<StoryPlayer> createState() => _StoryPlayerState();
}

class _StoryPlayerState extends State<StoryPlayer> {
  int step = 0;
  String? response;
  bool practice = false;
  @override
  Widget build(BuildContext context) {
    final titles = [
      'An afternoon at the café',
      'A new face next door',
      'The weekend plan',
    ];
    final people = ['Alex', 'Sam', 'Jordan'];
    final person = people[widget.scene];
    final prompts = [
      [
        'You arrive at a neighborhood café. $person is looking at the menu. How will you open a visual conversation?',
        'You have $person’s attention. They sign something you don’t understand. What comes next?',
        'The conversation slows down and you find your rhythm. Rehearse a greeting you already know, or simply practice shifting from looking to signing.',
      ],
      [
        'You meet $person in the shared garden. You want to introduce yourself. Where do you begin?',
        '$person fingerspells their name, but you miss the final letters. How can you keep the exchange comfortable?',
        'You have made your first connection. Practice a short introduction using signs you have learned from a fluent signer.',
      ],
      [
        'You and $person are planning a weekend outing. How do you arrange a comfortable conversation?',
        '$person suggests a time you missed. How do you make sure you both have the same plan?',
        'Rehearse a short invitation using known signs. Leave a pause for your partner’s response.',
      ],
    ][widget.scene];
    final choices = step == 0
        ? [
            'Wait for a clear line of sight, then make a small wave.',
            'Begin signing while they are looking away.',
          ]
        : [
            'Ask for a repeat or slower signing, then confirm understanding.',
            'Pretend to understand and move on.',
          ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[widget.scene],
          style: ts(14, weight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: AspectRatio(
                    aspectRatio: 2.5,
                    child: SceneArt(scene: widget.scene),
                  ),
                ),
                const SizedBox(height: 25),
                Pill('SCENE ${step + 1} OF 3 · TEXT SCENARIO'),
                const SizedBox(height: 20),
                Text(
                  prompts[step],
                  style: ts(23, weight: FontWeight.w700, height: 1.6),
                ),
                const SizedBox(height: 22),
                if (step < 2) ...[
                  for (var i = 0; i < choices.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: OutlinedButton(
                        onPressed: () => setState(
                          () => response = i == 0
                              ? 'You create space for a clear, shared conversation.'
                              : 'The connection gets lost. Try making attention and understanding part of the exchange.',
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.centerLeft,
                          side: const BorderSide(color: line),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(choices[i], style: ts(14)),
                      ),
                    ),
                  if (response != null) ...[
                    const SizedBox(height: 12),
                    Surface(
                      color: mint,
                      child: Text(
                        response!,
                        style: ts(14, color: green, height: 1.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ActionButton(
                      'Continue the story',
                      onTap: () => setState(() {
                        step++;
                        response = null;
                      }),
                    ),
                  ],
                ] else ...[
                  if (practice)
                    const CameraStage(
                      signWord: 'A conversation with a new friend',
                    )
                  else
                    ActionButton(
                      'Open my practice mirror',
                      icon: Icons.videocam_outlined,
                      onTap: () => setState(() => practice = true),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'This is a text-based rehearsal. Signed dialogue with Deaf actors is planned for the full story experience.',
                    style: ts(12, color: muted, height: 1.8),
                  ),
                  const SizedBox(height: 22),
                  ActionButton(
                    'Finish story',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const seedLibraryEntries = <({String word, String category, String note})>[
  (
    word: 'Hello',
    category: 'Connections',
    note:
        'A starting point for a greeting. Watch a fluent signer model the movement and natural expression.',
  ),
  (
    word: 'Thank you',
    category: 'Connections',
    note:
        'Notice handshape, palm orientation, location and movement together. Compare with a trusted reference.',
  ),
  (
    word: 'Please',
    category: 'Connections',
    note:
        'Politeness depends on context and expression as well as a vocabulary item.',
  ),
  (
    word: 'Name',
    category: 'Connections',
    note:
        'Practice introductions with fingerspelling and clear visual turn-taking.',
  ),
  (
    word: 'Understand',
    category: 'Everyday',
    note:
        'Use this concept to explore clarification and repair during a conversation.',
  ),
  (
    word: 'Again',
    category: 'Everyday',
    note:
        'Clarification is part of learning. Invite a partner to repeat when you miss something.',
  ),
  (
    word: 'Friend',
    category: 'People',
    note:
        'Vocabulary connects to real people and relationships. Learn it in a conversation.',
  ),
  (
    word: 'Family',
    category: 'People',
    note:
        'Explore relationships using space and reference points with a fluent signer.',
  ),
  (
    word: 'Learn',
    category: 'Everyday',
    note:
        'Notice how handshape and movement work together in a fluent-signer reference.',
  ),
  (
    word: 'Coffee',
    category: 'Everyday',
    note: 'Use a familiar place as the setting for a short signed exchange.',
  ),
  (
    word: 'Today',
    category: 'Time',
    note: 'Time expressions help establish when a signed story takes place.',
  ),
  (
    word: 'Tomorrow',
    category: 'Time',
    note:
        'Build a short invitation around a future time with an educator-reviewed example.',
  ),
  (
    word: 'Where',
    category: 'Questions',
    note:
        'WH questions involve nonmanual grammar. Observe the face and body in context.',
  ),
  (
    word: 'Who',
    category: 'Questions',
    note:
        'Learn the question as a whole utterance, including the nonmanual features.',
  ),
  (
    word: 'What',
    category: 'Questions',
    note:
        'Question forms vary by purpose and context. A word list alone is not enough.',
  ),
];

final libraryEntries = buildLibraryEntries();
List<({String word, String category, String note})> buildLibraryEntries() {
  final items = [...seedLibraryEntries];
  final seen = items.map((e) => e.word.toLowerCase()).toSet();
  for (var level = 0; level < courseLevels.length; level++) {
    for (final unit in courseLevels[level].units) {
      for (final word in unit.vocabulary) {
        if (seen.add(word.toLowerCase())) {
          items.add((
            word: word,
            category: 'Stage ${level + 1}',
            note:
                '${unit.title}: ${unit.description} Learn this concept from a fluent signer in context.',
          ));
        }
      }
    }
  }
  return List.unmodifiable(items);
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key, required this.store});
  final LearningStore store;
  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int visibleLimit = 30;
  String query = '';
  String filter = 'All signs';
  bool savedOnly = false;
  @override
  Widget build(BuildContext context) {
    final entries = libraryEntries
        .where(
          (e) =>
              e.word.toLowerCase().contains(query.toLowerCase()) &&
              (filter == 'All signs' || e.category == filter) &&
              (!savedOnly || widget.store.saved.contains(e.word)),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pageIntro(
          'YOUR GROWING COLLECTION',
          'A little curiosity goes a long way.',
          'Explore practice prompts, save what matters, and come back for another look.',
        ),
        TextField(
          onChanged: (v) => setState(() {
            query = v;
            visibleLimit = 30;
          }),
          decoration: InputDecoration(
            hintText: 'Find a sign to explore…',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: line),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in [
              'All signs',
              'Connections',
              'Everyday',
              'People',
              'Time',
              'Questions',
              for (var stage = 1; stage <= courseLevels.length; stage++)
                'Stage $stage',
            ])
              ChoiceChip(
                label: Text(c, style: ts(11)),
                selected: filter == c,
                onSelected: (_) => setState(() {
                  filter = c;
                  visibleLimit = 30;
                }),
              ),
            FilterChip(
              label: const Text('Saved'),
              avatar: const Icon(Icons.bookmark_outline_rounded, size: 15),
              selected: savedOnly,
              onSelected: (v) => setState(() => savedOnly = v),
            ),
          ],
        ),
        const SizedBox(height: 23),
        Surface(
          color: mint,
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: green, size: 19),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Practice prompt collection · Verified sign videos are coming. These cards describe learning context, not how to produce a sign.',
                  style: ts(11, color: green, height: 1.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Text(
                'No signs here yet. Try another search or save a favorite.',
                style: ts(14, color: muted),
              ),
            ),
          ),
        LayoutBuilder(
          builder: (context, c) {
            final count = c.maxWidth > 900
                ? 3
                : c.maxWidth > 550
                ? 2
                : 1;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final entry in entries.take(visibleLimit))
                  SizedBox(
                    width: (c.maxWidth - (count - 1) * 16) / count,
                    child: Surface(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Pill(entry.category.toUpperCase()),
                              const Spacer(),
                              IconButton(
                                tooltip: widget.store.saved.contains(entry.word)
                                    ? 'Unsave ${entry.word}'
                                    : 'Save ${entry.word}',
                                onPressed: () =>
                                    widget.store.toggleSaved(entry.word),
                                icon: Icon(
                                  widget.store.saved.contains(entry.word)
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_outline_rounded,
                                  color: green,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            entry.word,
                            style: ts(
                              24,
                              weight: FontWeight.w800,
                              spacing: -.7,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            entry.note,
                            style: ts(11, color: muted, height: 1.8),
                          ),
                          const SizedBox(height: 17),
                          TextButton.icon(
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (context) => Dialog(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 850,
                                  ),
                                  child: SingleChildScrollView(
                                    primary: false,
                                    padding: const EdgeInsets.all(22),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Explore: ${entry.word}',
                                                style: ts(
                                                  21,
                                                  weight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'Close practice',
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              icon: const Icon(
                                                Icons.close_rounded,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          'Use a trusted signer demonstration first. Practice a sign you already know in the mirror below.',
                                          style: ts(12, color: muted),
                                        ),
                                        const SizedBox(height: 20),
                                        CameraStage(signWord: entry.word),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.videocam_outlined, size: 17),
                            label: Text(
                              'Practice mirror',
                              style: ts(
                                11,
                                color: green,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        if (entries.length > visibleLimit)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ActionButton(
              'Show more concepts (${entries.length - visibleLimit} remaining)',
              onTap: () => setState(() => visibleLimit += 30),
            ),
          ),
      ],
    );
  }
}

class ProgressPage extends StatelessWidget {
  const ProgressPage({
    super.key,
    required this.store,
    required this.onNavigate,
  });
  final LearningStore store;
  final ValueChanged<int> onNavigate;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pageIntro(
        'EVERY LITTLE EFFORT ADDS UP',
        'Look how you’re growing.',
        'Your journey is personal. Celebrate showing up, then keep making connections.',
      ),
      Wrap(
        spacing: 18,
        runSpacing: 18,
        children: [
          stat(
            'Lessons explored',
            '${store.completed.length}',
            Icons.menu_book_outlined,
          ),
          stat('Learning XP', '${store.xp}', Icons.bolt_rounded),
          stat(
            'Practice minutes',
            '${store.activity.values.fold<int>(0, (a, b) => a + b)}',
            Icons.schedule_rounded,
          ),
          stat(
            'Saved prompts',
            '${store.saved.length}',
            Icons.bookmark_outline_rounded,
          ),
        ],
      ),
      const SizedBox(height: 30),
      Text('Your six chapters', style: ts(20, weight: FontWeight.w800)),
      const SizedBox(height: 18),
      for (var i = 0; i < courseLevels.length; i++) ...[
        Builder(
          builder: (context) {
            final lessons = courseLevels[i].units
                .expand((u) => u.lessons)
                .toList();
            final done = lessons
                .where((l) => store.completed.contains(l.id))
                .length;
            return Surface(
              padding: const EdgeInsets.all(21),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '0${i + 1}',
                        style: ts(15, color: green, weight: FontWeight.w800),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          courseLevels[i].title,
                          style: ts(15, weight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        '$done / ${lessons.length}',
                        style: ts(12, color: muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: done / lessons.length,
                    color: green,
                    backgroundColor: line,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 13),
      ],
      const SizedBox(height: 12),
      Surface(
        color: mint,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connection is the real milestone.',
              style: ts(21, weight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              'These numbers track participation. Proficiency grows through meaningful practice, fluent-signer feedback, and conversations in the Deaf community.',
              style: ts(13, color: green, height: 1.8),
            ),
            const SizedBox(height: 18),
            ActionButton('Keep learning', onTap: () => onNavigate(1)),
          ],
        ),
      ),
    ],
  );
  Widget stat(String title, String value, IconData icon) => SizedBox(
    width: 210,
    child: Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: green, size: 24),
          const SizedBox(height: 17),
          Text(value, style: ts(34, weight: FontWeight.w800)),
          Text(title, style: ts(12, color: muted)),
        ],
      ),
    ),
  );
}
