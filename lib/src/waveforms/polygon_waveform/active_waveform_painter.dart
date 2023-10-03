import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
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
    required this.context,
    this.onTapDown,
    required this.cursor,
    required this.cursorWidth,
    required this.cursorColor,
    super.highlightedDurations,
    this.maxDuration,
    required super.samples,
    required this.highlightDurationColor,
    required this.startHighlightColor,
    required this.endHighlightColor,
    super.selectedDuration,
    this.onSelectedDurationChanged,
    required this.selectedDurationColor,
    this.onPanUpdate,
  });

  /// BuildContext
  final BuildContext context;

  /// onTap Function
  final Function(Duration duration)? onTapDown;

  /// Whether to show cursor or not
  final bool cursor;

  /// Cursor width
  final double cursorWidth;

  /// Cursor color
  final Color cursorColor;

  /// Max Duration
  final Duration? maxDuration;

  /// Highlight Duration color
  final Color highlightDurationColor;

  /// Start Highlight Duration color
  final Color startHighlightColor;

  /// Start Highlight Duration color
  final Color endHighlightColor;

  /// Selected Duration Color
  final Color selectedDurationColor;

  /// on Selected Duration Index Changed
  final Function(int index)? onSelectedDurationChanged;

  /// onPanUpdate
  final Function(Duration duration, int index, String type)? onPanUpdate;

  void _onTapDown(TapDownDetails details) {
    final duration = _calculateDuration(details.localPosition.dx);
    onTapDown?.call(duration);
  }

  double _getIndex(Duration duration) {
    final durationTimeRatio =
        duration.inMilliseconds / maxDuration!.inMilliseconds;

    final durationIndex = (samples.length * durationTimeRatio).round();

    return durationIndex * sampleWidth;
  }

  Duration _calculateDuration(double position) {
    final index = (position / sampleWidth).round();

    final ratio = index / samples.length;

    final duration = Duration(
      milliseconds: (ratio * maxDuration!.inMilliseconds).round(),
    );

    return duration;
  }

  void _highlightDuration(
    Map<String, Duration> duration,
    int index,
    TouchyCanvas touchyCanvas,
    Size size,
  ) {
    final startIndex = _getIndex(duration['start']!);
    final endIndex = _getIndex(duration['end']!);

    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    touchyCanvas
      ..drawRect(
        Rect.fromLTWH(
          startIndex,
          0,
          endIndex - startIndex,
          size.height,
        ),
        Paint()
          ..color = selectedDuration == index
              ? selectedDurationColor.withOpacity(0.3)
              : highlightDurationColor.withOpacity(0.3),
        onDoubleTapDown: (details) {
          onSelectedDurationChanged?.call(index);
        },
      )
      ..drawRect(
        Rect.fromCenter(
          center: Offset(startIndex, alignPosition),
          width: cursorWidth,
          height: size.height,
        ),
        Paint()..color = startHighlightColor,
        onPanUpdate: (details) {
          final duration = _calculateDuration(startIndex + details.delta.dx);

          onPanUpdate?.call(duration, index, 'start');
        },
      )
      ..drawRect(
        Rect.fromCenter(
          center: Offset(endIndex, alignPosition),
          width: cursorWidth,
          height: size.height,
        ),
        Paint()..color = endHighlightColor,
        onPanUpdate: (details) {
          final duration = _calculateDuration(endIndex + details.delta.dx);

          onPanUpdate?.call(duration, index, 'end');
        },
      );
  }

  void _drawPath(Canvas canvas, Size size) {
    final continousActivePaint = Paint()
      ..style = style
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path();
    final isStroked = style == PaintingStyle.stroke;

    for (var i = 0; i < activeSamples.length; i++) {
      final x = sampleWidth * i;
      final y = activeSamples[i];
      if (isStroked) {
        path.lineTo(x, y);
      } else {
        if (i == activeSamples.length - 1) {
          path.lineTo(x, 0);
        } else {
          path.lineTo(x, y);
        }
      }
    }

    //Gets the [alignPosition] depending on [waveformAlignment]
    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    //Shifts the path along y-axis by amount of [alignPosition]
    final shiftedPath = path.shift(Offset(0, alignPosition));

    canvas.drawPath(shiftedPath, continousActivePaint);
  }

  void _drawCursor(TouchyCanvas touchyCanvas, Size size) {
    final centerX = sampleWidth * (activeSamples.length - 1);

    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    touchyCanvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, alignPosition),
        width: cursorWidth,
        height: size.height,
      ),
      Paint()..color = cursorColor,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final touchyCanvas = TouchyCanvas(context, canvas);

    if (highlightedDurations != null) {
      for (var i = 0; i < highlightedDurations!.length; i++) {
        _highlightDuration(highlightedDurations![i], i, touchyCanvas, size);
      }
    }

    if (!cursor) {
      _drawPath(canvas, size);
    } else {
      _drawCursor(touchyCanvas, size);
    }

    touchyCanvas.drawRect(
      Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width,
        height: size.height,
      ),
      Paint()..color = Colors.transparent,
      hitTestBehavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
    );
  }
}
