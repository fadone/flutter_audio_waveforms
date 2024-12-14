import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Handle extends StatefulWidget {
  const Handle({
    super.key,
    required this.position,
    required this.cursorWidth,
    required this.height,
    required this.width,
    required this.color,
    required this.onPositionChanged,
    required this.showHead,
  });

  final double position;
  final double cursorWidth;
  final double height;
  final double width;
  final Color color;
  final bool showHead;
  final Function(double position) onPositionChanged;

  @override
  State<Handle> createState() => _HandleState();
}

class _HandleState extends State<Handle> {
  var _left = 0.0;

  bool _isDragging = false;

  @override
  void initState() {
    _left = widget.position;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Handle oldWidget) {
    if (!_isDragging && widget.position != oldWidget.position) {
      _left = widget.position;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final handleSize = widget.height * 0.08;

    var position = max(_left, 0).toDouble();
    if (widget.showHead) {
      position -= handleSize / 2;
    }

    return Positioned(
      left: position,
      top: 0,
      child: GestureDetector(
        onHorizontalDragStart: (details) => _isDragging = true,
        onHorizontalDragEnd: (details) => _isDragging = false,
        onHorizontalDragUpdate: widget.showHead
            ? (details) {
                if (_left + details.delta.dx < widget.width) {
                  setState(() {
                    _left =
                        clampDouble(_left + details.delta.dx, 0, widget.width);
                    widget.onPositionChanged(_left);
                  });
                }
              }
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: widget.color,
              width: widget.cursorWidth,
              height: widget.height * 0.9,
            ),
            if (widget.showHead)
              Container(
                width: handleSize,
                height: handleSize,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
