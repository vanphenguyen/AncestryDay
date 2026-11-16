import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app.dart';

/// Far hills in ink wash under a red sun, drawn behind the top of a screen.
class InkLandscape extends StatelessWidget {
  const InkLandscape({super.key, required this.height, this.child});

  /// The least height; the picture grows with [child] when that is taller
  /// (long words, large text).
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tones = Tones.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height, minWidth: double.infinity),
      child: CustomPaint(
        painter: _LandscapePainter(
          ink: tones.ink,
          sun: tones.lacquer,
          paper: tones.paper,
        ),
        child: child,
      ),
    );
  }
}

class _LandscapePainter extends CustomPainter {
  const _LandscapePainter({
    required this.ink,
    required this.sun,
    required this.paper,
  });

  final Color ink;
  final Color sun;
  final Color paper;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.clipRect(Offset.zero & size);

    // The sun, low and soft.
    final centre = Offset(w * 0.80, h * 0.36);
    canvas.drawCircle(
      centre,
      h * 0.30,
      Paint()..color = sun.withValues(alpha: 0.06),
    );
    canvas.drawCircle(
      centre,
      h * 0.17,
      Paint()..color = sun.withValues(alpha: 0.78),
    );

    // Three ranges of hills, the nearest darkest.
    void range(double base, double amp, double seed, double alpha) {
      final path = Path()..moveTo(0, h);
      for (var x = 0.0; x <= w + 4; x += 4) {
        final t = x / w;
        final y =
            base -
            amp *
                (0.55 * math.sin(t * 5.1 + seed) +
                    0.30 * math.sin(t * 11.3 + seed * 2.1) +
                    0.15 * math.sin(t * 23.7 + seed * 0.7));
        path.lineTo(x, h * y);
      }
      path
        ..lineTo(w, h)
        ..close();
      canvas.drawPath(path, Paint()..color = ink.withValues(alpha: alpha));
    }

    range(0.62, 0.16, 0.6, 0.07);
    range(0.76, 0.13, 2.4, 0.09);
    range(0.90, 0.09, 4.3, 0.12);

    // Mist where the hills meet the page.
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.7, w, h * 0.3),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [paper.withValues(alpha: 0), paper],
        ).createShader(Rect.fromLTWH(0, h * 0.7, w, h * 0.3)),
    );
  }

  @override
  bool shouldRepaint(_LandscapePainter old) =>
      old.ink != ink || old.sun != sun || old.paper != paper;
}

/// The moon as it looks on a given day of the lunar month.
class MoonPhase extends StatelessWidget {
  const MoonPhase({super.key, required this.lunarDay, this.size = 28});

  final int lunarDay;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tones = Tones.of(context);
    return CustomPaint(
      size: Size.square(size),
      painter: _MoonPainter(
        lunarDay: lunarDay,
        lit: tones.gold,
        shade: tones.ink.withValues(alpha: 0.16),
      ),
    );
  }
}

class _MoonPainter extends CustomPainter {
  const _MoonPainter({
    required this.lunarDay,
    required this.lit,
    required this.shade,
  });

  final int lunarDay;
  final Color lit;
  final Color shade;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final centre = Offset(r, r);
    canvas.drawCircle(centre, r, Paint()..color = shade);
    // 0 at new moon, 0.5 at full moon.
    final phase = ((lunarDay - 1) / 29.53).clamp(0.0, 1.0);
    final k = math.cos(2 * math.pi * phase);
    final waxing = phase < 0.5;
    final top = Offset(r, 0);
    final bottom = Offset(r, 2 * r);
    final path = Path()
      ..moveTo(top.dx, top.dy)
      ..arcToPoint(bottom, radius: Radius.circular(r), clockwise: waxing)
      ..arcToPoint(
        top,
        radius: Radius.elliptical(math.max(r * k.abs(), 0.01), r),
        clockwise: waxing ? k < 0 : k > 0,
      )
      ..close();
    canvas.drawPath(path, Paint()..color = lit);
  }

  @override
  bool shouldRepaint(_MoonPainter old) =>
      old.lunarDay != lunarDay || old.lit != lit;
}

/// A lotus flower in a few strokes.
class Lotus extends StatelessWidget {
  const Lotus({super.key, this.size = 96, this.color, this.accent});

  final double size;

  /// Petal colour; lacquer red when not given.
  final Color? color;

  /// The colour of the heart of the flower and the water line; gold when
  /// not given.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final tones = Tones.of(context);
    return CustomPaint(
      size: Size(size, size * 0.78),
      painter: LotusPainter(
        petal: color ?? tones.lacquer,
        accent: accent ?? tones.gold,
      ),
    );
  }
}

class LotusPainter extends CustomPainter {
  const LotusPainter({required this.petal, required this.accent});

  final Color petal;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final base = Offset(w / 2, h * 0.80);

