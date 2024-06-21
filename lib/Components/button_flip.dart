import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonFlip extends StatefulWidget {
  final String textLabelYes;
  final String textLabelNo;
  final String iconYes;
  final String iconNo;
  final bool isyes;
  final Function(bool) onButtonPressed;

  const ButtonFlip({
    Key? key,
    required this.textLabelYes,
    required this.textLabelNo,
    required this.iconYes,
    required this.iconNo,
    required this.onButtonPressed,
    this.isyes = false,
  }) : super(key: key);

  @override
  ButtonFlipState createState() => ButtonFlipState();
}

class ButtonFlipState extends State<ButtonFlip> {
  @override
  Widget build(BuildContext context) {
    bool isYes = widget.isyes;
    return SizedBox(
      height: 60,
      width: 200,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              color: isYes ? ThemeColours.positive : ThemeColours.negative,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 0,
                color: Colors.transparent,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(-6, -6),
                  color: ThemeColours.shadowLight,
                ),
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(6, 6),
                  color: ThemeColours.shadowDark,
                ),
              ]),
          child: Stack(
            children: [
              Positioned(
                top: 7,
                left: isYes ? null : 7,
                right: isYes ? 7 : null,
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: ThemeColours.bgBlueWhite,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 0,
                      color: Colors.transparent,
                    ),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(-1, -1),
                          color: ThemeColours.shadowLight,
                          inset: true),
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(1, 1),
                          color: ThemeColours.shadowDark,
                          inset: true),
                    ],
                  ),
                  child: SvgPicture.asset(
                      isYes ? widget.iconYes : widget.iconNo,
                      height: 40,
                      width: 40,
                      fit: BoxFit.scaleDown),
                ),
              ),
              Positioned(
                top: 22,
                left: isYes ? 30 : null,
                right: isYes ? null : 30,
                child: Text(
                  isYes ? widget.textLabelYes : widget.textLabelNo,
                  style: const TextStyle(
                    color: ThemeColours.txtWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          isYes = !isYes;
          setState(() {
            widget.onButtonPressed(isYes);
          });
        },
      ),
    );
  }
}
