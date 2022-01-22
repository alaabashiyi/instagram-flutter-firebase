import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? onPress;
  final Color backgroundColor;
  final Color borderColor;
  final String title;
  final Color titleColor;

  const FollowButton({
    Key? key,
    required this.onPress,
    required this.backgroundColor,
    required this.borderColor,
    required this.title,
    required this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2.0),
      child: TextButton(
        onPressed: onPress,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5.0),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          width: 250.0,
          height: 27.0,
        ),
      ),
    );
  }
}
