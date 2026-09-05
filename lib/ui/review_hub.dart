import 'package:flutter/material.dart';
import '../data/curriculum.dart';
import '../state/learning_store.dart';
import '../features/practice/camera_stage.dart';
import 'design.dart';
import 'learning_pages.dart' show pageIntro;

class ReviewHub extends StatefulWidget {
  const ReviewHub({super.key, required this.store});
  final LearningStore store;
  @override
  State<ReviewHub> createState() => _ReviewHubState();
}

class _ReviewHubState extends State<ReviewHub> {
  bool portfolio = false;
  Future<void> addFocus() async {
    String focus = '';
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('What would you like to revisit?'),
        content: TextField(
          onChanged: (value) => focus = value,
          maxLength: 160,
          decoration: const InputDecoration(
            hintText: 'A known sign, a conversation goal, or a grammar feature',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, focus.trim()),
            child: const Text('Add focus'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await widget.store.addReview(
        conceptId: 'personal:$result',
        prompt: result,
      );
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.store,
    builder: (context, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pageIntro(
          'REVISIT. REFLECT. GROW.',
          'Turn practice into something lasting.',
          'Come back just as recall becomes effortful. Keep evidence of what you tried and what you want to try next.',
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ChoiceChip(
              label: Text('Review queue · ${widget.store.dueReviewCount} due'),
              selected: !portfolio,
              onSelected: (_) => setState(() => portfolio = false),
            ),
            ChoiceChip(
              label: Text(
                'My portfolio · ${widget.store.evidence.length} reflections',
              ),
              selected: portfolio,
              onSelected: (_) => setState(() => portfolio = true),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (!portfolio) ...[
          Surface(
            color: mint,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.store.dueReviewCount == 0
                      ? 'Room for a fresh connection.'
                      : '${widget.store.dueReviewCount} opportunities to reconnect.',
                  style: ts(25, weight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(
                  'Expressive and receptive recall are scheduled separately. A session shows up to ten due items. Rate your own recall after trying; the camera does not grade it.',
                  style: ts(12, color: green, height: 1.8),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    ActionButton(
                      'Add a personal focus',
                      onTap: addFocus,
                      icon: Icons.add_rounded,
                    ),
                    if (widget.store.dueReviewCount > 0)
                      OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => RecallSession(
                              store: widget.store,
                              item: widget.store.dueReviews.first,
                            ),
                          ),
                        ),
                        child: const Text('Start next review'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final item in widget.store.dueReviews)
            Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: line),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          RecallSession(store: widget.store, item: item),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          item.domain == ReviewDomain.expressive
                              ? Icons.front_hand_outlined
                              : Icons.visibility_outlined,
                          color: green,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.prompt,
                                style: ts(13, weight: FontWeight.w700),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${item.domain.name} · ${item.repetitions} recalled reviews · Due now',
                                style: ts(10, color: muted),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.arrow_forward_rounded, size: 19),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (widget.store.reviewQueue.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text('Looking ahead', style: ts(19, weight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text(
              '${widget.store.reviewQueue.length} concepts / domains in your review system. Successful recall gradually increases the interval; “Again” returns in ten minutes. These are transparent practice intervals, not measured mastery.',
              style: ts(12, color: muted, height: 1.8),
            ),
          ],
        ] else ...[
          if (widget.store.evidence.isEmpty)
            Surface(
              color: mint,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your next attempt belongs here.',
                    style: ts(23, weight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Complete a practice-lab reflection, rate a recall attempt, or save a conversation reflection. Your notes stay on this device; no camera recordings are stored.',
                    style: ts(13, color: green, height: 1.8),
                  ),
                ],
              ),
            ),
          for (final e in widget.store.evidence.take(40))
            Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Surface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        Pill(e.domain.name.toUpperCase()),
                        Pill('SELF-REPORTED', color: peach, foreground: ink),
                        Text(
                          '${e.createdAt.toLocal().month}/${e.createdAt.toLocal().day}/${e.createdAt.toLocal().year}',
                          style: ts(11, color: muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(e.title, style: ts(19, weight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    Text(
                      e.reflection.isEmpty
                          ? 'Recall rating recorded: ${e.rating?.name ?? 'practice'}.'
                          : e.reflection,
                      style: ts(13, color: muted, height: 1.8),
                    ),
                    if (e.rubric.isNotEmpty) ...[
                      const SizedBox(height: 13),
                      Text(
                        'Features considered',
                        style: ts(11, color: green, weight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      for (final r in e.rubric)
                        Text('• $r', style: ts(12, color: muted, height: 1.8)),
                    ],
                  ],
                ),
              ),
            ),
          if (widget.store.evidence.length > 40)
            Text(
              'Showing your 40 most recent reflections.',
              style: ts(11, color: muted),
            ),
        ],
        const SizedBox(height: 20),
        Text(
          'Milestone evidence comes from unfamiliar tasks, delayed recall, and feedback from qualified educators. This portfolio records your own practice, not an independent proficiency assessment.',
          style: ts(11, color: muted, height: 1.8),
        ),
      ],
    ),
  );
}

class RecallSession extends StatefulWidget {
  const RecallSession({super.key, required this.store, required this.item});
  final LearningStore store;
  final ReviewItem item;
  @override
  State<RecallSession> createState() => _RecallSessionState();
}

class _RecallSessionState extends State<RecallSession>
    with WidgetsBindingObserver {
  bool revealed = false, mirror = false, saving = false, done = false;
  ReviewRating? selected;
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

  Future<void> rate(ReviewRating rating) async {
    if (saving) return;
    setState(() => saving = true);
    watch.stop();
    await widget.store.recordReview(
      widget.item.id,
      rating,
      reflection: reflection.text.trim(),
      activeSeconds: watch.elapsed.inSeconds,
    );
    if (mounted) {
      setState(() {
        selected = rating;
        saving = false;
        done = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = allLessons
        .where((l) => l.id == widget.item.lessonId)
        .firstOrNull;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'A little retrieval practice',
          style: ts(14, weight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (done) ...[
                  const SizedBox(height: 35),
                  const Icon(
                    Icons.event_available_rounded,
                    size: 60,
                    color: green,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'We’ll come back to this.',
                    style: ts(29, weight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.store.storageError
                        ? 'Your latest review could not be saved.'
                        : 'Your ${selected!.name} rating has updated this item’s next review. Your reflection is saved in your portfolio.',
                    style: ts(14, color: muted, height: 1.8),
                  ),
                  const SizedBox(height: 25),
                  ActionButton(
                    'Back to review queue',
                    onTap: () => Navigator.pop(context),
                  ),
                ] else ...[
                  Pill('${widget.item.domain.name.toUpperCase()} RETRIEVAL'),
                  const SizedBox(height: 22),
                  Surface(
                    color: mint,
                    child: Text(
                      widget.item.prompt,
                      style: ts(23, weight: FontWeight.w700, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.item.domain == ReviewDomain.expressive
                        ? 'Try expressing the meaning with known signs before looking at notes. If the sign is unfamiliar, study a trusted fluent-signer reference first.'
                        : 'Use a trusted signer clip or partner example. Try to understand the meaning before checking the translation. This app does not yet provide that signed reference.',
                    style: ts(14, color: muted, height: 1.8),
                  ),
                  const SizedBox(height: 15),
                  if (mirror)
                    CameraStage(signWord: widget.item.prompt)
                  else
                    OutlinedButton.icon(
                      onPressed: () => setState(() => mirror = true),
                      icon: const Icon(Icons.videocam_outlined),
                      label: const Text('Use my practice mirror'),
                    ),
                  const SizedBox(height: 22),
                  if (!revealed)
                    ActionButton(
                      'Reveal reflection cues',
                      onTap: () => setState(() => revealed = true),
                      icon: Icons.visibility_outlined,
                    )
                  else ...[
                    Surface(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Compare meaning, not just movement.',
                            style: ts(20, weight: FontWeight.w800),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            lesson?.steps.first.body ??
                                'Compare your attempt with a trusted fluent-signer example. Notice the whole meaning, handshape, orientation, location, movement, and nonmanual features in context.',
                            style: ts(14, color: muted, height: 1.8),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Did you need the model? Could you use it in another context? Which detail should you revisit?',
                            style: ts(12, color: green, height: 1.8),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: reflection,
                      maxLines: 3,
                      maxLength: 1200,
                      decoration: const InputDecoration(
                        labelText: 'Optional reflection',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 17),
                    Text(
                      'How was your recall?',
                      style: ts(18, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Your own rating. No camera accuracy score.',
                      style: ts(11, color: muted),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final rating in ReviewRating.values)
                          OutlinedButton(
                            onPressed: saving ? null : () => rate(rating),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: rating == ReviewRating.good
                                  ? mint
                                  : Colors.white,
                              padding: const EdgeInsets.all(17),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  {
                                    'again': 'Again',
                                    'hard': 'Hard',
                                    'good': 'Good',
                                    'easy': 'Easy',
                                  }[rating.name]!,
                                  style: ts(13, weight: FontWeight.w800),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  rating == ReviewRating.again
                                      ? '10 minutes'
                                      : '${scheduleReview(widget.item, rating, DateTime.now()).intervalDays} days',
                                  style: ts(10, color: muted),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
