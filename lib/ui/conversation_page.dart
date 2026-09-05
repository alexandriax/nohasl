import 'package:flutter/material.dart';
import '../data/curriculum.dart';
import '../features/conversation/apple_intelligence.dart';
import '../features/conversation/scenarios.dart';
import '../features/practice/camera_stage.dart';
import '../state/learning_store.dart';
import 'design.dart';
import 'learning_pages.dart' show pageIntro;

class ConversationPage extends StatefulWidget {
  const ConversationPage({
    super.key,
    required this.store,
    this.service,
    this.initialTopic,
  });
  final LearningStore store;
  final AppleIntelligenceService? service;
  final String? initialTopic;
  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage>
    with WidgetsBindingObserver {
  final watch = Stopwatch();
  bool checkedAvailability = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _check();
      if (messages.isNotEmpty) watch.start();
    } else {
      watch.stop();
    }
  }

  late final AppleIntelligenceService service;
  late String topic;
  int level = 0;
  AiAvailability? availability;
  bool useAI = false, busy = false, mirror = false;
  bool savingReflection = false;
  int epoch = 0;
  String? error;
  ConversationTurn? latest;
  final messages = <ConversationMessage>[];
  final input = TextEditingController();
  final custom = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    service = widget.service ?? AppleIntelligenceService();
    topic = widget.initialTopic ?? conversationScenarios.first.title;
    _check();
  }

  Future<void> _check() async {
    final result = await service.availability();
    if (mounted) {
      setState(() {
        availability = result;
        if (!checkedAvailability && messages.isEmpty) {
          useAI = result.isAvailable;
        }
        if (!result.isAvailable && messages.isEmpty) {
          useAI = false;
        }
        checkedAvailability = true;
      });
    }
  }

  @override
  void dispose() {
    epoch++;
    watch.stop();
    WidgetsBinding.instance.removeObserver(this);
    input.dispose();
    custom.dispose();
    service.reset();
    super.dispose();
  }

  Future<void> restart() async {
    final resetEpoch = ++epoch;
    watch.stop();
    watch.reset();
    setState(() {
      messages.clear();
      if (availability?.isAvailable != true) useAI = false;
      latest = null;
      busy = true;
      error = null;
    });
    await service.reset();
    if (mounted && epoch == resetEpoch) setState(() => busy = false);
  }

  Future<void> send([String? override]) async {
    final message = (override ?? input.text).trim();
    if (busy || message.isEmpty) return;
    watch.start();
    final currentEpoch = epoch;
    final history = List<ConversationMessage>.of(messages);
    setState(() {
      busy = true;
      error = null;
      messages.add(ConversationMessage(role: 'user', content: message));
      input.clear();
    });
    try {
      final turn = useAI
          ? await service.respond(
              topic: topic,
              level: '${level + 1}: ${courseLevels[level].title}',
              message: message,
              history: history,
            )
          : guidedTurn(
              topic: topic,
              message: message,
              turnIndex: history.where((m) => m.role == 'user').length,
            );
      if (!mounted || currentEpoch != epoch) return;
      setState(() {
        latest = turn;
        messages.add(
          ConversationMessage(
            role: 'assistant',
            content: '${turn.reply}\n\n${turn.followUpQuestion}',
          ),
        );
        busy = false;
      });
    } catch (e) {
      if (!mounted || currentEpoch != epoch) return;
      setState(() {
        busy = false;
        error = e is AiServiceException
            ? e.message
            : 'This turn could not finish. Retry or choose guided rehearsal.';
      });
    }
  }

  Future<void> retryTurn() async {
    final previous = messages.lastWhere((m) => m.role == 'user').content;
    if (messages.isNotEmpty && messages.last.role == 'user') {
      messages.removeLast();
    }
    await send(previous);
  }

  Future<void> saveReflection() async {
    if (savingReflection) return;
    setState(() => savingReflection = true);
    try {
      String reflection = '';
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Keep the learning, not the chat.'),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What did you try in ASL? Your reflection, practice date, and duration are saved on this device. The chat and topic are not saved.',
                  style: ts(12, color: muted, height: 1.7),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) => reflection = value,
                  maxLines: 4,
                  maxLength: 1200,
                  decoration: const InputDecoration(
                    hintText: 'A useful moment, a difficulty, or a next step…',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, reflection.trim()),
              child: const Text('Save reflection'),
            ),
          ],
        ),
      );
      if (result == null || result.isEmpty) return;
      final elapsedSeconds = watch.elapsed.inSeconds;
      watch.reset();
      await widget.store.addEvidence(
        activityId: 'conversation',
        title: 'Conversation reflection',
        activeSeconds: elapsedSeconds,
        reflection: result,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.store.storageError
                  ? 'Reflection could not be saved.'
                  : 'Reflection saved to your portfolio.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => savingReflection = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scenario = conversationScenarios
        .where((s) => s.title == topic)
        .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pageIntro(
          'THE CONVERSATION ROOM',
          'Follow your curiosity.',
          'Every topic is a chance to connect. Rehearse in your camera, then share the meaning or a reflection in text.',
        ),
        Surface(
          color: ink,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Pill(
                    useAI
                        ? 'APPLE INTELLIGENCE · ON DEVICE'
                        : 'GUIDED REHEARSAL',
                    color: green,
                    foreground: lime,
                    icon: useAI ? Icons.auto_awesome : Icons.forum_outlined,
                  ),
                  Text(
                    'Your camera is never sent to the conversation model.',
                    style: ts(11, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Real-life practice. Endless directions.',
                style: ts(25, color: Colors.white, weight: FontWeight.w800),
              ),
              const SizedBox(height: 9),
              Text(
                'Choose a topic, take a role, and keep the exchange going. On supported Apple devices, the on-device model can respond to your ideas and introduce new situations.',
                style: ts(12, color: Colors.white70, height: 1.8),
              ),
              const SizedBox(height: 13),
              Text(
                availability?.reason ??
                    'Checking on-device conversation availability…',
                style: ts(11, color: lime),
              ),
              if (useAI && availability?.isAvailable == false)
                TextButton(
                  onPressed: busy
                      ? null
                      : () {
                          setState(() => useAI = false);
                          restart();
                        },
                  child: Text(
                    'Start a guided conversation',
                    style: ts(12, color: lime),
                  ),
                ),
              if (availability?.isAvailable == true)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: lime,
                  title: Text(
                    'Use Apple Intelligence',
                    style: ts(12, color: Colors.white, weight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'English scenario support · No ASL translation or camera analysis',
                    style: ts(10, color: Colors.white70),
                  ),
                  value: useAI,
                  onChanged: busy
                      ? null
                      : (v) {
                          setState(() => useAI = v);
                          restart();
                        },
                ),
            ],
          ),
        ),
        const SizedBox(height: 23),
        ExpansionTile(
          key: ValueKey(messages.isEmpty),
          initiallyExpanded: messages.isEmpty,
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: 8),
          title: Text(
            'Topic & practice stage',
            style: ts(14, weight: FontWeight.w800),
          ),
          subtitle: Text(
            '$topic · Stage ${level + 1}',
            style: ts(11, color: muted),
          ),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in conversationScenarios)
                  ChoiceChip(
                    label: Text(s.title, style: ts(11)),
                    selected: topic == s.title,
                    onSelected: busy
                        ? null
                        : (_) {
                            setState(() => topic = s.title);
                            restart();
                          },
                  ),
              ],
            ),
            const SizedBox(height: 15),
            LayoutBuilder(
              builder: (context, c) {
                final customField = TextField(
                  controller: custom,
                  maxLength: 100,
                  enabled: !busy,
                  decoration: const InputDecoration(
                    hintText: 'Or bring your own topic…',
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty) {
                      setState(() => topic = v.trim());
                      restart();
                    }
                  },
                );
                final button = OutlinedButton(
                  onPressed: busy
                      ? null
                      : () {
                          if (custom.text.trim().isNotEmpty) {
                            setState(() => topic = custom.text.trim());
                            restart();
                          }
                        },
                  child: const Text('Set topic'),
                );
                return c.maxWidth > 500
                    ? Row(
                        children: [
                          Expanded(child: customField),
                          const SizedBox(width: 12),
                          button,
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          customField,
                          const SizedBox(height: 9),
                          button,
                        ],
                      );
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (var i = 0; i < courseLevels.length; i++)
                  ChoiceChip(
                    label: Text('Stage ${i + 1}', style: ts(11)),
                    selected: level == i,
                    onSelected: busy
                        ? null
                        : (_) {
                            setState(() => level = i);
                            restart();
                          },
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 22),
        Surface(
          color: mint,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(topic, style: ts(22, weight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                scenario?.setting ??
                    'Bring your experience and curiosity to a conversation about $topic.',
                style: ts(13, color: green, height: 1.8),
              ),
              const SizedBox(height: 10),
              Text(
                'MISSION  ${scenario?.goal ?? 'Explain an idea, ask a follow-up, and repair an unclear moment.'}',
                style: ts(11, color: green, weight: FontWeight.w800),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  ActionButton(
                    messages.isEmpty
                        ? 'Begin conversation'
                        : 'New conversation',
                    onTap: busy
                        ? null
                        : () {
                            if (messages.isEmpty) {
                              send('Let’s begin this scenario.');
                            } else {
                              restart();
                            }
                          },
                  ),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => mirror = !mirror),
                    icon: Icon(
                      mirror
                          ? Icons.videocam_off_outlined
                          : Icons.videocam_outlined,
                      size: 18,
                    ),
                    label: Text(
                      mirror ? 'Close practice mirror' : 'Open practice mirror',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (mirror) ...[
          const SizedBox(height: 20),
          CameraStage(
            signWord: latest?.practiceGoal ?? scenario?.goal ?? topic,
          ),
        ],
        const SizedBox(height: 24),
        for (final message in messages)
          Align(
            alignment: message.role == 'user'
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(21),
                decoration: BoxDecoration(
                  color: message.role == 'user' ? mint : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.role == 'user'
                          ? 'YOU · MEANING / REFLECTION'
                          : useAI
                          ? 'ON-DEVICE CONVERSATION COACH'
                          : 'GUIDED PRACTICE CUE',
                      style: ts(
                        9,
                        color: green,
                        weight: FontWeight.w800,
                        spacing: 1,
                      ),
                    ),
                    const SizedBox(height: 9),
                    SelectableText(message.content, style: ts(14, height: 1.8)),
                  ],
                ),
              ),
            ),
          ),
        if (busy)
          const Padding(
            padding: EdgeInsets.all(20),
            child: LinearProgressIndicator(),
          ),
        if (error != null)
          Surface(
            color: peach,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(error!, style: ts(13)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  children: [
                    TextButton(
                      onPressed: retryTurn,
                      child: const Text('Retry turn'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => useAI = false);
                        restart();
                      },
                      child: const Text('Use guided rehearsal'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (latest != null) ...[
          Surface(
            color: paper,
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TRY IT IN YOUR OWN WORDS AND SIGNS',
                  style: ts(
                    9,
                    color: green,
                    weight: FontWeight.w800,
                    spacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  latest!.practiceGoal,
                  style: ts(12, color: muted, height: 1.8),
                ),
                const SizedBox(height: 8),
                Text(
                  'Text idea: ${latest!.suggestedReply}',
                  style: ts(12, color: green),
                ),
                const SizedBox(height: 7),
                Text(
                  'The text is a meaning scaffold. It is not ASL word order or a sign demonstration.',
                  style: ts(10, color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
        ],
        TextField(
          controller: input,
          enabled: !busy,
          maxLines: 3,
          minLines: 2,
          maxLength: 1000,
          decoration: InputDecoration(
            labelText: 'What would you like to express?',
            hintText:
                'Sign your response first if you can, then type its meaning or ask for a new direction.',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 15,
          runSpacing: 12,
          children: [
            ActionButton(
              busy ? 'Preparing a reply…' : 'Send meaning',
              onTap: busy ? null : () => send(),
              icon: Icons.arrow_upward_rounded,
            ),
            if (messages.isNotEmpty)
              TextButton.icon(
                onPressed: busy || savingReflection ? null : saveReflection,
                icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                label: const Text('Save a reflection'),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Conversations stay in this session; the coach uses only recent turns. The model cannot see your signing and cannot assess ASL accuracy. Ask a fluent signer or educator for language feedback. Generated content can be inaccurate; use it for scenarios, not sign instruction.',
          style: ts(11, color: muted, height: 1.8),
        ),
      ],
    );
  }
}
