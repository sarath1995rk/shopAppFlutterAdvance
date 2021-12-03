import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconName;
  final Function onPress;

  CustomIconButton(this.iconName, this.onPress);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () => onPress, icon: Icon(iconName));
  }
}
