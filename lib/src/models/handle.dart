import 'package:flutter/material.dart';

class Handle extends StatefulWidget {
  const Handle({
    super.key,
    required this.position,
    required this.cursorWidth,
    required this.height,
    required this.color,
    required this.onPositionChanged,
  });

  final double position;
  final double cursorWidth;
  final double height;
  final Color color;
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
    return Positioned(
      left: _left,
      top: 0,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            _left += details.delta.dx;
            widget.onPositionChanged(_left);
          });
        },
        // onPanUpdate: (details) {
        //   setState(() {
        //     _left += details.delta.dx;
        //     widget.onPositionChanged(_left);
        //   });
        // },
        child: Container(
          color: widget.color,
          width: widget.cursorWidth,
          height: widget.height,
        ),
      ),
    );
  }
}
