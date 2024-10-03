import 'package:flutter/material.dart';

class CursorHandle extends StatefulWidget {
  CursorHandle({
    super.key,
    required this.position,
    required this.cursorWidth,
    required this.height,
    required this.color,
    required this.showHead,
    required this.onPositionChanged,
  });

  final double position;
  final double cursorWidth;
  final double height;
  final Color color;
  final bool showHead;
  final Function(double position) onPositionChanged;

  @override
  State<CursorHandle> createState() => _CursorHandleState();
}

class _CursorHandleState extends State<CursorHandle> {
  double _position = 0;

  bool _isDragging = false;

  @override
  void initState() {
    _position = widget.position;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CursorHandle oldWidget) {
    if (!_isDragging) {
      if (widget.position != oldWidget.position) {
        print('here changed');
        _position = widget.position;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.showHead ? _position - widget.cursorWidth : _position,
      top: 0,
      child: GestureDetector(
        onHorizontalDragStart: (details) => _isDragging = true,
        onHorizontalDragEnd: (details) => _isDragging = false,
        onHorizontalDragUpdate: (details) {
          setState(() {
            _position += details.delta.dx;
            widget.onPositionChanged(_position);
          });
        },
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
