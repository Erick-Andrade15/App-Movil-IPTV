import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/utils.dart';
import 'package:flutter/material.dart';

class ButtomMaterial extends StatelessWidget {
  const ButtomMaterial({
    super.key,
    required this.texto,
    required this.icono,
    required this.colorBg,
    required this.onPresed,
    this.focusNodeButtom,
  });

  final String texto;
  final IconData icono;
  final Color colorBg;
  final FocusNode? focusNodeButtom;
  final VoidCallback onPresed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      focusNode: focusNodeButtom,
      focusColor: Const.colorPinkAccent,
      minWidth: 225,
      height: 55,
      onPressed: onPresed,
      color: Const.colorPurpleMediumDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            texto,
            style: Const.fontTitleTextStyle,
          ),
          Utils.horizontalSpace(5),
          Icon(
            icono,
            size: 25,
            color: Const.colorWhite,
          ),
        ],
      ),
    );
  }
}
