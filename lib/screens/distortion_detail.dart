import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class DistortionDetail extends StatefulWidget {
  const DistortionDetail({super.key});

  @override
  State<DistortionDetail> createState() => _DistortionDetailState();
}

class _DistortionDetailState extends State<DistortionDetail> {
  final List<String> distortionNames = [
    'BLACK_AND_WHITE_THINKING',
    'BLAMING',
    'CONTROL_FALLACY',
    'DISQUALIFYING_THE_POSITIVE',
    'EMOTIONAL_REASONING',
    'FALLACY_OF_FAIRNESS',
    'FORTUNE_TELLING',
    'JUMPING_TO_CONCLUSIONS',
    'LABELING',
    'MAGNIFICATION',
    'MENTAL_FILTERING',
    'MIND_READING',
    'MINIMIZATION',
    'OVERGENERALIZATION',
    'PERSONALIZATION',
    'SHOULD_STATEMENTS',
  ];

  void _changeImage(bool isNext) {
    setState(() {
      if (isNext) {
        // 오른쪽 버튼 클릭 시 인덱스 증가
        selectedIndex = (selectedIndex + 1) % distortionNames.length;
      } else {
        // 왼쪽 버튼 클릭 시 인덱스 감소
        selectedIndex = (selectedIndex - 1 + distortionNames.length) % distortionNames.length;
      }
    });
  }

  int selectedIndex = 13; // 기본으로 OVERGENERALIZATION (index 13)
  bool isDescription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: const CustomAppBar(title: 'My Distortion'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 카드 이미지 (그림자 + 카드)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/distortion_card/card_shadow.png',
                      height: 400,
                    ),
                    GestureDetector(
                      onTap: () {
                        // 클릭 시 이미지 변경
                        setState(() {
                          isDescription = !isDescription; // 클릭 시 설명 이미지로 전환
                        });
                      },
                      child: Image.asset(
                        isDescription
                            ? 'assets/distortion_card/description/${distortionNames[selectedIndex]}.png' // 설명 이미지
                            : 'assets/distortion_card/${distortionNames[selectedIndex]}.png', // 원래 이미지
                        height: 370,
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      child: Image.asset(
                        'assets/icons/flip.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
                // 왼쪽 화살표
                Positioned(
                  left: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_left),
                      onPressed: () {
                        debugPrint('Left arrow clicked');
                        _changeImage(false);
                        isDescription=false;
                      },
                    ),
                  ),
                ),

                // 오른쪽 화살표 버튼
                Positioned(
                  right: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_right),
                      onPressed: () {
                        debugPrint('Right arrow clicked');
                        _changeImage(true);
                        isDescription=false;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// GridView
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  debugPrint('Refreshed!');
                },
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: distortionNames.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        isDescription=false;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/distortion_card/icons/${distortionNames[index]}.png',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
