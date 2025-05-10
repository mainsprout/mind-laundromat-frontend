import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/widgets.dart';

Widget getDistortionImage(String distortionType, {double size = 48.0}) {
  final path = 'assets/distortions/${distortionType.toUpperCase()}.svg';
  return SvgPicture.asset(
    path,
    width: size,
    height: size,
    fit: BoxFit.contain,
    placeholderBuilder: (context) => const SizedBox(),
  );
}