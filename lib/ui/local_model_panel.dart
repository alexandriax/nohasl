import 'package:flutter/material.dart';
import '../features/local_models/local_models.dart';
import 'design.dart';
import 'program_explorer.dart' show openReference;

/// Downloads are optional and separate from selecting a conversation provider.
class LocalModelPanel extends StatelessWidget {
  const LocalModelPanel({
    super.key,
    required this.manager,
    required this.onUse,
    required this.onRemove,
    this.conversationBusy = false,
    this.selectedModelId,
  });
  final LocalModelManager manager;
  final Future<void> Function(LocalModelSpec) onUse;
  final Future<void> Function(LocalModelSpec) onRemove;
  final bool conversationBusy;
  final String? selectedModelId;

  Future<void> confirmDownload(
    BuildContext context,
    LocalModelSpec model,
  ) async {
    var acceptedTerms = model.termsNotice == null;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Download ${model.name}?'),
          content: SizedBox(
            width: 490,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'About ${model.downloadLabel} of model files will be saved on this device. Allow extra free space during installation. A connection without data limits is best.',
                    style: ts(13, height: 1.8),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Plan for roughly ${model.memoryGiB.toStringAsFixed(1)} GiB of available memory while using this model. Actual needs and speed vary by device.',
                    style: ts(12, color: muted, height: 1.7),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The download contacts ${Uri.parse(model.sourceUrl).host}. Conversation text and camera frames are never sent there. After setup, inference runs locally.',
                    style: ts(12, color: green, height: 1.7),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      TextButton(
                        onPressed: () =>
                            openReference(context, model.sourceUrl),
                        child: const Text('Model source'),
                      ),
                      TextButton(
                        onPressed: () =>
                            openReference(context, model.licenseUrl),
                        child: Text(model.license),
                      ),
                    ],
                  ),
                  if (model.termsNotice != null) ...[
                    Text(model.termsNotice!, style: ts(12, height: 1.7)),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: acceptedTerms,
                      onChanged: (value) =>
                          setDialogState(() => acceptedTerms = value ?? false),
                      title: const Text('I agree to the linked model terms.'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                  Text(
                    'You can cancel the download or remove the model later. Browser storage may be cleared or evicted by the browser.',
                    style: ts(11, color: muted, height: 1.7),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Not now'),
            ),
            FilledButton(
              onPressed: acceptedTerms
                  ? () => Navigator.pop(context, true)
                  : null,
              child: Text('Download ${model.downloadLabel}'),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true) {
      // The manager reports failures in this panel and guards concurrent actions.
      try {
        await manager.download(model.id);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: manager,
    builder: (context, _) {
      final support = manager.support;
      final transfer = manager.isDownloading;
      return Surface(
        color: const Color(0xFFF0F2E9),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 14),
          title: Text(
            'Optional local models',
            style: ts(17, weight: FontWeight.w800),
          ),
          subtitle: Text(
            transfer
                ? 'Model download in progress'
                : 'More conversation possibilities, on your device',
            style: ts(11, color: muted),
          ),
          leading: const Icon(
            Icons.download_for_offline_outlined,
            color: green,
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                support?.reason ?? 'Checking local model support…',
                style: ts(12, color: green, height: 1.7),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Apple Intelligence is the default when available. Downloadable models are an optional alternative. Downloads continue while you explore the app; closing it may interrupt them.',
                style: ts(11, color: muted, height: 1.7),
              ),
            ),
            if (manager.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Surface(
                  color: peach,
                  padding: const EdgeInsets.all(15),
                  child: Text(manager.error!, style: ts(12, height: 1.7)),
                ),
              ),
            if (support?.available == true ||
                manager.downloadedIds.isNotEmpty) ...[
              const SizedBox(height: 17),
              for (final model in manager.models.where(
                (model) =>
                    support?.available == true ||
                    manager.downloadedIds.contains(model.id),
              ))
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: _modelCard(context, model),
                  ),
                ),
            ] else if (support != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: manager.isBusy
                      ? null
                      : () async {
                          try {
                            await manager.reconcile();
                          } catch (_) {}
                        },
                  icon: const Icon(Icons.refresh, size: 17),
                  label: const Text('Check support again'),
                ),
              ),
          ],
        ),
      );
    },
  );

  Widget _modelCard(BuildContext context, LocalModelSpec model) {
    final downloaded = manager.downloadedIds.contains(model.id);
    final working = manager.workingModelId == model.id && manager.isBusy;
    final transferring = working && manager.isDownloading;
    final selected = selectedModelId == model.id;
    final enabled = !manager.isBusy && !conversationBusy;
    return Surface(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 9,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(model.name, style: ts(16, weight: FontWeight.w800)),
              if (selected)
                const Pill('IN USE')
              else if (downloaded)
                const Pill('DOWNLOADED'),
            ],
          ),
          const SizedBox(height: 9),
          Text(model.description, style: ts(12, color: muted, height: 1.7)),
          const SizedBox(height: 10),
          Text(
            'About ${model.downloadLabel} download · ~${model.memoryGiB.toStringAsFixed(1)} GiB memory · ${model.license}',
            style: ts(11, color: green, height: 1.6),
          ),
          if (working) ...[
            const SizedBox(height: 17),
            LinearProgressIndicator(
              value: transferring
                  ? manager.progress?.fraction?.clamp(0.0, 1.0)
                  : null,
              color: green,
              backgroundColor: mint,
            ),
            const SizedBox(height: 9),
            Text(
              manager.phase == LocalModelPhase.cancelling
                  ? 'Canceling…'
                  : manager.progress?.message ?? 'Preparing local model…',
              style: ts(11, color: muted),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              if (!downloaded && !transferring)
                FilledButton.icon(
                  onPressed: enabled
                      ? () => confirmDownload(context, model)
                      : null,
                  icon: const Icon(Icons.download_rounded, size: 17),
                  label: const Text('Review download'),
                ),
              if (downloaded)
                FilledButton.icon(
                  onPressed:
                      enabled && manager.support?.available == true && !selected
                      ? () => onUse(model)
                      : null,
                  icon: const Icon(Icons.auto_awesome, size: 17),
                  label: Text(selected ? 'Using this model' : 'Use model'),
                ),
              if (transferring)
                OutlinedButton(
                  onPressed: manager.phase == LocalModelPhase.cancelling
                      ? null
                      : () async {
                          try {
                            await manager.cancelDownload();
                          } catch (_) {}
                        },
                  child: const Text('Cancel download'),
                ),
              if (downloaded)
                TextButton.icon(
                  onPressed: enabled ? () => onRemove(model) : null,
                  icon: const Icon(Icons.delete_outline, size: 17),
                  label: const Text('Remove model'),
                ),
              TextButton(
                onPressed: () => openReference(context, model.sourceUrl),
                child: const Text('Details'),
              ),
            ],
          ),
          if (downloaded && !selected)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Using a different model starts a fresh conversation. Downloaded models can be loaded without another download.',
                style: ts(10, color: muted, height: 1.6),
              ),
            ),
        ],
      ),
    );
  }
}