    void drawPetal(double angle, double length, double width, double alpha) {
      canvas
        ..save()
        ..translate(base.dx, base.dy)
        ..rotate(angle);
      final path = Path()
        ..moveTo(0, 0)
        ..cubicTo(
          -width,
          -length * 0.35,
          -width * 0.75,
          -length * 0.8,
          0,
          -length,
        )
        ..cubicTo(width * 0.75, -length * 0.8, width, -length * 0.35, 0, 0)
        ..close();
      canvas
        ..drawPath(path, Paint()..color = petal.withValues(alpha: alpha))
        ..restore();
    }

    final long = h * 0.78;
    // Outer petals first, so the inner ones lie on top.
    drawPetal(-1.25, long * 0.72, w * 0.13, 0.45);
    drawPetal(1.25, long * 0.72, w * 0.13, 0.45);
    drawPetal(-0.78, long * 0.88, w * 0.15, 0.65);
    drawPetal(0.78, long * 0.88, w * 0.15, 0.65);
    drawPetal(-0.34, long * 0.97, w * 0.15, 0.85);
    drawPetal(0.34, long * 0.97, w * 0.15, 0.85);
    drawPetal(0, long, w * 0.14, 1);

    // The heart of the flower.
    canvas.drawCircle(
      base.translate(0, -h * 0.07),
      w * 0.035,
      Paint()..color = accent,
    );

    // Ripples of water underneath.
    final stroke = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = math.max(1.5, w * 0.02);
    canvas
      ..drawLine(Offset(w * 0.18, h * 0.90), Offset(w * 0.82, h * 0.90), stroke)
      ..drawLine(
        Offset(w * 0.34, h * 0.98),
        Offset(w * 0.66, h * 0.98),
        stroke,
      );
  }

  @override
  bool shouldRepaint(LotusPainter old) =>
      old.petal != petal || old.accent != accent;
}

/// A band of the square key pattern (hồi văn, 回纹) seen on temple eaves and
/// porcelain, used as a divider.
class KeyPatternDivider extends StatelessWidget {
  const KeyPatternDivider({super.key, this.height = 10});

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: CustomPaint(painter: _KeyPatternPainter(Tones.of(context).gold)),
  );
}

class _KeyPatternPainter extends CustomPainter {
  const _KeyPatternPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final unit = h * 1.6;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final count = (size.width / unit).floor();
    final start = (size.width - count * unit) / 2;
    final path = Path()..moveTo(0, h - 0.6);
    for (var i = 0; i < count; i++) {
      final x = start + i * unit;
      // One turn of the spiral, then on to the next.
      path
        ..lineTo(x, h - 0.6)
        ..lineTo(x, 0.6)
        ..lineTo(x + unit * 0.75, 0.6)
        ..lineTo(x + unit * 0.75, h * 0.65)
        ..lineTo(x + unit * 0.3, h * 0.65)
        ..lineTo(x + unit * 0.3, h * 0.35)
        ..moveTo(x + unit * 0.75, h - 0.6);
    }
    path.lineTo(size.width, h - 0.6);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_KeyPatternPainter old) => old.color != color;
}

/// A red seal with a few characters, like the stamp on a painting.
class Seal extends StatelessWidget {
  const Seal({
    super.key,
    required this.top,
    required this.bottom,
    this.size = 54,
  });

  /// Small line, e.g. the month.
  final String top;

  /// Large line, e.g. the day.
  final String bottom;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tones = Tones.of(context);
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: tones.lacquer,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.5),
          border: Border.all(color: tones.onLacquer.withValues(alpha: 0.7)),
        ),
        alignment: Alignment.center,
        // Shrinks to fit when the phone's text size is set large.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                top,
                maxLines: 1,
                style: TextStyle(
                  color: tones.onLacquer.withValues(alpha: 0.9),
                  fontSize: size * 0.19,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                bottom,
                maxLines: 1,
                style: TextStyle(
                  color: tones.onLacquer,
                  fontSize: size * 0.40,
                  height: 1.05,
                  fontFamily: serif,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A round portrait frame holding the first letter of a name.
class Monogram extends StatelessWidget {
  const Monogram({super.key, required this.name, this.size = 48});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tones = Tones.of(context);
    final trimmed = name.trim();
    // Vietnamese given names come last ("Nguyễn Văn An"), so the last word's
    // first letter is used; a name without spaces gives its first character.
    final word = trimmed.isEmpty ? '' : trimmed.split(RegExp(r'\s+')).last;
    final letter = word.isEmpty
        ? '·'
        : String.fromCharCode(word.runes.first).toUpperCase();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tones.gold.withValues(alpha: 0.16),
        border: Border.all(color: tones.gold, width: 1.4),
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontFamily: serif,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.42,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

/// A soft box for a short message (web preview, notifications off, a
/// calendar warning).
class Notice extends StatelessWidget {
  const Notice({
    super.key,
    required this.icon,
    required this.text,
    this.strong = false,
  });

  final IconData icon;
  final String text;

  /// True for warnings that must not be missed.
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final tones = Tones.of(context);
    final colour = strong ? tones.lacquer : tones.gold;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colour.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colour),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: tones.ink, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// The small heading above a group of rows.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 10),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: Tones.of(context).muted,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
