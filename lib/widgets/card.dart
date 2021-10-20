import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final bool gradient;
  final bool button;
  final Color color;
  final double width;
  final double height;
  final Widget child;
  final int duration;
  final Border border;
  final func;
  CardWidget({
    @required this.gradient,
    @required this.button,
    this.color,
    this.width,
    this.height,
    @required this.child,
    this.duration,
    this.func,
    this.border,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 25,
            offset: Offset(0, 10),
            color: Color(0x1A636363),
          ),
        ],
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: duration ?? 500),
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: border ??
                Border.all(
                  color: Colors.white,
                  width: 0,
                ),
            color: color ?? Colors.blue,
            // gradient: gradient
            //     ? Colors.lightBlueAccent
            //     : LinearGradient(colors: [
            //         color ?? Colors.white,
            //         color ?? Colors.white,
            //       ]),
          ),
          child: button
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    child: child,
                    onPressed: func,
                  ),
                )
              : child,
        ),
      ),
    );
  }
}
