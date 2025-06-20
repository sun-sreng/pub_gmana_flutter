import 'package:flutter/material.dart';

import 'models/delayed_animation_tween.dart';
import 'scale_y_widget.dart';

class SpinKitWave extends StatefulWidget {
  final Color? color;
  final SpinKitWaveType type;
  final int itemCount;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  const SpinKitWave({
    super.key,
    this.color,
    this.type = SpinKitWaveType.start,
    this.size = 50.0,
    this.itemBuilder,
    this.itemCount = 5,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  }) : assert(
         !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
             !(itemBuilder == null && color == null),
         'You should specify either a itemBuilder or a color',
       ),
       assert(itemCount >= 2, 'itemCount cannot be less than 2');

  @override
  State<SpinKitWave> createState() => _SpinKitWaveState();
}

enum SpinKitWaveType { start, end, center }

class _SpinKitWaveState extends State<SpinKitWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    final List<double> bars = getAnimationDelay(widget.itemCount);
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 1.25, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bars.length, (i) {
            return ScaleYWidget(
              scaleY: DelayedAnimationTween(
                begin: .4,
                end: 1.0,
                delay: bars[i],
              ).animate(_controller),
              child: SizedBox.fromSize(
                size: Size(widget.size / widget.itemCount, widget.size),
                child: _itemBuilder(i),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  List<double> getAnimationDelay(int itemCount) {
    switch (widget.type) {
      case SpinKitWaveType.start:
        return _startAnimationDelay(itemCount);
      case SpinKitWaveType.end:
        return _endAnimationDelay(itemCount);
      case SpinKitWaveType.center:
        return _centerAnimationDelay(itemCount);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        (widget.controller ??
              AnimationController(vsync: this, duration: widget.duration))
          ..repeat();
  }

  List<double> _centerAnimationDelay(int count) {
    return <double>[
      ...List<double>.generate(
        count ~/ 2,
        (index) => -1.0 + (index * 0.2) + 0.2,
      ).reversed,
      if (count.isOdd) -1.0,
      ...List<double>.generate(
        count ~/ 2,
        (index) => -1.0 + (index * 0.2) + 0.2,
      ),
    ];
  }

  List<double> _endAnimationDelay(int count) {
    return <double>[
      ...List<double>.generate(
        count ~/ 2,
        (index) => -1.0 + (index * 0.1) + 0.1,
      ).reversed,
      if (count.isOdd) -1.0,
      ...List<double>.generate(
        count ~/ 2,
        (index) => -1.0 - (index * 0.1) - (count.isOdd ? 0.1 : 0.0),
      ),
    ];
  }

  Widget _itemBuilder(int index) =>
      widget.itemBuilder != null
          ? widget.itemBuilder!(context, index)
          : DecoratedBox(decoration: BoxDecoration(color: widget.color));

  List<double> _startAnimationDelay(int count) {
    return <double>[
      ...List<double>.generate(
        count ~/ 2,
        (index) => -1.0 - (index * 0.1) - 0.1,
      ).reversed,
      if (count.isOdd) -1.0,
      ...List<double>.generate(
        count ~/ 2,
        (index) => -1.0 + (index * 0.1) + (count.isOdd ? 0.1 : 0.0),
      ),
    ];
  }
}
