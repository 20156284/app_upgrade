import 'dart:math' as math;

import 'package:flutter/material.dart';

class Wave extends StatefulWidget {
  const Wave({
    super.key,
    required this.value,
    required this.color,
    required this.direction,
    this.amplitude,
    this.frequency = 1,
  });
  final double value;
  final Color color;
  final Axis direction;

  ///波纹振幅（像素），为空时取进度方向长度的 1/20
  final double? amplitude;

  ///波纹频率，1 表示每 360 像素一个周期
  final double frequency;

  @override
  State<Wave> createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) => ClipPath(
        clipper: _WaveClipper(
          animationValue: _animationController.value,
          value: widget.value,
          direction: widget.direction,
          amplitude: widget.amplitude,
          frequency: widget.frequency,
        ),
        child: Container(
          color: widget.color,
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  _WaveClipper({
    required this.animationValue,
    required this.value,
    required this.direction,
    required this.amplitude,
    required this.frequency,
  });
  final double animationValue;
  final double value;
  final Axis direction;
  final double? amplitude;
  final double frequency;

  @override
  Path getClip(Size size) {
    if (direction == Axis.horizontal) {
      return Path()
        ..addPolygon(_generateHorizontalWavePath(size), false)
        ..lineTo(0.0, size.height)
        ..lineTo(0.0, 0.0)
        ..close();
    }

    return Path()
      ..addPolygon(_generateVerticalWavePath(size), false)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
  }

  List<Offset> _generateHorizontalWavePath(Size size) {
    final List<Offset> waveList = <Offset>[];
    final double waveHeight = amplitude ?? size.width / 20;
    for (int i = -2; i <= size.height.toInt() + 2; i++) {
      final double dx = math.sin((animationValue * 360 - i * frequency) %
                  360 *
                  (math.pi / 180)) *
              waveHeight +
          (size.width * value);
      waveList.add(Offset(dx, i.toDouble()));
    }
    return waveList;
  }

  List<Offset> _generateVerticalWavePath(Size size) {
    final List<Offset> waveList = <Offset>[];
    final double waveHeight = amplitude ?? size.height / 20;
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      final double dy = math.sin((animationValue * 360 - i * frequency) %
                  360 *
                  (math.pi / 180)) *
              waveHeight +
          (size.height - (size.height * value));
      waveList.add(Offset(i.toDouble(), dy));
    }
    return waveList;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) =>
      animationValue != oldClipper.animationValue ||
      value != oldClipper.value ||
      direction != oldClipper.direction ||
      amplitude != oldClipper.amplitude ||
      frequency != oldClipper.frequency;
}
