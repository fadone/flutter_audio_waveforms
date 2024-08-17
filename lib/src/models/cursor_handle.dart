import 'dart:async' show Timer;
import 'dart:math';

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
    this.onHorizontalDragUpdate,
    this.onDragging,
  });

  final double position;
  final double cursorWidth;
  final double height;
  final Color color;
  final bool showHead;
  final Function(double position) onPositionChanged;
  final bool isPlaying;
  final Function(DragUpdateDetails details)? onHorizontalDragUpdate;
  final Function(double position)? onDragging;

  @override
  State<CursorHandle> createState() => _CursorHandleState();
}

class _CursorHandleState extends State<CursorHandle> {
  var _left = 0.0;

  Timer? _timer;
  double? _globalPosition;

  // Function to execute repeatedly while dragging
  void _executeWhileDragging() {
    print("Dragging...");
    widget.onDragging?.call(_globalPosition!);
  }

  // Start the timer to execute the function continuously
  void _startExecuting() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_globalPosition != null) {
        _executeWhileDragging();
      }
    });
  }

  // Stop the timer when the drag ends
  void _stopExecuting() {
    _timer?.cancel();
  }

  @override
  void initState() {
    _left = widget.position;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CursorHandle oldWidget) {
    if (widget.isPlaying) {
      if (widget.position != oldWidget.position) {
        // print('here changed');
        _left = widget.position;
      }
    }
    super.didUpdateWidget(oldWidget);
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
        // onHorizontalDragDown: (details) {
        //   print('here onHorizontalDragDown ${details}');
        // },
        // onHorizontalDragStart: (details) {
        //   print('here onHorizontalDragStart ${details}');
        // },
        // onHorizontalDragEnd: (details) {
        //   print('here onHorizontalDragEnd ${details}');
        // },
        onHorizontalDragStart: (details) {
          _startExecuting();
        },
        onHorizontalDragEnd: (details) {
          _stopExecuting();
        },
        onHorizontalDragUpdate: widget.showHead
            ? (details) {
                print('here onHorizontalDragUpdate $details');
                _globalPosition = details.globalPosition.dx;
                widget.onHorizontalDragUpdate?.call(details);

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
