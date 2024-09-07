import 'package:flutter/material.dart';

class CursorHandle extends StatelessWidget {
  const CursorHandle({
    super.key,
    required this.position,
    required this.cursorWidth,
    required this.height,
    required this.color,
    required this.showHead,
  });

  final double position;
  final double cursorWidth;
  final double height;
  final Color color;
  final bool showHead;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: showHead ? position - cursorWidth : position,
      top: 0,
      child: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: color,
              width: cursorWidth,
              height: height * 0.7,
            ),
            if (showHead)
              Container(
                width: cursorWidth * 3,
                height: cursorWidth * 3,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
