import 'package:flutter/material.dart';

import 'delay_tween.dart';

class GSpinnerDot extends StatefulWidget {
  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  const GSpinnerDot({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1400),
    this.controller,
  }) : assert(
         !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
             !(itemBuilder == null && color == null),
         'You should specify either a itemBuilder or a color',
       );

  @override
  State<GSpinnerDot> createState() => _GSpinnerDotState();
}

class _GSpinnerDotState extends State<GSpinnerDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (i) {
            return ScaleTransition(
              scale: DelayTween(
                begin: 0.0,
                end: 1.0,
                delay: i * .2,
              ).animate(_controller),
              child: SizedBox.fromSize(
                size: Size.square(widget.size * 0.5),
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

  @override
  void initState() {
    super.initState();
    _controller =
        (widget.controller ??
              AnimationController(vsync: this, duration: widget.duration))
          ..repeat();
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
        ? widget.itemBuilder!(context, index)
        : DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        );
  }
}
