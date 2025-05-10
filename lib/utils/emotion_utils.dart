import 'package:flutter/material.dart';

/*
이미지를 넣고 싶은 부분에
getEmotionImage(_diary!.emotionType, size: 32),
 */

Widget getEmotionImage(String emotionType, {double size = 40}) {
  final imagePath = 'assets/emotions/${emotionType.toLowerCase()}.png';
  return Image.asset(
    imagePath,
    width: size,
    height: size,
  );
}
