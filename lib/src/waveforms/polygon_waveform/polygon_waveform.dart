import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
<<<<<<< HEAD
import 'package:flutter_audio_waveforms/src/core/audio_waveform.dart';
import 'package:flutter_audio_waveforms/src/models/duration_segment.dart';
import 'package:flutter_audio_waveforms/src/widgets/handle.dart';
=======
import 'package:flutter_audio_waveforms/src/models/cursor_handle.dart';
import 'package:flutter_audio_waveforms/src/models/handle.dart';
>>>>>>> 9ba57adf50149796dad7a2052c08bf1885b3d4d5
import 'package:flutter_audio_waveforms/src/waveforms/polygon_waveform/active_waveform_painter.dart';
import 'package:flutter_audio_waveforms/src/waveforms/polygon_waveform/inactive_waveform_painter.dart';
import 'package:touchable/touchable.dart';

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
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.blue,
    this.activeGradient,
    this.inactiveGradient,
    this.style = PaintingStyle.stroke,
    super.showActiveWaveform = true,
    super.absolute = false,
    super.invert = false,
<<<<<<< HEAD
    this.onTapUp,
    this.durationSegments,
    this.selectedDurationSegment,
    this.onSelectedDurationSegmentChanged,
    this.onDurationSegmentUpdate,
    this.playing = false,
    super.onPositionChanged,
=======
    this.cursor = false,
    this.cursorWidth = 2.0,
    this.cursorColor = Colors.yellow,
    this.highlightedDurations,
    this.highlightDurationColor = Colors.grey,
    this.startHighlightColor = Colors.blue,
    this.endHighlightColor = Colors.red,
    this.selectedHighlightColor = Colors.red,
    this.selectedDurationColor = Colors.white,
    this.selectedDuration,
    this.onSelectedDurationChanged,
    this.onHighlightedDurationChanged,
    super.onTapDown,
    super.onTapUp,
>>>>>>> 9ba57adf50149796dad7a2052c08bf1885b3d4d5
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

<<<<<<< HEAD
  final Function(Duration position)? onTapUp;

  final List<DurationSegment>? durationSegments;

  final int? selectedDurationSegment;

  final Function(int? selectedDurationSegment)?
      onSelectedDurationSegmentChanged;

  final Function(int index, DurationSegment segment)? onDurationSegmentUpdate;

  final bool playing;
=======
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

  final int? selectedDuration;

  /// Selected Duration Changed
  final Function(int? index)? onSelectedDurationChanged;

  /// onHighlightedDurationChanged
  final Function(int index, DurationSegment duration)?
      onHighlightedDurationChanged;
>>>>>>> 9ba57adf50149796dad7a2052c08bf1885b3d4d5

  @override
  AudioWaveformState<PolygonWaveform> createState() => _PolygonWaveformState();
}

class _PolygonWaveformState extends AudioWaveformState<PolygonWaveform> {
<<<<<<< HEAD
  int _getIndex(Duration duration) {
=======
  // void _onSelectedDurationChanged(int index) {
  //   setState(() {
  //     _selectedDuration = _selectedDuration != index ? index : null;
  //     widget.onSelectedDurationChanged?.call(_selectedDuration);
  //   });
  // }

  double _getIndex(Duration duration) {
>>>>>>> 9ba57adf50149796dad7a2052c08bf1885b3d4d5
    if (maxDuration == null) {
      return 0;
    }
    final durationTimeRatio =
        duration.inMilliseconds / maxDuration!.inMilliseconds;

    final durationIndex = (widget.samples.length * durationTimeRatio).round();

<<<<<<< HEAD
    return durationIndex;
  }

  double _getPosition(Duration duration) {
    // if (maxDuration == null) {
    //   return 0;
    // }
    // final durationTimeRatio =
    //     duration.inMilliseconds / maxDuration!.inMilliseconds;

    // final durationIndex = (widget.samples.length * durationTimeRatio).round();
    final index = _getIndex(duration);

    return index * sampleWidth;
  }

  List<Widget> _buildDurationSegments() {
    final segments = <Widget>[];
    for (var i = 0; i < widget.durationSegments!.length; i++) {
      final durationSegment = widget.durationSegments![i];
      final startPosition = _getPosition(durationSegment.start);
      final endPosition = _getPosition(durationSegment.end);

      segments.add(
        Positioned(
          top: 0,
          left: startPosition,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPress: () {
              setState(() {
                if (widget.selectedDurationSegment == i) {
                  widget.onSelectedDurationSegmentChanged?.call(null);
                } else {
                  widget.onSelectedDurationSegmentChanged?.call(i);
                }
              });
            },
            child: IgnorePointer(
              child: Container(
                color: widget.selectedDurationSegment == i
                    ? Colors.red.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
                height: widget.height * 0.9,
                width: endPosition - startPosition,
              ),
            ),
          ),
        ),
      );
    }

    return segments;
  }

  List<Widget> _buildHandles() {
    final handles = <Widget>[];

    for (var i = 0; i < widget.durationSegments!.length; i++) {
      final durationSegment = widget.durationSegments![i];
      final startHandlePosition = _getPosition(durationSegment.start);
      final endHandlePosition = _getPosition(durationSegment.end);

      final showHandle = widget.selectedDurationSegment == i;

      handles
        ..add(
          Handle(
            height: widget.height,
            width: 2,
            color: Colors.blue,
            position: startHandlePosition,
            maxPosition: endHandlePosition,
            onPositionChanged: (position) {
              setState(() {
                durationSegment.start = _calculateDuration(position);
                widget.onDurationSegmentUpdate?.call(i, durationSegment);
              });
            },
            showHandle: showHandle,
          ),
        )
        ..add(
          Handle(
            height: widget.height,
            width: 2,
            color: Colors.red,
            position: endHandlePosition,
            minPosition: startHandlePosition,
            onPositionChanged: (position) {
              setState(() {
                durationSegment.end = _calculateDuration(position);
                widget.onDurationSegmentUpdate?.call(i, durationSegment);
              });
            },
            showHandle: showHandle,
          ),
        );
    }

    return handles;
=======
    return durationIndex * sampleWidth;
>>>>>>> 9ba57adf50149796dad7a2052c08bf1885b3d4d5
  }

