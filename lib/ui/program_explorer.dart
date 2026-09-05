import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/curriculum.dart';
import '../state/learning_store.dart';
import 'design.dart';
import 'learning_pages.dart' show lessonRow, pageIntro;

class ProgramExplorer extends StatefulWidget {
  const ProgramExplorer({
    super.key,
    required this.store,
    required this.onLesson,
  });
  final LearningStore store;
  final ValueChanged<Lesson> onLesson;
  @override
  State<ProgramExplorer> createState() => _ProgramExplorerState();
}

class _ProgramExplorerState extends State<ProgramExplorer> {
  int stage = 0;
  String query = '';
  String kind = 'all';
  @override
  Widget build(BuildContext context) {
    final data = courseLevels[stage];
    final units = data.units
        .where(
          (u) =>
              '${u.title} ${u.description} ${u.grammarFocus} ${u.vocabulary.join(' ')}'
                  .toLowerCase()
                  .contains(query.toLowerCase()),
        )
        .toList();
    final total = data.units.expand((u) => u.lessons).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pageIntro(
          'THE COMPLETE PROGRAM MAP',
          'Build a language. Open your world.',
          'A connected journey through comprehension, expression, grammar, culture, and spontaneous conversation.',
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Pill('${courseLevels.length} learning stages'),
            Pill(
              '${courseLevels.fold<int>(0, (n, l) => n + l.units.length)} units',
            ),
            Pill('${allLessons.length} activities'),
            const Pill(
              'DEAF EDUCATOR REVIEW PENDING',
              color: peach,
              foreground: ink,
            ),
          ],
        ),
        const SizedBox(height: 22),
        SingleChildScrollView(
          primary: false,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < courseLevels.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: ChoiceChip(
                    showCheckmark: false,
                    selectedColor: ink,
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 9,
                      ),
                      child: Text(
                        '${i + 1}. ${courseLevels[i].title}',
                        style: ts(
                          12,
                          color: i == stage ? Colors.white : ink,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                    selected: stage == i,
                    onSelected: (_) => setState(() {
                      stage = i;
                      query = '';
                    }),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Surface(
          color: mint,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STAGE ${stage + 1} · ${data.subtitle.toUpperCase()}',
                style: ts(
                  10,
                  color: green,
                  weight: FontWeight.w800,
                  spacing: 1.2,
                ),
              ),
              const SizedBox(height: 9),
              Text(data.title, style: ts(30, weight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(data.description, style: ts(13, color: green, height: 1.8)),
              const SizedBox(height: 19),
              Wrap(
                spacing: 20,
                runSpacing: 8,
                children: [
                  Text(
                    '${data.units.length} connected units',
                    style: ts(12, color: green, weight: FontWeight.w700),
                  ),
                  Text(
                    '$total varied activities',
                    style: ts(12, color: green, weight: FontWeight.w700),
                  ),
                  Text(
                    '${data.units.expand((u) => u.lessons).where((l) => widget.store.completed.contains(l.id)).length} explored',
                    style: ts(12, color: green, weight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          key: ValueKey(stage),
          initialValue: query,
          onChanged: (v) => setState(() => query = v),
          decoration: InputDecoration(
            hintText: 'Search this stage by topic, grammar, or concept',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: line),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            for (final entry in const {
              'all': 'All activities',
              'observe': 'Observe',
              'comprehension': 'Comprehend',
              'grammar': 'Grammar',
              'expressive': 'Express',
              'retrieval': 'Retrieve',
              'information_gap': 'Converse',
              'story': 'Transfer',
              'checkpoint': 'Checkpoint',
            }.entries)
              ChoiceChip(
                label: Text(entry.value, style: ts(10)),
                selected: kind == entry.key,
                onSelected: (_) => setState(() => kind = entry.key),
              ),
          ],
        ),
        const SizedBox(height: 18),
        if (units.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'No matching units in this stage. Try a broader topic.',
              style: ts(14, color: muted),
            ),
          ),
        for (final unit in units)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: unitCard(unit, data.units.indexOf(unit)),
          ),
        const SizedBox(height: 18),
        Surface(
          color: const Color(0xFFEEF0E7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A curriculum is more than a checklist.',
                style: ts(18, weight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                'Each unit has a communicative outcome, grammar and culture in context, a retrieval cycle, and a transfer task. Advanced progress needs conversations with unfamiliar fluent signers and independent educator feedback. Lesson completion does not establish a proficiency rating.',
                style: ts(12, color: muted, height: 1.8),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => openReference(
                  context,
                  'https://gallaudet.edu/american-sign-language-proficiency-interview-aslpi/criteria-evaluated/',
                ),
                icon: const Icon(Icons.open_in_new_rounded, size: 15),
                label: const Text('Explore Gallaudet’s proficiency criteria'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget unitCard(CourseUnit unit, int index) {
    final lessons = unit.lessons
        .where((l) => kind == 'all' || l.activityKind == kind)
        .toList();
    final completed = unit.lessons
        .where((l) => widget.store.completed.contains(l.id))
        .length;
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: line),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: ValueKey('$stage-${unit.id}-$kind'),
        initiallyExpanded: index == 0 || kind != 'all' || query.isNotEmpty,
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: const Border(),
        collapsedShape: const Border(),
        leading: Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: completed == unit.lessons.length ? green : mint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '${index + 1}'.padLeft(2, '0'),
              style: ts(
                13,
                color: completed == unit.lessons.length ? Colors.white : green,
                weight: FontWeight.w800,
              ),
            ),
          ),
        ),
        title: Text(unit.title, style: ts(16, weight: FontWeight.w800)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '$completed / ${unit.lessons.length} explored · ${unit.description}',
            style: ts(11, color: muted, height: 1.7),
          ),
        ),
        children: [
          if (unit.objectives.isNotEmpty) ...[
            const SizedBox(height: 10),
            infoBlock('YOU WILL BE ABLE TO', unit.objectives.join('\n')),
            const SizedBox(height: 16),
          ],
          if (unit.vocabulary.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final word in unit.vocabulary)
                  Pill(word, color: paper, foreground: green),
              ],
            ),
            const SizedBox(height: 18),
          ],
          if (unit.grammarFocus.isNotEmpty)
            infoBlock('GRAMMAR IN CONTEXT', unit.grammarFocus),
          if (unit.cultureFocus.isNotEmpty) ...[
            const SizedBox(height: 12),
            infoBlock('CULTURE & COMMUNITY', unit.cultureFocus),
          ],
          if (unit.scenario.isNotEmpty) ...[
            const SizedBox(height: 14),
            Surface(
              color: mint,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR REAL-WORLD MISSION',
                    style: ts(
                      9,
                      color: green,
                      weight: FontWeight.w800,
                      spacing: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(unit.scenario, style: ts(12, color: green, height: 1.8)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          for (final lesson in lessons)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: lessonRow(
                lesson,
                widget.store.completed.contains(lesson.id),
                () => widget.onLesson(lesson),
              ),
            ),
          if (lessons.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'No activities of this type in this unit.',
                style: ts(12, color: muted),
              ),
            ),
          if (unit.rubric.isNotEmpty) ...[
            const SizedBox(height: 10),
            infoBlock(
              'MILESTONE EVIDENCE · SELF-REVIEW',
              unit.rubric.map((r) => '• $r').join('\n'),
            ),
          ],
          if (unit.prerequisiteIds.isNotEmpty) ...[
            const SizedBox(height: 12),
            infoBlock(
              'BUILD ON',
              unit.prerequisiteIds
                  .map((id) {
                    final all = courseLevels.expand((l) => l.units);
                    return all
                        .firstWhere((u) => u.id == id, orElse: () => unit)
                        .title;
                  })
                  .join(' · '),
            ),
          ],
          if (unit.referenceUrls.isNotEmpty) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => showReferences(context, unit),
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: Text(
                  'Educator sources & reference requirements',
                  style: ts(11, color: green, weight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget infoBlock(String heading, String content) => SizedBox(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: ts(9, color: green, weight: FontWeight.w800, spacing: 1),
        ),
        const SizedBox(height: 7),
        Text(content, style: ts(12, color: muted, height: 1.8)),
      ],
    ),
  );
}

Future<void> openReference(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null || uri.scheme != 'https') return;
  try {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The reference could not open. Please try again.'),
        ),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening links is unavailable here.')),
      );
    }
  }
}

Future<void> showReferences(
  BuildContext context,
  CourseUnit unit,
) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('${unit.title}: references'),
    content: SizedBox(
      width: 550,
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'These original sources inform the curriculum. They are external learning resources, not bundled or licensed sign demonstrations. Use a fluent-signer model before rehearsing unfamiliar signs.',
              style: ts(13, color: muted, height: 1.8),
            ),
            const SizedBox(height: 16),
            for (final url in unit.referenceUrls)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => openReference(context, url),
                  child: Text(url, style: ts(12, color: green)),
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Done'),
      ),
    ],
  ),
);
