import 'package:flutter/material.dart';

/// Rounded card widget.
///  ________________
/// | title          |
/// | _______________|
/// | child          |
/// |________________|
class BaseCardWidget extends StatelessWidget {
  /// Title that gets displayed on top.
  final Widget title;

  /// Child that gets displayed on below a [Divider] and the title.
  final Widget child;

  /// Elevation which creates a dropshadow.
  final double elevation;

  /// Padding of the card.
  final EdgeInsets padding;

  const BaseCardWidget(
      {Key? key,
      this.title = const Text(""),
      this.elevation = 0,
      this.padding = const EdgeInsets.all(0),
      this.child = const Text("")})
      : super(key: key);

  /// Build method
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      elevation: this.elevation,
      child: Padding(
        padding: this.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            this.title,
            Divider(
              thickness: 1,
              indent: 60,
            ),
            this.child,
          ],
        ),
      ),
    );
  }
}
