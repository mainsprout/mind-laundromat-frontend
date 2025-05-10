import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';

class DistortionDetail extends StatelessWidget {
  const DistortionDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> iconPaths = [
      'assets/distortion_card/icons/BLACK_AND_WHITE_THINKING.png',
      'assets/distortion_card/icons/BLAMING.png',
      'assets/distortion_card/icons/CONTROL_FALLACY.png',
      'assets/distortion_card/icons/DISQUALIFYING_THE_POSITIVE.png',
      'assets/distortion_card/icons/EMOTIONAL_REASONING.png',
      'assets/distortion_card/icons/FALLACY_OF_FAIRNESS.png',
      'assets/distortion_card/icons/FORTUNE_TELLING.png',
      'assets/distortion_card/icons/JUMPING_TO_CONCLUSIONS.png',
      'assets/distortion_card/icons/LABELING.png',
      'assets/distortion_card/icons/MAGNIFICATION.png',
      'assets/distortion_card/icons/MENTAL_FILTERING.png',
      'assets/distortion_card/icons/MIND_READING.png',
      'assets/distortion_card/icons/MINIMIZATION.png',
      'assets/distortion_card/icons/OVERGENERALIZATION.png',
      'assets/distortion_card/icons/PERSONALIZATION.png',
      'assets/distortion_card/icons/SHOULD_STATEMENTS.png',
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: const CustomAppBar(title: 'My Distortion'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/distortion_card/card_shadow.png',
              height: 400,
            ),
          ),
          const SizedBox(height: 20),
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
                  itemCount: iconPaths.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        debugPrint('Box $index clicked');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(iconPaths[index]),
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
