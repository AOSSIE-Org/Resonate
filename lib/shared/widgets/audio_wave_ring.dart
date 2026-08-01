import 'dart:math' as math;

import 'package:flutter/material.dart';

class AudioWaveRing extends StatefulWidget {
  const AudioWaveRing({
    super.key,
    required this.level,
    required this.bands,
    required this.radius,
    required this.child,
    this.color,
  });

  final double level;
  final List<double> bands;
  final double radius;
  final Widget child;
  final Color? color;

  @override
  State<AudioWaveRing> createState() => _AudioWaveRingState();
}

class _AudioWaveRingState extends State<AudioWaveRing>
    with TickerProviderStateMixin {
  late final AnimationController _phase = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 14000),
  );
  late final AnimationController _level = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    value: widget.level.clamp(0.0, 1.0),
  );

  late final AnimationController _bandBlend = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
    value: 1,
  );
  late List<double> _fromBands = widget.bands;
  late List<double> _toBands = widget.bands;

  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _drive();
  }

  @override
  void didUpdateWidget(AudioWaveRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level != widget.level) _drive();
    if (!identical(oldWidget.bands, widget.bands)) _blendTo(widget.bands);
  }

  void _drive() {
    final target = widget.level.clamp(0.0, 1.0);
    final rising = target >= _level.value;
    if (target > 0 && !_phase.isAnimating) _phase.repeat();
    _level
        .animateTo(
          target,
          duration: rising ? _attack : _release,
          curve: rising ? Curves.easeOutCubic : Curves.easeInCubic,
        )
        .whenCompleteOrCancel(() {
          if (_disposed) return;
          if (_level.value == 0 && _phase.isAnimating) _phase.stop();
        });
  }

  void _blendTo(List<double> next) {
    _fromBands = _currentBands();
    _toBands = next;
    _bandBlend.forward(from: 0);
  }

  List<double> _currentBands() {
    if (_fromBands.length != _toBands.length) return _toBands;
    final t = _bandBlend.value;
    return [
      for (var i = 0; i < _toBands.length; i++)
        _fromBands[i] + (_toBands[i] - _fromBands[i]) * t,
    ];
  }

  @override
  void dispose() {
    _disposed = true;
    _phase.dispose();
    _level.dispose();
    _bandBlend.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diameter = widget.radius * 2;

    return SizedBox(
      width: diameter,
      height: diameter,
      child: OverflowBox(
        minWidth: diameter * _ringExtentFactor,
        maxWidth: diameter * _ringExtentFactor,
        minHeight: diameter * _ringExtentFactor,
        maxHeight: diameter * _ringExtentFactor,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _WaveRingPainter(
              phase: _phase,
              level: _level,
              color: widget.color ?? Theme.of(context).colorScheme.primary,
              radius: widget.radius,
              fromBands: _fromBands,
              toBands: _toBands,
              bandBlend: _bandBlend,
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}

const double _ringExtentFactor = 1.9;
const Duration _attack = Duration(milliseconds: 110);
const Duration _release = Duration(milliseconds: 300);
const double _minPeakHeight = 0.14;
const double _peakContrast = 1.5;
const double _peakSharpness = 1.7;

class _WaveRingPainter extends CustomPainter {
  _WaveRingPainter({
    required this.phase,
    required this.level,
    required this.color,
    required this.radius,
    required this.fromBands,
    required this.toBands,
    required this.bandBlend,
  }) : super(repaint: Listenable.merge([phase, level, bandBlend]));

  final Animation<double> phase;
  final Animation<double> level;
  final Color color;
  final double radius;
  final List<double> fromBands;
  final List<double> toBands;
  final Animation<double> bandBlend;

  double _band(int index) {
    final to = toBands[index];
    if (fromBands.length != toBands.length) return to;
    return fromBands[index] + (to - fromBands[index]) * bandBlend.value;
  }
  ({double min, double max})? _bandRange() {
    if (toBands.length < 3) return null;
    var min = double.infinity;
    var max = 0.0;
    for (var i = 0; i < toBands.length; i++) {
      final band = _band(i);
      if (band > max) max = band;
      if (band < min) min = band;
    }
    return max < 0.001 ? null : (min: min, max: max);
  }

  double _heightAt(double angle, ({double min, double max}) range) {
    final count = _cycleLength(toBands.length);
    final position = angle / (2 * math.pi) * count;
    final index = position.floor();
    final t = position - index;
    final magnitude = _band(
      _spreadIndex(_mirroredIndex(index, toBands.length), toBands.length),
    );

    final spread = range.max - range.min;
    final stretched = spread < 0.001 ? 0.5 : (magnitude - range.min) / spread;
    final shaped =
        _minPeakHeight +
        (1 - _minPeakHeight) * math.pow(stretched, _peakContrast).toDouble();
    return shaped * math.pow(math.sin(t * math.pi), _peakSharpness).toDouble();
  }
  int _cycleLength(int length) => (length - 1) * 2;

  int _mirroredIndex(int index, int length) {
    final cycle = _cycleLength(length);
    final wrapped = index % cycle;
    return wrapped < length ? wrapped : cycle - wrapped;
  }

  int _spreadIndex(int position, int length) {
    final half = (length + 1) ~/ 2;
    return position.isEven ? position ~/ 2 : half + position ~/ 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final value = level.value;
    if (value <= 0.001) return;

    final range = _bandRange();
    if (range == null) return;

    final center = size.center(Offset.zero);
    final turn = phase.value * 2 * math.pi;
    final base = radius * 1.06;
    final span = radius * (0.08 + 0.42 * value);

    final path = Path();
    final steps = _cycleLength(toBands.length) * 10;
    for (var i = 0; i <= steps; i++) {
      final angle = i / steps * 2 * math.pi;
      final r = base + span * _heightAt(angle + turn, range);
      final point = center + Offset(math.cos(angle) * r, math.sin(angle) * r);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.13
        ..strokeJoin = StrokeJoin.round
        ..color = color.withValues(alpha: 0.22 + 0.30 * value)
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          radius * (0.09 + 0.09 * value),
        ),
    );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.075
        ..strokeJoin = StrokeJoin.round
        ..color = color.withValues(alpha: 0.85 + 0.15 * value),
    );
  }

  @override
  bool shouldRepaint(_WaveRingPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      !identical(oldDelegate.toBands, toBands) ||
      !identical(oldDelegate.fromBands, fromBands);
}
