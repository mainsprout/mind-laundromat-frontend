import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Color titleColor;
  final Color? backgroundColor; // ← nullable로 변경

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.titleColor = Colors.black,
    this.backgroundColor, // ← 기본값은 나중에 null 처리로 대체
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: backgroundColor ?? Colors.grey[200], // ← null일 경우 기본 회색
      padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}
