import 'dart:math';

import 'package:flutter/material.dart';

class Handle extends StatefulWidget {
  const Handle({
    super.key,
    required this.position,
    required this.cursorWidth,
    required this.height,
    required this.color,
    required this.onPositionChanged,
    required this.showHead,
  });

  final double position;
  final double cursorWidth;
  final double height;
  final Color color;
  final bool showHead;
  final Function(double position) onPositionChanged;

  @override
  State<Handle> createState() => _HandleState();
}

class _HandleState extends State<Handle> {
  var _left = 0.0;

  @override
  void initState() {
    _left = widget.position;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var position = max(_left, 0).toDouble();
    if (widget.showHead) {
      position -= widget.cursorWidth;
    }

    return Positioned(
      left: position,
      top: 0,
      child: GestureDetector(
        onHorizontalDragUpdate: widget.showHead
            ? (details) {
                setState(() {
                  _left += details.delta.dx;
                  widget.onPositionChanged(_left);
                });
              }
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: widget.color,
              width: widget.cursorWidth,
              height: widget.height * 0.7,
            ),
            if (widget.showHead)
              Container(
                width: widget.cursorWidth * 3,
                height: widget.cursorWidth * 3,
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
