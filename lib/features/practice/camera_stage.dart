import 'dart:async';

import 'package:camera/camera.dart';
import 'package:camera_macos/camera_macos.dart' as mac;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A consent-first, local camera mirror. No frames are recorded or evaluated.
class CameraStage extends StatefulWidget {
  const CameraStage({super.key, this.signWord = 'HELLO'});

  final String signWord;

  @override
  State<CameraStage> createState() => _CameraStageState();
}

class _CameraStageState extends State<CameraStage> with WidgetsBindingObserver {
  static const _navy = Color(0xFF142A2A);
  static const _mint = Color(0xFFCAEF83);
  static const _muted = Color(0xFFB2C4BD);

  CameraController? _camera;
  mac.CameraMacOSArguments? _macPreview;
  List<CameraDescription> _cameras = [];
  List<mac.CameraMacOSDevice> _macCameras = [];
  Timer? _timer;
  Future<void>? _closing;
  Future<void>? _openingTask;
  int _generation = 0;
  int _deviceIndex = 0;
  int _seconds = 0;
  bool _opening = false;
  bool _flipped = false;
  bool _preparing = false;
  bool _reviewing = false;
  bool _finished = false;
  bool _withoutCamera = false;
  String? _error;
  final Set<int> _checks = {};

  bool get _isMac => !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  bool get _supported =>
      kIsWeb ||
      _isMac ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;
  bool get _live => _camera?.value.isInitialized == true || _macPreview != null;
  bool get _running => _seconds > 0;
  int get _deviceCount => _isMac ? _macCameras.length : _cameras.length;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(CameraStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.signWord != widget.signWord) {
      _timer?.cancel();
      _seconds = 0;
      _reviewing = false;
      _finished = false;
      _checks.clear();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A system permission sheet can make the app inactive while opening.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        (state == AppLifecycleState.inactive && _live)) {
      _stopCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _generation++;
    unawaited(_releaseCamera());
    super.dispose();
  }

  Future<void> _releaseCamera() async {
    final camera = _camera;
    final hadMacPreview = _macPreview != null;
    _camera = null;
    _macPreview = null;
    try {
      await camera?.dispose();
      if (hadMacPreview) await mac.CameraMacOS.instance.destroy();
    } catch (_) {
      // Teardown is best-effort when a device has been disconnected.
    }
  }

  void _stopCamera() {
    _generation++;
    _timer?.cancel();
    _closing = _releaseCamera();
    if (!mounted) return;
    setState(() {
      _opening = false;
      _seconds = 0;
      _reviewing = false;
      _withoutCamera = false;
      _finished = false;
    });
  }

  Future<void> _startCamera({bool switchDevice = false}) async {
    // The macOS provider owns a single native session. Never let an older
    // permission request dispose a newer session when the app resumes.
    if (_openingTask != null) return;
    final task = _openCamera(switchDevice: switchDevice);
    _openingTask = task;
    try {
      await task;
    } finally {
      _openingTask = null;
      if (mounted) setState(() => _opening = false);
    }
  }

