import 'package:flutter/material.dart';
import '../data/practice_activities.dart';
import '../state/learning_store.dart';
import '../features/practice/camera_stage.dart';
import 'design.dart';
import 'learning_pages.dart' show PracticePage, pageIntro;

class PracticeLab extends StatefulWidget {
  const PracticeLab({super.key, required this.store});
  final LearningStore store;
  @override
  State<PracticeLab> createState() => _PracticeLabState();
}

class _PracticeLabState extends State<PracticeLab> {
  bool mirrorOnly = false;
  int level = 6;
  String kind = 'All';
  @override
  Widget build(BuildContext context) {
    if (mirrorOnly) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () => setState(() => mirrorOnly = false),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to activities'),
          ),
          const PracticePage(),
        ],
      );
    }
    final kinds = practiceActivities.map((a) => a.kind).toSet().toList();
    final selected = practiceActivities
        .where(
          (a) => a.minimumLevel <= level && (kind == 'All' || a.kind == kind),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pageIntro(
          'THE PRACTICE LAB',
          'Make the language yours.',
          'Build a scene. Trade missing information. Tell a story. Come back to what you almost remember.',
        ),
        Surface(
          color: mint,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${practiceActivities.length} ways to put learning into motion',
                      style: ts(22, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Each activity has a purpose, a camera rehearsal, and a reflection to carry forward.',
                      style: ts(12, color: green, height: 1.8),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: 'Open free practice mirror',
                onPressed: () => setState(() => mirrorOnly = true),
                icon: const Icon(
                  Icons.videocam_outlined,
                  size: 30,
                  color: green,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final k in ['All', ...kinds])
              ChoiceChip(
                label: Text(k.replaceAll('_', ' '), style: ts(11)),
                selected: kind == k,
                onSelected: (_) => setState(() => kind = k),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Show up to', style: ts(12, color: muted)),
            for (var i = 1; i <= 6; i++)
              ChoiceChip(
                label: Text('Stage $i', style: ts(10)),
                selected: level == i,
                onSelected: (_) => setState(() => level = i),
              ),
          ],
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, c) {
            final columns = c.maxWidth > 1000
                ? 3
                : c.maxWidth > 630
                ? 2
                : 1;
            return Wrap(
              spacing: 17,
              runSpacing: 17,
              children: [
                for (final a in selected)
                  SizedBox(
                    width: (c.maxWidth - (columns - 1) * 17) / columns,
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                        side: const BorderSide(color: line),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ActivitySession(
                              activity: a,
                              store: widget.store,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(21),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Pill(
                                    a.kind.replaceAll('_', ' ').toUpperCase(),
                                    color: peach,
                                    foreground: ink,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${a.minimumLevel}+',
                                    style: ts(11, color: muted),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 17),
                              Text(
                                a.title,
                                style: ts(18, weight: FontWeight.w800),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                a.objectives.first,
                                style: ts(12, color: muted, height: 1.8),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Text(
                                    'Try this activity',
                                    style: ts(
                                      12,
                                      color: green,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.north_east_rounded,
                                    size: 18,
                                    color: green,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 22),
        Text(
          'Use fluent-signer references for unfamiliar signs. Scene and concept checks evaluate those tasks; camera attempts are self-reviewed.',
          style: ts(11, color: muted, height: 1.8),
        ),
      ],
    );
  }
}

class ActivitySession extends StatefulWidget {
  const ActivitySession({
    super.key,
    required this.activity,
    required this.store,
  });
  final PracticeActivity activity;
  final LearningStore store;
  @override
  State<ActivitySession> createState() => _ActivitySessionState();
}

class _ActivitySessionState extends State<ActivitySession>
    with WidgetsBindingObserver {
  int phase = 0;
  int? answer;
  bool checked = false, mirror = false, saving = false, done = false;
  final selected = <String>{};
  final reflection = TextEditingController();
  final watch = Stopwatch();
  @override
  void initState() {
    super.initState();
    watch.start();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !done) {
      watch.start();
    } else {
      watch.stop();
    }
  }

  @override
  void dispose() {
    watch.stop();
    reflection.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> save() async {
    if (saving) return;
    setState(() => saving = true);
    watch.stop();
    await widget.store.addEvidence(
      activityId: widget.activity.id,
      title: widget.activity.title,
      reflection: reflection.text.trim(),
      rubric: selected.toList(),
      activeSeconds: watch.elapsed.inSeconds,
    );
    for (final concept in widget.activity.conceptIds) {
      await widget.store.addReview(
        conceptId: concept,
        prompt: widget.activity.cameraTask,
        domain: ReviewDomain.expressive,
      );
    }
    if (mounted) {
      setState(() {
        saving = false;
        done = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.activity;
    return Scaffold(
      appBar: AppBar(
        title: Text(a.title, style: ts(14, weight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (done) ...[
                  const SizedBox(height: 40),
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: green,
                    size: 65,
                  ),
                  const SizedBox(height: 23),
                  Text(
                    'Carry this practice forward.',
                    style: ts(30, weight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.store.storageError
                        ? 'We could not save your latest practice. It remains in memory for this session.'
                        : 'Your reflection is in your portfolio, and the activity’s concepts are in your review queue.',
                    style: ts(14, color: muted, height: 1.8),
                  ),
                  const SizedBox(height: 25),
                  ActionButton(
                    'Back to practice lab',
                    onTap: () => Navigator.pop(context),
                  ),
                ] else ...[
                  Pill(
                    '${a.kind.replaceAll('_', ' ').toUpperCase()} · STAGE ${a.minimumLevel}+',
                  ),
                  const SizedBox(height: 17),
                  Text(a.title, style: ts(31, weight: FontWeight.w800)),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: (phase + 1) / 3,
                    backgroundColor: line,
                    color: green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 24),
                  if (phase == 0) ...[
                    Text(
                      'Your purpose',
                      style: ts(19, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    for (final objective in a.objectives)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text(
                          '• $objective',
                          style: ts(14, color: green, height: 1.8),
                        ),
                      ),
                    const SizedBox(height: 20),
                    for (var i = 0; i < a.instructions.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Pill('${i + 1}'),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                a.instructions[i],
                                style: ts(14, color: muted, height: 1.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    ActionButton(
                      'Start activity',
                      onTap: () => setState(() => phase = 1),
                    ),
                  ],
                  if (phase == 1) ...[
                    Surface(
                      color: mint,
                      child: Text(
                        a.prompt,
                        style: ts(18, weight: FontWeight.w700, height: 1.7),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (a.kind.contains('spatial') ||
                        a.kind.contains('scene')) ...[
                      const SpatialPlanner(),
                      const SizedBox(height: 20),
                    ],
                    if (a.kind.contains('story') ||
                        a.kind.contains('narrative') ||
                        a.kind.contains('retell')) ...[
                      const NarrativePlanner(),
                      const SizedBox(height: 20),
                    ],
                    for (var i = 0; i < a.options.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: OutlinedButton(
                          onPressed: () => setState(() {
                            answer = i;
                            checked = false;
                          }),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(18),
                            backgroundColor: answer == i ? mint : Colors.white,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Text(a.options[i], style: ts(13)),
                        ),
                      ),
                    if (a.options.isNotEmpty) ...[
                      TextButton(
                        onPressed: answer == null
                            ? null
                            : () => setState(() => checked = true),
                        child: const Text('Check the idea'),
                      ),
                      if (checked)
                        Surface(
                          color: answer == a.correctOption ? mint : peach,
                          child: Text(
                            answer == a.correctOption
                                ? a.explanation
                                : 'Revisit the instructions and try another option. ${a.explanation}',
                            style: ts(13, height: 1.8),
                          ),
                        ),
                      const SizedBox(height: 15),
                    ],
                    Text(
                      'YOUR CAMERA TASK',
                      style: ts(
                        9,
                        color: green,
                        weight: FontWeight.w800,
                        spacing: 1,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      a.cameraTask,
                      style: ts(14, color: muted, height: 1.8),
                    ),
                    const SizedBox(height: 14),
                    if (mirror)
                      CameraStage(signWord: a.title)
                    else
                      OutlinedButton.icon(
                        onPressed: () => setState(() => mirror = true),
                        icon: const Icon(Icons.videocam_outlined),
                        label: const Text('Open practice mirror'),
                      ),
                    const SizedBox(height: 20),
                    ActionButton(
                      'Reflect on the attempt',
                      onTap:
                          a.options.isNotEmpty &&
                              (!checked || answer != a.correctOption)
                          ? null
                          : () => setState(() => phase = 2),
                    ),
                  ],
                  if (phase == 2) ...[
                    Text(
                      'What did you notice?',
                      style: ts(24, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Select the features you deliberately reviewed. These are your observations, not an automatic accuracy judgment.',
                      style: ts(12, color: muted, height: 1.8),
                    ),
                    const SizedBox(height: 10),
                    for (final criterion in a.rubric)
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: selected.contains(criterion),
                        onChanged: (v) => setState(() {
                          v == true
                              ? selected.add(criterion)
                              : selected.remove(criterion);
                        }),
                        title: Text(criterion, style: ts(13)),
                      ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: reflection,
                      maxLength: 1200,
                      maxLines: 4,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'One useful observation or next step',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 19),
                    ActionButton(
                      saving ? 'Saving…' : 'Save practice & schedule review',
                      onTap: saving || reflection.text.trim().isEmpty
                          ? null
                          : save,
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'Practice evidence is self-reported. No video is saved or analyzed. Feedback from a fluent signer is part of building reliable language skills.',
                    style: ts(11, color: muted, height: 1.8),
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

class SpatialPlanner extends StatefulWidget {
  const SpatialPlanner({super.key});
  @override
  State<SpatialPlanner> createState() => _SpatialPlannerState();
}

class _SpatialPlannerState extends State<SpatialPlanner> {
  String selected = 'Plant';
  final placements = <int, String>{};
  bool revealed = true;
  bool checked = false;
  @override
  Widget build(BuildContext context) => Surface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A small scene, a clear description',
          style: ts(17, weight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Optional spatial memory warm-up. Scene checks judge object positions, not your signing.',
          style: ts(11, color: muted),
        ),
        const SizedBox(height: 12),
        if (revealed)
          const Text(
            'Place the plant in the upper-left cell, the chair in the center, and the lamp in the lower-right cell.',
          ),
        TextButton(
          onPressed: () => setState(() => revealed = !revealed),
          child: Text(
            revealed
                ? 'Hide the scene instructions'
                : 'Show scene instructions',
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final item in ['Plant', 'Chair', 'Lamp'])
              ChoiceChip(
                label: Text(item),
                selected: item == selected,
                onSelected: (_) => setState(() => selected = item),
              ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.6,
          ),
          itemCount: 9,
          itemBuilder: (context, i) => OutlinedButton(
            onPressed: () => setState(() {
              placements.removeWhere((k, v) => v == selected);
              placements[i] = selected;
              checked = false;
            }),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: placements.containsKey(i) ? mint : paper,
            ),
            child: Text(
              placements[i] ?? ['↖', '↑', '↗', '←', '·', '→', '↙', '↓', '↘'][i],
              style: ts(11),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => setState(() => checked = true),
          child: const Text('Check scene positions'),
        ),
        if (checked)
          Text(
            placements[0] == 'Plant' &&
                    placements[4] == 'Chair' &&
                    placements[8] == 'Lamp'
                ? 'The positions match. Describe the scene from your own viewpoint.'
                : 'Compare the object positions with the instructions and try again.',
            style: ts(12, color: green, height: 1.7),
          ),
      ],
    ),
  );
}

class NarrativePlanner extends StatefulWidget {
  const NarrativePlanner({super.key});
  @override
  State<NarrativePlanner> createState() => _NarrativePlannerState();
}

class _NarrativePlannerState extends State<NarrativePlanner> {
  final cards = [
    'Establish who and where',
    'Introduce a change or problem',
    'Show the attempt and reaction',
    'Resolve and reflect',
  ];
  @override
  Widget build(BuildContext context) => Surface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shape your narrative', style: ts(17, weight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(
          'Move the beats to plan your telling. A flashback can work too—make the time and viewpoint clear.',
          style: ts(11, color: muted, height: 1.8),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < cards.length; i++)
          Row(
            children: [
              Pill('${i + 1}'),
              const SizedBox(width: 10),
              Expanded(child: Text(cards[i], style: ts(12))),
              IconButton(
                tooltip: 'Move ${cards[i]} earlier',
                onPressed: i == 0
                    ? null
                    : () => setState(() {
                        final card = cards.removeAt(i);
                        cards.insert(i - 1, card);
                      }),
                icon: const Icon(Icons.arrow_upward_rounded, size: 17),
              ),
            ],
          ),
      ],
    ),
  );
}
