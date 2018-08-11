library cupertino_range_slider;

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

/// An iOS-style slider.
///
/// Used to select from a range of values.
///
/// A slider can be used to select from either a continuous or a discrete set of
/// values. The default is use a continuous range of values from [min] to [max].
/// To use discrete values, use a non-null value for [divisions], which
/// indicates the number of discrete intervals. For example, if [min] is 0.0 and
/// [max] is 50.0 and [divisions] is 5, then the slider can take on the values
/// discrete values 0.0, 10.0, 20.0, 30.0, 40.0, and 50.0.
///
/// The slider itself does not maintain any state. Instead, when the state of
/// the slider changes, the widget calls the [onChanged] callback. Most widgets
/// that use a slider will listen for the [onChanged] callback and rebuild the
/// slider with a new [value] to update the visual appearance of the slider.
///
/// See also:
///
///  * <https://developer.apple.com/ios/human-interface-guidelines/controls/sliders/>
class CupertinoRangeSlider extends StatefulWidget {
  /// Creates an iOS-style slider.
  ///
  /// The slider itself does not maintain any state. Instead, when the state of
  /// the slider changes, the widget calls the [onChanged] callback. Most widgets
  /// that use a slider will listen for the [onChanged] callback and rebuild the
  /// slider with a new [value] to update the visual appearance of the slider.
  ///
  /// * [value] determines currently selected value for this slider.
  /// * [onChanged] is called when the user selects a new value for the slider.
  const CupertinoRangeSlider({
    Key key,
    @required this.minValue,
    @required this.maxValue,
    @required this.onMinChanged,
    @required this.onMaxChanged,
    this.min: 0.0,
    this.max: 1.0,
    this.divisions,
    this.activeColor: CupertinoColors.activeBlue,
  })  : assert(minValue != null),
        assert(maxValue != null),
        assert(min != null),
        assert(max != null),
        assert(minValue >= min && maxValue <= max && minValue <= maxValue),
        assert(divisions == null || divisions > 0),
        super(key: key);

  /// The currently selected value for this slider.
  ///
  /// The slider's thumb is drawn at a position that corresponds to this value.
  //final double value;

  final double minValue;
  final double maxValue;

  /// Called when the user selects a new value for the slider.
  ///
  /// The slider passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the slider with the new
  /// value.
  ///
  /// If null, the slider will be displayed as disabled.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// new CupertinoSlider(
  ///   value: _duelCommandment.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<double> onMinChanged;
  final ValueChanged<double> onMaxChanged;

  /// The minimum value the user can select.
  ///
  /// Defaults to 0.0.
  final double min;

  /// The maximum value the user can select.
  ///
  /// Defaults to 1.0.
  final double max;

  /// The number of discrete divisions.
  ///
  /// If null, the slider is continuous.
  final int divisions;

  /// The color to use for the portion of the slider that has been selected.
  final Color activeColor;

  @override
  _CupertinoRangeSliderState createState() => new _CupertinoRangeSliderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(new DoubleProperty('minValue', minValue));
    properties.add(new DoubleProperty('maxValue', maxValue));
    properties.add(new DoubleProperty('min', min));
    properties.add(new DoubleProperty('max', max));
  }
}

class _CupertinoRangeSliderState extends State<CupertinoRangeSlider>
    with TickerProviderStateMixin {
  void _handleMinChanged(double value) {
    assert(widget.onMinChanged != null);
    final nextValue = value * (widget.max - widget.min) + widget.min;
    final v = nextValue > widget.maxValue ? widget.maxValue : nextValue;
    widget.onMinChanged(v);
  }

  void _handleMaxChanged(double value) {
    assert(widget.onMaxChanged != null);
    final nextValue = value * (widget.max - widget.min) + widget.min;
    final v = nextValue < widget.minValue ? widget.minValue : nextValue;
    widget.onMaxChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    return new _CupertinoSliderRenderObjectWidget(
      minValue: (widget.minValue - widget.min) / (widget.max - widget.min),
      maxValue: (widget.maxValue - widget.min) / (widget.max - widget.min),
      divisions: widget.divisions,
      activeColor: widget.activeColor,
      onMinChanged: widget.onMinChanged != null ? _handleMinChanged : null,
      onMaxChanged: widget.onMaxChanged != null ? _handleMaxChanged : null,
      vsync: this,
    );
  }
}

class _CupertinoSliderRenderObjectWidget extends LeafRenderObjectWidget {
  const _CupertinoSliderRenderObjectWidget({
    Key key,
    //this.value,
    this.minValue,
    this.maxValue,
    this.divisions,
    this.activeColor,
    this.onMinChanged,
    this.onMaxChanged,
    this.vsync,
  }) : super(key: key);

  //final double value;
  final double minValue;
  final double maxValue;
  final int divisions;
  final Color activeColor;
  final ValueChanged<double> onMinChanged;
  final ValueChanged<double> onMaxChanged;
  final TickerProvider vsync;

