import 'package:app_movil_iptv/utils/consts.dart';
import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  const SettingCard(
      {Key? key,
      required this.child,
      required this.onTapFuncion,
      required this.colorBg,
      this.focusNodeCard})
      : super(key: key);
  final Widget child;
  final VoidCallback onTapFuncion;
  final Color colorBg;
  final FocusNode? focusNodeCard;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNodeCard,
      child: GestureDetector(
        onTap: onTapFuncion,
        child: Container(
            decoration: BoxDecoration(
                color: focusNodeCard?.hasFocus ?? false
                    ? Const.colorPinkAccent
                    : colorBg,
                borderRadius: BorderRadius.circular(20)),
            child: child),
      ),
    );
  }
}
