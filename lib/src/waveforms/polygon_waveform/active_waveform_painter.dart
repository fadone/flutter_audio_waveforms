import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
import 'package:flutter_audio_waveforms/src/models/duration_segment.dart';
import 'package:flutter_audio_waveforms/src/util/waveform_alignment.dart';
import 'package:flutter_audio_waveforms/src/waveforms/polygon_waveform/polygon_waveform.dart';
import 'package:touchable/touchable.dart';

///ActiveWaveformPainter for the [PolygonWaveform]
class PolygonActiveWaveformPainter extends ActiveWaveformPainter {
  // ignore: public_member_api_docs
  PolygonActiveWaveformPainter({
    required super.color,
    super.gradient,
    required super.activeSamples,
    required super.waveformAlignment,
    required super.style,
    required super.sampleWidth,
<<<<<<< HEAD
    required this.startIndex,
    required this.endIndex,
  });

  final int startIndex;
  final int endIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final continousActivePaint = Paint()
=======
    super.highlightedDurations,
    this.maxDuration,
    required super.samples,
    required this.highlightDurationColor,
    required this.startHighlightColor,
    required this.endHighlightColor,
    this.selectedDuration,
    this.onSelectedDurationChanged,
    required this.selectedHighlightColor,
    required this.selectedDurationColor,
    required super.context,
    super.onTapDown,
    super.onTapUp,
  });

  /// Max Duration
  final Duration? maxDuration;

  /// Highlight Duration color
  final Color highlightDurationColor;

  /// Start Highlight Duration color
  final Color startHighlightColor;

  /// Start Highlight Duration color
  final Color endHighlightColor;

  /// Selected Duration Color
  final Color selectedHighlightColor;

  /// Selected Duration color
  final Color selectedDurationColor;

  final int? selectedDuration;

  /// on Selected Duration Index Changed
  final Function(int? index)? onSelectedDurationChanged;

  // void _onTapDown(TapDownDetails details) {
  //   final duration = _calculateDuration(details.localPosition.dx);
  //   onTapDown?.call(duration);
  // }

  int _getIndex(Duration duration) {
    final durationTimeRatio =
        duration.inMilliseconds / maxDuration!.inMilliseconds;

    final durationIndex = (samples.length * durationTimeRatio).round();

    return durationIndex;
  }

  void _highlightDuration(
    DurationSegment duration,
    int index,
    TouchyCanvas touchyCanvas,
    Size size,
  ) {
    final startIndex = _getIndex(duration.start) * sampleWidth;
    final endIndex = _getIndex(duration.end) * sampleWidth;

    touchyCanvas.drawRect(
      Rect.fromLTWH(
        startIndex,
        0,
        endIndex - startIndex,
        size.height,
      ),
      Paint()
        ..color = selectedDuration == index
            ? selectedHighlightColor.withOpacity(0.3)
            : highlightDurationColor.withOpacity(0.3),
      // onDoubleTapDown: (details) {
      //   onSelectedDurationChanged?.call(index);
      // },
      onLongPressStart: (details) {
        if (selectedDuration == index) {
          onSelectedDurationChanged?.call(null);
        } else {
          onSelectedDurationChanged?.call(index);
        }
      },
    );
  }

  void _drawSelectedPath(Canvas canvas, Size size) {
    final startIndex =
        _getIndex(highlightedDurations![selectedDuration!].start);
    final endIndex = _getIndex(highlightedDurations![selectedDuration!].end);

    final paint = Paint()
>>>>>>> 9ba57adf50149796dad7a2052c08bf1885b3d4d5
      ..style = style
      ..color = selectedDurationColor
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path()..moveTo(startIndex * sampleWidth, 0);
<<<<<<< HEAD
    final isStroked = style == PaintingStyle.stroke;

    for (var i = startIndex; i <= endIndex; i++) {
=======

    for (var i = startIndex; i < endIndex; i++) {
>>>>>>> 9ba57adf50149796dad7a2052c08bf1885b3d4d5
      final x = sampleWidth * i;
      final y = samples[i];

      if (i == samples.length - 1) {
        path.lineTo(x, 0);
      } else {
        path.lineTo(x, y);
      }
    }

    //Gets the [alignPosition] depending on [waveformAlignment]
    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    //Shifts the path along y-axis by amount of [alignPosition]
    final shiftedPath = path.shift(Offset(0, alignPosition));

    canvas.drawPath(shiftedPath, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final touchyCanvas = TouchyCanvas(context, canvas);

    final newSize = Size(size.width, size.height * 0.9);

    if (highlightedDurations != null) {
      for (var i = 0; i < highlightedDurations!.length; i++) {
        _highlightDuration(
          highlightedDurations![i],
          i,
          touchyCanvas,
          newSize,
        );
      }
    }

    if (selectedDuration != null) {
      _drawSelectedPath(canvas, size);
    }

    TouchyCanvas(context, canvas).drawRect(
      Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width,
        height: size.height,
      ),
      Paint()..color = Colors.transparent,
      // onTapDown: onTapDown,
      onTapUp: onTapUp,
    );
  }
}
