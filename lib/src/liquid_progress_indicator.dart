import 'package:flutter/material.dart';

import 'wave.dart';

class LiquidLinearProgressIndicator extends ProgressIndicator {
  const LiquidLinearProgressIndicator({
    super.key,
    required double super.value,
    super.backgroundColor,
    super.valueColor,
    required this.borderWidth,
    required this.borderColor,
    required this.borderRadius,
    this.direction = Axis.horizontal,
    this.amplitude,
    this.frequency = 1,
  });

  ///边框宽度
  final double borderWidth;

  ///边框颜色
  final Color borderColor;

  ///圆角半径
  final double borderRadius;

  ///进度增长方向
  final Axis direction;

  ///波纹振幅（像素），为空时取进度方向长度的 1/20
  final double? amplitude;

  ///波纹频率，1 表示每 360 像素一个周期
  final double frequency;

  @override
  State<LiquidLinearProgressIndicator> createState() =>
      _LiquidLinearProgressIndicatorState();
}

class _LiquidLinearProgressIndicatorState
    extends State<LiquidLinearProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _LinearClipper(radius: widget.borderRadius),
      child: CustomPaint(
        painter: _LinearPainter(
          color: widget.backgroundColor ?? const Color(0x0000BFFF),
          radius: widget.borderRadius,
        ),
        foregroundPainter: _LinearBorderPainter(
          color: widget.borderColor,
          width: widget.borderWidth,
          radius: widget.borderRadius,
        ),
        child: Wave(
          value: widget.value!,
          color: widget.valueColor?.value ?? const Color(0x6600BFFF),
          direction: widget.direction,
          amplitude: widget.amplitude,
          frequency: widget.frequency,
        ),
      ),
    );
  }
}

class _LinearPainter extends CustomPainter {
  _LinearPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
        Paint()..color = color);
  }

  @override
  bool shouldRepaint(_LinearPainter oldDelegate) =>
      color != oldDelegate.color || radius != oldDelegate.radius;
}

class _LinearBorderPainter extends CustomPainter {
  _LinearBorderPainter({
    required this.color,
    required this.width,
    required this.radius,
  });

  final Color color;
  final double width;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
              width / 2, width / 2, size.width - width, size.height - width),
          Radius.circular(radius - width),
        ),
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = width);
  }

  @override
  bool shouldRepaint(_LinearBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      width != oldDelegate.width ||
      radius != oldDelegate.radius;
}

class _LinearClipper extends CustomClipper<Path> {
  _LinearClipper({required this.radius});

  final double radius;

  @override
  Path getClip(Size size) {
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );
  }

  @override
  bool shouldReclip(_LinearClipper oldClipper) => radius != oldClipper.radius;
}
