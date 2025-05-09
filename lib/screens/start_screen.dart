import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool? _isLoggedIn;
  double _dragPosition = 0.0;
  double _maxDragDistance = 0.0;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = loggedIn;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_completed) return;

    setState(() {
      _dragPosition += details.delta.dx;
      if (_dragPosition < 0) _dragPosition = 0;
      if (_dragPosition > _maxDragDistance) {
        _dragPosition = _maxDragDistance;
        _handleSlideComplete();
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragPosition < _maxDragDistance) {
      setState(() => _dragPosition = 0);
    }
  }

  Future<void> _handleSlideComplete() async {
    if (_completed) return;
    setState(() => _completed = true);

    await Future.delayed(const Duration(milliseconds: 300));
    if (_isLoggedIn == true) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Mind Laundry",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "For the thoughts left unsaid —\nwe’re here to listen and help you through.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                _maxDragDistance = width - 160;

                return Center(
                  child: Container(
                    width: width,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.black12,
                    ),
                    child: Stack(
                      children: [
                        // 오른쪽 그라데이션 >>>>
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black26,
                                    Colors.black87,
                                  ],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.srcIn,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Text(
                                  '>>>>',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 드래그 버튼
                        Positioned(
                          left: _dragPosition,
                          child: GestureDetector(
                            onPanUpdate: _onPanUpdate,
                            onPanEnd: _onPanEnd,
                            child: Container(
                              width: 160,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.black,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Get Started",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
