import 'package:flutter/material.dart';

import '../styles/colors.dart';

class MainButton extends StatelessWidget {
  const MainButton(
      {super.key,
      required this.child,
      this.enabled = true,
      this.fixedSize,
      this.onPressed});

  final Widget child;
  final bool enabled;
  final MaterialStateProperty<Size?>? fixedSize;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          enabled ? MyColors.green : MyColors.green.withOpacity(0.5),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        padding: (fixedSize == null)
            ? MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
              )
            : null,
        alignment: Alignment.center,
        fixedSize: fixedSize,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
