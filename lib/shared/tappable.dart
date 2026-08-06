import 'package:flutter/widgets.dart';

class Tappable extends StatefulWidget {
  const Tappable({
    required this.child,
    this.onTap,
    this.onLongTap,
    this.scale = .9,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutExpo,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;
  final double scale;
  final Duration duration;
  final Curve curve;

  @override
  State<Tappable> createState() => _TappableState();
}

class _TappableState extends State<Tappable> {
  bool _pressed = false;

  bool get _enabled => widget.onTap != null || widget.onLongTap != null;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    if (!_enabled) return widget.child;

    return GestureDetector(
      // behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onLongPress: widget.onLongTap,
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: Listener(
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: AnimatedScale(
          duration: widget.duration,
          curve: widget.curve,
          scale: _pressed ? widget.scale : 1,
          child: widget.child,
        ),
      ),
    );
  }
}
