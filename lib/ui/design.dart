import 'dart:math' as math;
import 'package:flutter/material.dart';

const ink = Color(0xFF152A29);
const muted = Color(0xFF75807B);
const paper = Color(0xFFF7F8F2);
const mint = Color(0xFFE6F1DB);
const green = Color(0xFF315E47);
const lime = Color(0xFFD9F18B);
const line = Color(0xFFE3E7DD);
const peach = Color(0xFFF5DDCC);

TextStyle ts(
  double size, {
  Color color = ink,
  FontWeight weight = FontWeight.w500,
  double? height,
  double? spacing,
}) => TextStyle(
  fontFamily: 'Manrope',
  fontVariations: [FontVariation('wght', weight.value.toDouble())],
  fontSize: size,
  color: color,
  fontWeight: weight,
  height: height ?? 1.4,
  letterSpacing: spacing,
);

class Pill extends StatelessWidget {
  const Pill(
    this.text, {
    super.key,
    this.color = mint,
    this.foreground = green,
    this.icon,
  });
  final String text;
  final Color color, foreground;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 5),
        ],
        Text(
          text,
          style: ts(11, color: foreground, weight: FontWeight.w700),
        ),
      ],
    ),
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton(
    this.label, {
    super.key,
    required this.onTap,
    this.icon = Icons.arrow_forward_rounded,
    this.light = false,
  });
  final String label;
  final VoidCallback? onTap;
  final IconData icon;
  final bool light;
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onTap,
    style: FilledButton.styleFrom(
      backgroundColor: light ? Colors.white : ink,
      foregroundColor: light ? ink : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            label,
            style: ts(
              13,
              color: light ? ink : Colors.white,
              weight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 18),
        Icon(icon, size: 18),
      ],
    ),
  );
}

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(24),
  });
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: line),
      borderRadius: BorderRadius.circular(22),
    ),
    child: child,
  );
}

/// Decorative brand illustration only: never used as a sign demonstration.
class HandsArt extends StatelessWidget {
  const HandsArt({super.key, this.variant = 0});
  final int variant;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      painter: _HandsPainter(variant),
      size: const Size(340, 300),
    ),
  );
}

class _HandsPainter extends CustomPainter {
  _HandsPainter(this.variant);
  final int variant;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 340, size.height / 300);
    final fill = Paint()..color = const Color(0xFFD3E6B8);
    canvas.drawCircle(const Offset(175, 150), 113, fill);
    final stroke = Paint()
      ..color = const Color(0xFF41634A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(
      const Offset(175, 150),
      127,
      stroke..color = const Color(0xFFBED1A9),
    );
    canvas.drawCircle(
      const Offset(175, 150),
      140,
      stroke..color = const Color(0xFFD4E1C4),
    );
    void hand(double x, double y, double rotation, bool flip, Color color) {
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      if (flip) canvas.scale(-1, 1);
      final path = Path()
        ..moveTo(-30, 125)
        ..lineTo(-33, 82)
        ..cubicTo(-47, 62, -48, 43, -61, 23)
        ..cubicTo(-68, 10, -56, 1, -47, 11)
        ..lineTo(-29, 35)
        ..lineTo(-29, -33)
        ..cubicTo(-29, -49, -12, -49, -12, -33)
        ..lineTo(-11, 9)
        ..lineTo(-8, -56)
        ..cubicTo(-7, -71, 10, -71, 10, -54)
        ..lineTo(11, 7)
        ..lineTo(17, -42)
        ..cubicTo(20, -57, 36, -51, 33, -37)
        ..lineTo(29, 15)
        ..lineTo(39, -16)
        ..cubicTo(44, -29, 58, -24, 53, -9)
        ..lineTo(41, 45)
        ..cubicTo(41, 66, 24, 78, 23, 93)
        ..lineTo(25, 125)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
      canvas.drawPath(
        path,
        Paint()
          ..color = ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.3
          ..strokeJoin = StrokeJoin.round,
      );
      final creases = Path()
        ..moveTo(-29, 35)
        ..quadraticBezierTo(-8, 32, 1, 53)
        ..moveTo(-13, 68)
        ..quadraticBezierTo(5, 54, 24, 60)
        ..moveTo(-31, 94)
        ..lineTo(23, 94);
      canvas.drawPath(
        creases,
        Paint()
          ..color = ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.7,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-33, 101, 60, 40),
          const Radius.circular(5),
        ),
        Paint()
          ..color = flip ? const Color(0xFF577369) : const Color(0xFFEED877),
      );
      canvas.drawLine(
        const Offset(-31, 106),
        const Offset(25, 106),
        Paint()
          ..color = ink
          ..strokeWidth = 1.5,
      );
      canvas.restore();
    }

    hand(128, 153, -0.29, false, const Color(0xFFFFE7A5));
    hand(246, 154, 0.30, true, const Color(0xFFC88866));
    void star(double x, double y, double r) {
      final p = Path();
      for (var i = 0; i < 8; i++) {
        final a = i * math.pi / 4;
        final rr = i.isEven ? r : r * 0.25;
        if (i == 0) {
          p.moveTo(x + math.cos(a) * rr, y + math.sin(a) * rr);
        } else {
          p.lineTo(x + math.cos(a) * rr, y + math.sin(a) * rr);
        }
      }
      p.close();
      canvas.drawPath(p, Paint()..color = green);
    }

    star(51, 86, 12);
    star(288, 77, 8);
    star(304, 210, 12);
    canvas.drawArc(
      const Rect.fromLTWH(30, 149, 33, 30),
      0.6,
      2.5,
      false,
      Paint()
        ..color = green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HandsPainter oldDelegate) =>
      oldDelegate.variant != variant;
}