  Duration _calculateDuration(double position) {
    final index = (position / sampleWidth).round();
<<<<<<< HEAD
    final ratio = index / widget.samples.length;
=======

    final ratio = index / widget.samples.length;

>>>>>>> 9ba57adf50149796dad7a2052c08bf1885b3d4d5
    final duration = Duration(
      milliseconds: (ratio * maxDuration!.inMilliseconds).round(),
    );

    return duration;
  }

<<<<<<< HEAD
=======
  List<Handle> get _handles {
    final handles = <Handle>[];
    for (var i = 0; i < widget.highlightedDurations!.length; i++) {
      final duration = widget.highlightedDurations![i];

      final startPosition = _getIndex(duration.start);
      final endPosition = _getIndex(duration.end);

      var showHead = false;
      if (widget.selectedDuration != null && widget.selectedDuration == i) {
        showHead = true;
      }

      handles
        ..add(
          Handle(
            key: ValueKey('${duration.id}.start'),
            position: startPosition,
            cursorWidth: widget.cursorWidth,
            height: widget.height,
            width: widget.width,
            color: Colors.blue,
            onPositionChanged: (position) {
              setState(() {
                duration.start = _calculateDuration(position);
                widget.onHighlightedDurationChanged?.call(i, duration);
              });
            },
            showHead: showHead,
          ),
        )
        ..add(
          Handle(
            key: ValueKey('${duration.id}.end'),
            position: endPosition,
            cursorWidth: widget.cursorWidth,
            height: widget.height,
            width: widget.width,
            color: Colors.red,
            onPositionChanged: (position) {
              setState(() {
                duration.end = _calculateDuration(position);
                widget.onHighlightedDurationChanged?.call(i, duration);
              });
            },
            showHead: showHead,
          ),
        );
    }

    return handles;
  }

>>>>>>> 9ba57adf50149796dad7a2052c08bf1885b3d4d5
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
      clipBehavior: Clip.none,
      children: [
        Container(
          width: widget.width,
          height: widget.height * 0.9,
          color: Colors.black87,
        ),
<<<<<<< HEAD
        GestureDetector(
          onTapUp: (details) {
            final dx = details.localPosition.dx;
            final duration = _calculateDuration(dx);
            widget.onTapUp?.call(duration);
          },
          child: RepaintBoundary(
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
        ),
        if (showActiveWaveform && widget.selectedDurationSegment != null)
          IgnorePointer(
            child: CustomPaint(
              isComplex: true,
              size: Size(widget.width, widget.height),
              painter: PolygonActiveWaveformPainter(
                style: widget.style,
                color: widget.activeColor,
                activeSamples: processedSamples,
                gradient: widget.activeGradient,
                waveformAlignment: waveformAlignment,
                sampleWidth: sampleWidth,
                startIndex: _getIndex(
                  widget
                      .durationSegments![widget.selectedDurationSegment!].start,
                ),
                endIndex: _getIndex(
                  widget.durationSegments![widget.selectedDurationSegment!].end,
                ),
              ),
            ),
=======
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
              GestureType.onTapUp,
              GestureType.onLongPressStart,
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
                  maxDuration: maxDuration,
                  samples: processedSamples,
                  highlightedDurations: widget.highlightedDurations,
                  highlightDurationColor: widget.highlightDurationColor,
                  startHighlightColor: widget.startHighlightColor,
                  endHighlightColor: widget.endHighlightColor,
                  selectedHighlightColor: widget.selectedHighlightColor,
                  selectedDurationColor: widget.selectedDurationColor,
                  selectedDuration: widget.selectedDuration,
                  onSelectedDurationChanged: widget.onSelectedDurationChanged,
                  onTapDown: onTapDown,
                  onTapUp: onTapUp,
                ),
              );
            },
>>>>>>> 9ba57adf50149796dad7a2052c08bf1885b3d4d5
          ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            width: widget.width,
            height: widget.height * 0.1,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
<<<<<<< HEAD
        if (widget.durationSegments != null) ..._buildDurationSegments(),
        if (widget.durationSegments != null) ..._buildHandles(),
        Handle(
          height: widget.height,
          width: 2,
          color: Colors.yellow,
          position: activeSamples.length * sampleWidth,
          onPositionChanged: (position) {
            final duration = _calculateDuration(position);
            widget.onTapUp?.call(duration);
          },
          showHandle: true,
          playing: widget.playing,
=======
        if (widget.highlightedDurations != null) ..._handles,
        CursorHandle(
          position: activeSamples.length * sampleWidth,
          cursorWidth: widget.cursorWidth,
          height: widget.height,
          width: widget.width,
          color: widget.cursorColor,
          showHead: true,
          onPositionChanged: (position) {
            // final dx = details.globalPosition.dx;
            final index = (position / sampleWidth).round();

            final ratio = index / widget.samples.length;

            final duration = Duration(
              milliseconds: (ratio * maxDuration!.inMilliseconds).round(),
            );

            print('here4 $position, $index, $ratio, $duration');

            widget.onTapUp?.call(duration);
          },
>>>>>>> 9ba57adf50149796dad7a2052c08bf1885b3d4d5
        ),
      ],
    );
  }
}
