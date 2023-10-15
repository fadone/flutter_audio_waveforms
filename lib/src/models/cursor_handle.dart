import 'package:flutter/material.dart';

class CursorHandle extends StatefulWidget {
  const CursorHandle({
    super.key,
    required this.position,
    required this.cursorWidth,
    required this.height,
    required this.color,
    required this.onPositionChanged,
    required this.showHead,
    required this.isPlaying,
  });

  final double position;
  final double cursorWidth;
  final double height;
  final Color color;
  final bool showHead;
  final Function(double position) onPositionChanged;
  final bool isPlaying;

  @override
  State<CursorHandle> createState() => _CursorHandleState();
}

class _CursorHandleState extends State<CursorHandle> {
  var _left = 0.0;

  @override
  void initState() {
    _left = widget.position;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CursorHandle oldWidget) {
    if (widget.isPlaying) {
      if (widget.position != oldWidget.position) {
        print('here changed');
        _left = widget.position;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left - widget.cursorWidth,
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