class SceneArt extends StatelessWidget {
  const SceneArt({super.key, this.scene = 0});
  final int scene;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      painter: _ScenePainter(scene),
      size: const Size(360, 200),
    ),
  );
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.scene);
  final int scene;
  @override
  void paint(Canvas c, Size s) {
    c.save();
    c.scale(s.width / 360, s.height / 200);
    final bg = [
      const Color(0xFFEBCBBC),
      const Color(0xFFD5DFCA),
      const Color(0xFFD7D8EF),
    ][scene % 3];
    c.drawRect(const Rect.fromLTWH(0, 0, 360, 200), Paint()..color = bg);
    c.drawCircle(
      const Offset(284, 47),
      30,
      Paint()..color = Colors.white.withValues(alpha: .3),
    );
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(134, 22, 92, 108),
        const Radius.circular(44),
      ),
      Paint()..color = Colors.white.withValues(alpha: .45),
    );
    c.drawLine(
      const Offset(180, 22),
      const Offset(180, 130),
      Paint()
        ..color = bg
        ..strokeWidth = 4,
    );
    c.drawLine(
      const Offset(134, 78),
      const Offset(226, 78),
      Paint()
        ..color = bg
        ..strokeWidth = 4,
    );
    c.drawRect(
      const Rect.fromLTWH(0, 150, 360, 50),
      Paint()..color = ink.withValues(alpha: .08),
    );
    void person(double x, Color shirt, Color skin, bool flip) {
      c.save();
      c.translate(x, 0);
      if (flip) c.scale(-1, 1);
      c.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-27, 106, 54, 88),
          const Radius.circular(24),
        ),
        Paint()..color = shirt,
      );
      c.drawCircle(const Offset(0, 87), 22, Paint()..color = skin);
      c.drawArc(
        const Rect.fromLTWH(-23, 60, 46, 43),
        3.1,
        3.6,
        true,
        Paint()..color = ink,
      );
      final p = Path()
        ..moveTo(16, 130)
        ..quadraticBezierTo(45, 151, 52, 100);
      c.drawPath(
        p,
        Paint()
          ..color = skin
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round,
      );
      c.drawCircle(const Offset(53, 97), 7, Paint()..color = skin);
      c.restore();
    }

    person(99, green, const Color(0xFFC18460), false);
    person(258, const Color(0xFFE9AE65), const Color(0xFFF4D5AA), true);
    if (scene == 0) {
      c.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(136, 146, 88, 10),
          const Radius.circular(5),
        ),
        Paint()..color = const Color(0xFF9D6E52),
      );
      c.drawRect(
        const Rect.fromLTWH(176, 153, 7, 47),
        Paint()..color = const Color(0xFF9D6E52),
      );
      c.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(162, 126, 18, 20),
          const Radius.circular(4),
        ),
        Paint()..color = Colors.white,
      );
    } else {
      c.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(18, 96, 20, 61),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFFB08769),
      );
      for (var i = 0; i < 4; i++) {
        c.drawOval(
          Rect.fromCenter(
            center: Offset(25 + (i.isEven ? -9 : 9), 85.0 - i * 9),
            width: 25,
            height: 14,
          ),
          Paint()..color = green,
        );
      }
    }
    c.restore();
  }

  @override
  bool shouldRepaint(covariant _ScenePainter old) => scene != old.scene;
}
