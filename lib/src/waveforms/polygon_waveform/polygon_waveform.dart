import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_audio_waveforms/src/core/audio_waveform.dart';
import 'package:flutter_audio_waveforms/src/models/duration_segment.dart';
import 'package:flutter_audio_waveforms/src/waveforms/polygon_waveform/active_waveform_painter.dart';
import 'package:flutter_audio_waveforms/src/waveforms/polygon_waveform/inactive_waveform_painter.dart';
import 'package:touchable/touchable.dart';

import '../../models/handle.dart';

/// [PolygonWaveform] paints the standard waveform that is used for audio
/// waveforms, a sharp continuous line joining the points of a waveform.
///
/// {@tool snippet}
/// Example :
/// ```dart
/// PolygonWaveform(
///   maxDuration: maxDuration,
///   elapsedDuration: elapsedDuration,
///   samples: samples,
///   height: 300,
///   width: MediaQuery.of(context).size.width,
/// )
///```
/// {@end-tool}
class PolygonWaveform extends AudioWaveform {
  // ignore: public_member_api_docs
  PolygonWaveform({
    super.key,
    required super.samples,
    required super.height,
    required super.width,
    super.maxDuration,
    super.elapsedDuration,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.blue,
    this.activeGradient,
    this.inactiveGradient,
    this.style = PaintingStyle.stroke,
    super.showActiveWaveform = true,
    super.absolute = false,
    super.invert = false,
    this.onTapDown,
    this.cursor = false,
    this.cursorWidth = 2.0,
    this.cursorColor = Colors.yellow,
    this.highlightedDurations,
    this.highlightDurationColor = Colors.grey,
    this.startHighlightColor = Colors.blue,
    this.endHighlightColor = Colors.red,
    this.selectedHighlightColor = Colors.red,
    this.selectedDurationColor = Colors.white,
    this.onSelectedDurationChanged,
    this.onHighlightedDurationChanged,
  });

  /// active waveform color
  final Color activeColor;

  /// inactive waveform color
  final Color inactiveColor;

  /// active waveform gradient
  final Gradient? activeGradient;

  /// inactive waveform gradient
  final Gradient? inactiveGradient;

  /// waveform style
  final PaintingStyle style;

  /// onTapDown which receives duration
  final Function(Duration duration)? onTapDown;

  /// Whether to show cursor or not
  final bool cursor;

  /// Cursor width
  final double cursorWidth;

  /// Cursor color
  final Color cursorColor;

  /// Highlight Duration color
  final Color highlightDurationColor;

  /// Highlighted Durations
  final List<DurationSegment>? highlightedDurations;

  /// Start Highlight Duration color
  final Color startHighlightColor;

  /// Start Highlight Duration color
  final Color endHighlightColor;

  /// Selected Highlight color
  final Color selectedHighlightColor;

  /// Selected Duration color
  final Color selectedDurationColor;

  /// Selected Duration Changed
  final Function(int? index)? onSelectedDurationChanged;

  /// onHighlightedDurationChanged
  final Function(int index, DurationSegment duration)?
      onHighlightedDurationChanged;

  @override
  AudioWaveformState<PolygonWaveform> createState() => _PolygonWaveformState();
}

class _PolygonWaveformState extends AudioWaveformState<PolygonWaveform> {
  int? _selectedDuration;

  void _onSelectedDurationChanged(int index) {
    setState(() {
      _selectedDuration = _selectedDuration != index ? index : null;
      widget.onSelectedDurationChanged?.call(_selectedDuration);
    });
  }

  double _getIndex(Duration duration) {
    if (maxDuration == null) {
      return 0;
    }
    final durationTimeRatio =
        duration.inMilliseconds / maxDuration!.inMilliseconds;

    final durationIndex = (widget.samples.length * durationTimeRatio).round();

    return durationIndex * sampleWidth;
  }

  Duration _calculateDuration(double position) {
    final index = (position / sampleWidth).round();

    final ratio = index / widget.samples.length;

    final duration = Duration(
      milliseconds: (ratio * maxDuration!.inMilliseconds).round(),
    );

    return duration;
  }

  List<Handle> get _handles {
    final handles = <Handle>[];
    for (var i = 0; i < widget.highlightedDurations!.length; i++) {
      final duration = widget.highlightedDurations![i];

      final startPostion = _getIndex(duration.start);
      final endPostion = _getIndex(duration.end);
      handles
        ..add(
          Handle(
            // key: UniqueKey(),
            position: startPostion,
            cursorWidth: widget.cursorWidth,
            height: widget.height,
            color: Colors.blue,
            onPositionChanged: (position) {
              setState(() {
                duration.start = _calculateDuration(position);
                widget.onHighlightedDurationChanged?.call(i, duration);
              });
            },
          ),
        )
        ..add(
          Handle(
            position: endPostion,
            cursorWidth: widget.cursorWidth,
            height: widget.height,
            color: Colors.red,
            onPositionChanged: (position) {
              setState(() {
                duration.end = _calculateDuration(position);
                widget.onHighlightedDurationChanged?.call(i, duration);
              });
            },
          ),
        );
    }

    return handles;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.samples.isEmpty) {
      return const SizedBox.shrink();
    }
    final processedSamples = this.processedSamples;
    final activeSamples = this.activeSamples;
    final showActiveWaveform = this.showActiveWaveform;
    final waveformAlignment = this.waveformAlignment;
    final sampleWidth = this.sampleWidth;

    return Stack(
      children: [
        RepaintBoundary(
          child: CustomPaint(
            size: Size(widget.width, widget.height),
            isComplex: true,
            painter: PolygonInActiveWaveformPainter(
              samples: processedSamples,
              style: widget.style,
              color: widget.inactiveColor,
              gradient: widget.inactiveGradient,
              waveformAlignment: waveformAlignment,
              sampleWidth: sampleWidth,
            ),
          ),
        ),
        if (showActiveWaveform)
          CanvasTouchDetector(
            gesturesToOverride: const [
              GestureType.onTapDown,
              GestureType.onDoubleTapDown,
              GestureType.onPanUpdate,
            ],
            builder: (context) {
              return CustomPaint(
                isComplex: true,
                size: Size(widget.width, widget.height),
                painter: PolygonActiveWaveformPainter(
                  style: widget.style,
                  color: widget.activeColor,
                  activeSamples: activeSamples,
                  gradient: widget.activeGradient,
                  waveformAlignment: waveformAlignment,
                  sampleWidth: sampleWidth,
                  context: context,
                  onTapDown: widget.onTapDown,
                  cursor: widget.cursor,
                  cursorWidth: widget.cursorWidth,
                  cursorColor: widget.cursorColor,
                  maxDuration: maxDuration,
                  samples: processedSamples,
                  highlightedDurations: widget.highlightedDurations,
                  highlightDurationColor: widget.highlightDurationColor,
                  startHighlightColor: widget.startHighlightColor,
                  endHighlightColor: widget.endHighlightColor,
                  selectedHighlightColor: widget.selectedHighlightColor,
                  selectedDurationColor: widget.selectedDurationColor,
                  selectedDuration: _selectedDuration,
                  onSelectedDurationChanged: _onSelectedDurationChanged,
                ),
              );
            },
          ),
        ..._handles,
      ],
    );
  }
}
