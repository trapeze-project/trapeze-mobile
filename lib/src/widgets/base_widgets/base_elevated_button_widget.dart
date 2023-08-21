import 'package:flutter/material.dart';
import 'package:flutternativetrapeze/src/config/theme.dart';

/// This [BaseElevatedButtonWidget] is a ElevatedButton with a fixed size, we use throughout the project.
///  _______________________
/// |SizedBox_______________|
/// ||ElevatedButton       ||
/// ||   ________________  ||
/// ||  |                | ||
/// ||  | Text           | ||
/// ||  |________________| ||
/// ||_____________________||
///
class BaseElevatedButtonWidget extends StatelessWidget {
  /// The CallBack Function which gets executed on every tap.
  final VoidCallback? onPressed;

  /// Name of the Button as a [String].
  final String name;
  final double width;
  final double height;
  const BaseElevatedButtonWidget({
    Key? key,
    required this.onPressed,
    this.name = "",
    this.height = 50,
    this.width = 200,
  }) : super(key: key);

  /// This method builds a button with the size of the [SizedBox].
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: this.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.TRAPEZE_YELLOW,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          this.name,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