  Future<void> _openCamera({required bool switchDevice}) async {
    if (!_supported) {
      setState(
        () => _error =
            'Camera preview is coming to this desktop platform. '
            'Try the web app in your browser, or practice without a camera.',
      );
      return;
    }
    final generation = ++_generation;
    setState(() {
      _opening = true;
      _error = null;
      _withoutCamera = false;
      _finished = false;
      _reviewing = false;
    });
    try {
      await _closing;
      await _releaseCamera();
      if (!mounted || generation != _generation) return;
      if (_isMac) {
        _macCameras = await mac.CameraMacOS.instance.listDevices(
          deviceType: mac.CameraMacOSDeviceType.video,
        );
        if (!mounted || generation != _generation) return;
        if (_macCameras.isEmpty) throw StateError('no-camera');
        _deviceIndex = switchDevice
            ? (_deviceIndex + 1) % _macCameras.length
            : 0;
        final args = await mac.CameraMacOS.instance.initialize(
          deviceId: _macCameras[_deviceIndex].deviceId,
          cameraMacOSMode: mac.CameraMacOSMode.photo,
          enableAudio: false,
          resolution: mac.PictureResolution.high,
          isVideoMirrored: true,
        );
        if (!mounted || generation != _generation) {
          await mac.CameraMacOS.instance.destroy();
          return;
        }
        if (args?.textureId == null) {
          await mac.CameraMacOS.instance.destroy();
          throw StateError('no-preview');
        }
        _macPreview = args;
      } else {
        _cameras = await availableCameras();
        if (_cameras.isEmpty) throw StateError('no-camera');
        if (switchDevice) {
          _deviceIndex = (_deviceIndex + 1) % _cameras.length;
        } else {
          final front = _cameras.indexWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
          );
          _deviceIndex = front < 0 ? 0 : front;
        }
        if (!mounted || generation != _generation) return;
        final camera = CameraController(
          _cameras[_deviceIndex],
          ResolutionPreset.high,
          enableAudio: false,
        );
        _camera = camera;
        await camera.initialize();
        if (!mounted || generation != _generation) {
          await camera.dispose();
          return;
        }
      }
      setState(() => _opening = false);
    } catch (error) {
      await _releaseCamera();
      if (!mounted || generation != _generation) return;
      setState(() {
        _opening = false;
        _error = _friendlyError(error);
      });
    }
  }

  String _friendlyError(Object error) {
    final code = switch (error) {
      CameraException e => '${e.code} ${e.description}',
      PlatformException e => '${e.code} ${e.message}',
      mac.CameraMacOSException e => '${e.code} ${e.message}',
      _ => error.toString(),
    };
    final lower = code.toLowerCase();
    if (lower.contains('denied') ||
        lower.contains('permission') ||
        lower.contains('unauthorized') ||
        lower.contains('restricted')) {
      return kIsWeb
          ? 'Camera access is off. Allow camera access in your browser’s site '
                'settings, then try again. Use HTTPS or localhost.'
          : 'Camera access is off. Enable nohasl in your device’s '
                'Privacy & Security camera settings, then try again.';
    }
    if (lower.contains('no-camera') || lower.contains('notfound')) {
      return 'No camera was found. Connect a camera, use a physical phone '
          '(simulators have no camera), or practice without one.';
    }
    if (_isMac && lower.contains('invalid args')) {
      // camera_macos 0.1.1 collapses discovery permission errors into this
      // message before exposing the native error to its public API.
      return 'Your camera could not be accessed. Check nohasl’s camera '
          'permission in System Settings → Privacy & Security → Camera, '
          'and make sure a camera is connected.';
    }
    return 'Your camera could not start. Close other apps using it and try '
        'again, or practice without a camera.';
  }

  void _startPractice({bool withoutCamera = false}) {
    if (!_live && !withoutCamera && !_withoutCamera) return;
    _timer?.cancel();
    setState(() {
      _withoutCamera = withoutCamera || _withoutCamera;
      _seconds = 3;
      _preparing = true;
      _reviewing = false;
      _finished = false;
      _checks.clear();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_seconds > 1) {
          _seconds--;
        } else if (_preparing) {
          _preparing = false;
          _seconds = 12;
        } else {
          _seconds = 0;
          _reviewing = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.videocam_outlined, color: _mint, size: 22),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Your signing space',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: _live ? _mint : _muted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _live ? 'LIVE' : 'PRIVATE',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          const Text(
            'Mirror practice · self review',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 280),
              child: AspectRatio(
                aspectRatio: 1.28,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: Color(0xFF203B37)),
                    if (_live)
                      _preview()
                    else
                      const CustomPaint(painter: _SigningSpacePainter()),
                    if (_live)
                      const IgnorePointer(
                        child: CustomPaint(painter: _FramePainter()),
                      ),
                    Positioned(
                      left: 14,
                      top: 14,
                      child: _pill(
                        Icons.lock_outline,
                        _live ? 'Only on your device' : 'Camera is off',
                      ),
                    ),
                    if (_live)
                      Positioned(
                        right: 8,
                        top: 7,
                        child: IconButton(
                          tooltip: 'Turn camera off',
                          onPressed: _stopCamera,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black45,
                          ),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    if (!_live && !_running && !_withoutCamera)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 25),
                              const Text(
                                'A little space.\nA lot of possibility.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  height: 1.2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 17),
                              FilledButton.icon(
                                onPressed: _opening ? null : _startCamera,
                                style: FilledButton.styleFrom(
                                  backgroundColor: _mint,
                                  foregroundColor: _navy,
                                  disabledBackgroundColor: _mint.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                icon: _opening
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: _navy,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.videocam_outlined,
                                        size: 19,
                                      ),
                                label: Text(
                                  _opening ? 'Opening camera…' : 'Start camera',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_running)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: _navy.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _preparing
                                    ? 'GET READY'
                                    : 'PRACTICE ${widget.signWord.toUpperCase()}',
                                style: const TextStyle(
                                  color: _mint,
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '$_seconds',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 46,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                _preparing
                                    ? 'Face + both hands in view'
                                    : 'Take your time. Repeat slowly.',
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 14,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _running
                                  ? (_preparing
                                        ? 'Find your signing space'
                                        : 'Practice in progress')
                                  : 'Keep your face and both hands in frame',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                shadows: [
                                  Shadow(blurRadius: 8, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                          if (_live)
                            IconButton(
                              tooltip: 'Flip preview horizontally',
                              onPressed: () =>
                                  setState(() => _flipped = !_flipped),
                              icon: Icon(
                                Icons.flip,
                                color: _flipped ? _mint : Colors.white,
                                size: 20,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black45,
                              ),
                            ),
                          if (_live && _deviceCount > 1)
                            IconButton(
                              tooltip: 'Switch camera',
                              onPressed: _running || _opening
                                  ? null
                                  : () => _startCamera(switchDevice: true),
                              icon: const Icon(
                                Icons.cameraswitch_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black45,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Color(0xFFF5D3A7),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 13),
          if (_reviewing)
            _review()
          else if (_finished) ...[
            const Text(
              'Practice reflected. Keep going.',
              style: TextStyle(color: _mint, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your self-check is complete. Compare with a fluent signer '
              'again whenever you need.',
              style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
            ),
            TextButton(
              onPressed: () => _startPractice(),
              style: TextButton.styleFrom(foregroundColor: _mint),
              child: const Text('Practice again'),
            ),
          ] else if (_live || _withoutCamera) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _running
                    ? () {
                        _timer?.cancel();
                        setState(() {
                          _seconds = 0;
                          _reviewing = true;
                        });
                      }
                    : () => _startPractice(),
                style: FilledButton.styleFrom(
                  backgroundColor: _mint,
                  foregroundColor: _navy,
                ),
                icon: Icon(
                  _running ? Icons.check : Icons.play_arrow_rounded,
                  size: 18,
                ),
                label: Text(
                  _running
                      ? 'Finish & reflect'
                      : 'Practice ${widget.signWord.toLowerCase()}',
                ),
              ),
            ),
          ] else
            Center(
              child: TextButton(
                onPressed: _opening
                    ? null
                    : () => _startPractice(withoutCamera: true),
                style: TextButton.styleFrom(foregroundColor: _mint),
                child: const Text(
                  'Practice without camera',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          const SizedBox(height: 5),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, size: 13, color: _muted),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'No recording. No uploads. You review your own signing.',
                  style: TextStyle(color: _muted, fontSize: 10, height: 1.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _preview() {
    Widget child;
    if (_macPreview case final args?) {
      child = ClipRect(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: args.size.width,
            height: args.size.height,
            child: Texture(textureId: args.textureId!),
          ),
        ),
      );
    } else {
      child = Center(child: CameraPreview(_camera!));
    }
    return Transform.flip(flipX: _flipped, child: child);
  }

  Widget _pill(IconData icon, String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: _navy.withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: _mint),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: _muted, fontSize: 9)),
      ],
    ),
  );

  Widget _review() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'How did that feel?',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Check what you noticed. This is reflection, not an accuracy score.',
        style: TextStyle(color: _muted, fontSize: 11, height: 1.5),
      ),
      const SizedBox(height: 7),
      for (final (index, label) in const [
        'I noticed my handshape and palm direction',
        'I checked the location and movement',
        'I included my face and body expression',
      ].indexed)
        CheckboxListTile(
          value: _checks.contains(index),
          onChanged: (value) => setState(() {
            if (value == true) {
              _checks.add(index);
            } else {
              _checks.remove(index);
            }
          }),
          title: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
          activeColor: _mint,
          checkColor: _navy,
          side: const BorderSide(color: _muted),
        ),
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _startPractice(),
              style: OutlinedButton.styleFrom(foregroundColor: _mint),
              child: const Text('Try again'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton(
              onPressed: _checks.length == 3
                  ? () => setState(() {
                      _reviewing = false;
                      _finished = true;
                    })
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: _mint,
                foregroundColor: _navy,
                disabledForegroundColor: _muted,
                disabledBackgroundColor: Colors.white10,
              ),
              child: const Text('Complete'),
            ),
          ),
        ],
      ),
    ],
  );
}

