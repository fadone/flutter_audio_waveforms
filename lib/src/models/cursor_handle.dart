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

  double position;
  final double cursorWidth;
  final double height;
  final Color color;
  final bool showHead;
  final Function(double position) onPositionChanged;

  @override
  State<CursorHandle> createState() => _CursorHandleState();
}

class _CursorHandleState extends State<CursorHandle> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.showHead
          ? widget.position - widget.cursorWidth
          : widget.position,
      top: 0,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            widget.position += details.delta.dx;
            widget.onPositionChanged(widget.position);
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