  @override
  _RenderCupertinoSlider createRenderObject(BuildContext context) {
    return new _RenderCupertinoSlider(
      minValue: minValue,
      maxValue: maxValue,
      divisions: divisions,
      activeColor: activeColor,
      onMinChanged: onMinChanged,
      onMaxChanged: onMaxChanged,
      vsync: vsync,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderCupertinoSlider renderObject) {
    renderObject
      ..minValue = minValue
      ..maxValue = maxValue
      ..divisions = divisions
      ..activeColor = activeColor
      ..onMinChanged = onMinChanged
      ..onMaxChanged = onMaxChanged
      ..textDirection = Directionality.of(context);
    // Ticker provider cannot change since there's a 1:1 relationship between
    // the _SliderRenderObjectWidget object and the _SliderState object.
  }
}

const double _kPadding = 8.0;
const int _kMinThumb = 1;
const int _kMaxThumb = 2;
const Color _kTrackColor = const Color(0xFFB5B5B5);
const double _kSliderHeight = 2.0 * (CupertinoThumbPainter.radius + _kPadding);
const double _kSliderWidth = 176.0; // Matches Material Design slider.
const Duration _kDiscreteTransitionDuration = const Duration(milliseconds: 500);

const double _kAdjustmentUnit =
0.1; // Matches iOS implementation of material slider.

class _RenderCupertinoSlider extends RenderConstrainedBox {
  _RenderCupertinoSlider({
    @required double minValue,
    @required double maxValue,
    int divisions,
    Color activeColor,
    ValueChanged<double> onMinChanged,
    ValueChanged<double> onMaxChanged,
    TickerProvider vsync,
    @required TextDirection textDirection,
  })  : assert(minValue != null && minValue >= 0.0 && minValue <= 1.0),
        assert(maxValue != null && maxValue >= 0.0 && maxValue <= 1.0),
        assert(textDirection != null),
        _minValue = minValue,
        _maxValue = maxValue,
        _divisions = divisions,
        _activeColor = activeColor,
        _onMinChanged = onMinChanged,
        _onMaxChanged = onMaxChanged,
        _textDirection = textDirection,
        super(
          additionalConstraints: const BoxConstraints.tightFor(
              width: _kSliderWidth, height: _kSliderHeight)) {
    _drag = new HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd;
    _minPosition = new AnimationController(
      value: minValue,
      duration: _kDiscreteTransitionDuration,
      vsync: vsync,
    )..addListener(markNeedsPaint);
    _maxPosition = new AnimationController(
      value: maxValue,
      duration: _kDiscreteTransitionDuration,
      vsync: vsync,
    )..addListener(markNeedsPaint);
  }

  //double get value => _value;
  //double _value;

  double get minValue => _minValue;
  double _minValue;

  double get maxValue => _maxValue;
  double _maxValue;

  set minValue(double newValue) {
    assert(newValue != null && newValue >= 0.0 && newValue <= 1.0);
    if (newValue == _minValue) return;
    _minValue = newValue;
    if (divisions != null)
      _minPosition.animateTo(newValue, curve: Curves.fastOutSlowIn);
    else
      _minPosition.value = newValue;
  }

  set maxValue(double newValue) {
    assert(newValue != null && newValue >= 0.0 && newValue <= 1.0);
    if (newValue == _maxValue) return;
    _maxValue = newValue;
    if (divisions != null)
      _maxPosition.animateTo(newValue, curve: Curves.fastOutSlowIn);
    else
      _maxPosition.value = newValue;
  }

  int get divisions => _divisions;
  int _divisions;

  set divisions(int value) {
    if (value == _divisions) return;
    _divisions = value;
    markNeedsPaint();
  }

  Color get activeColor => _activeColor;
  Color _activeColor;

  set activeColor(Color value) {
    if (value == _activeColor) return;
    _activeColor = value;
    markNeedsPaint();
  }

  ValueChanged<double> get onMinChanged => _onMinChanged;
  ValueChanged<double> _onMinChanged;

  ValueChanged<double> get onMaxChanged => _onMaxChanged;
  ValueChanged<double> _onMaxChanged;

  set onMinChanged(ValueChanged<double> value) {
    if (value == _onMinChanged) return;
    final bool wasInteractive = isInteractive;
    _onMinChanged = value;
    if (wasInteractive != isInteractive) markNeedsSemanticsUpdate();
  }

  set onMaxChanged(ValueChanged<double> value) {
    if (value == _onMaxChanged) return;

    final bool wasInteractive = isInteractive;
    _onMaxChanged = value;
    if (wasInteractive != isInteractive) markNeedsSemanticsUpdate();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    assert(value != null);
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
  }

  AnimationController _minPosition;
  AnimationController _maxPosition;

  HorizontalDragGestureRecognizer _drag;
  double _currentDragValue = 0.0;
  int pickedThumb = 123;

  double get _discretizedCurrentDragValue {
    double dragValue = _currentDragValue.clamp(0.0, 1.0);
    if (divisions != null)
      dragValue = (dragValue * divisions).round() / divisions;
    return dragValue;
  }