/// A decorative framing guide, never an instructional sign demonstration.
class _SigningSpacePainter extends CustomPainter {
  const _SigningSpacePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF3F5C48), Color(0xFF203B37)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, glow);
    final line = Paint()
      ..color = const Color(0xFFB3D4B0).withValues(alpha: 0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final head = Offset(size.width * 0.5, size.height * 0.28);
    canvas.drawOval(
      Rect.fromCenter(
        center: head,
        width: size.width * 0.19,
        height: size.height * 0.24,
      ),
      line,
    );
    final body = Path()
      ..moveTo(size.width * 0.26, size.height)
      ..lineTo(size.width * 0.29, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.45,
        size.width * 0.42,
        size.height * 0.45,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.51,
        size.width * 0.58,
        size.height * 0.45,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.45,
        size.width * 0.71,
        size.height * 0.55,
      )
      ..lineTo(size.width * 0.74, size.height);
    canvas.drawPath(body, line);
    const _FramePainter().paint(canvas, size);
  }

  @override
  bool shouldRepaint(_SigningSpacePainter oldDelegate) => false;
}

class _FramePainter extends CustomPainter {
  const _FramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCAEF83).withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromLTWH(24, 48, size.width - 48, size.height - 99);
    const length = 17.0;
    for (final (corner, dx, dy) in [
      (rect.topLeft, 1.0, 1.0),
      (rect.topRight, -1.0, 1.0),
      (rect.bottomLeft, 1.0, -1.0),
      (rect.bottomRight, -1.0, -1.0),
    ]) {
      canvas.drawPath(
        Path()
          ..moveTo(corner.dx, corner.dy + dy * length)
          ..lineTo(corner.dx, corner.dy)
          ..lineTo(corner.dx + dx * length, corner.dy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_FramePainter oldDelegate) => false;
}