  double get _trackLeft => _kPadding;

  double get _trackRight => size.width - _kPadding;

  double get _minThumbCenter {
    double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - _minValue;
        break;
      case TextDirection.ltr:
        visualPosition = _minValue;
        break;
    }
    return lerpDouble(_trackLeft + CupertinoThumbPainter.radius,
        _trackRight - CupertinoThumbPainter.radius, visualPosition);
  }

  double get _maxThumbCenter {
    double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - _maxValue;
        break;
      case TextDirection.ltr:
        visualPosition = _maxValue;
        break;
    }
    return lerpDouble(_trackLeft + CupertinoThumbPainter.radius,
        _trackRight - CupertinoThumbPainter.radius, visualPosition);
  }

  bool get isInteractive => (onMinChanged != null && onMaxChanged != null);

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) {
      _currentDragValue = pickedThumb == _kMinThumb ? _minValue : _maxValue;

      if (pickedThumb == _kMinThumb) {
        onMinChanged(_discretizedCurrentDragValue);
      } else {
        onMaxChanged(_discretizedCurrentDragValue);
      }
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      final double extent = math.max(_kPadding,
          size.width - 2.0 * (_kPadding + CupertinoThumbPainter.radius));
      final double valueDelta = details.primaryDelta / extent;
      switch (textDirection) {
        case TextDirection.rtl:
          _currentDragValue -= valueDelta;
          break;
        case TextDirection.ltr:
          _currentDragValue += valueDelta;
          break;
      }

      if (pickedThumb == _kMinThumb) {
        onMinChanged(_discretizedCurrentDragValue);
      } else {
        onMaxChanged(_discretizedCurrentDragValue);
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    _currentDragValue = 0.0;
  }

  @override
  bool hitTestSelf(Offset position) {
    if ((position.dx - _minThumbCenter).abs() <
        CupertinoThumbPainter.radius + _kPadding) {
      pickedThumb = _kMinThumb;
      return true;
    }

    if ((position.dx - _maxThumbCenter).abs() <
        CupertinoThumbPainter.radius + _kPadding) {
      pickedThumb = _kMaxThumb;
      return true;
    }

    return false;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) _drag.addPointer(event);
  }

  final CupertinoThumbPainter _thumbPainter = new CupertinoThumbPainter();

  @override
  void paint(PaintingContext context, Offset offset) {
    //final double minVisualPosition = _minPosition.value;
    //final double maxVisualPosition = _maxPosition.value;
    final Color betweenColor = _activeColor;
    final Color aroundColor = _kTrackColor;

    final double trackCenter = offset.dy + size.height / 2.0;
    final double trackLeft = offset.dx + _trackLeft;
    final double trackTop = trackCenter - 1.0;
    final double trackBottom = trackCenter + 1.0;
    final double trackRight = offset.dx + _trackRight;
//    final double trackActive = offset.dx + _thumbCenter;

    final double trackMinActive = offset.dx + _minThumbCenter;
    final double trackMaxActive = offset.dx + _maxThumbCenter;

    final Canvas canvas = context.canvas;
    final Paint paint = new Paint();

    paint.color = aroundColor;
    canvas.drawRRect(
        new RRect.fromLTRBXY(
            trackLeft, trackTop, trackRight, trackBottom, 1.0, 1.0),
        paint);

    paint.color = betweenColor;
    canvas.drawRRect(
        new RRect.fromLTRBXY(
            trackMinActive, trackTop, trackMaxActive, trackBottom, 1.0, 1.0),
        paint);

    final Offset minThumbCenter = new Offset(trackMinActive, trackCenter);
    final Offset maxThumbCenter = new Offset(trackMaxActive, trackCenter);

    _thumbPainter.paint(
        canvas,
        new Rect.fromCircle(
            center: minThumbCenter, radius: CupertinoThumbPainter.radius));

    _thumbPainter.paint(
        canvas,
        new Rect.fromCircle(
            center: maxThumbCenter, radius: CupertinoThumbPainter.radius));
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.isSemanticBoundary = isInteractive;
    if (isInteractive) {
      config.onIncrease = _increaseAction;
      config.onDecrease = _decreaseAction;
    }
  }

  double get _semanticActionUnit =>
      divisions != null ? 1.0 / divisions : _kAdjustmentUnit;

  void _increaseAction() {
    if (isInteractive) {
      if (pickedThumb == _kMinThumb) {
        onMinChanged((minValue + _semanticActionUnit).clamp(0.0, 1.0));
      } else {
        onMaxChanged((maxValue + _semanticActionUnit).clamp(0.0, 1.0));
      }
    }
  }

  void _decreaseAction() {
    if (isInteractive) {
      if (pickedThumb == _kMinThumb) {
        onMinChanged((minValue - _semanticActionUnit).clamp(0.0, 1.0));
      } else {
        onMaxChanged((maxValue - _semanticActionUnit).clamp(0.0, 1.0));
      }
    }
  }
}
