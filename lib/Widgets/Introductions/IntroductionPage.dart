import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_job/Data/Variables.dart';
import 'package:move_job/Widgets/Introductions/FirstIntroduction.dart';
import 'package:move_job/Widgets/Introductions/SecondIntroduction.dart';
import 'package:move_job/Widgets/Introductions/ThirdIntroduction.dart';
import 'package:move_job/main.dart';

class IntroductionState {
  final int pageIndex;

  IntroductionState(this.pageIndex);
}

class IntroductionNotifier extends StateNotifier<IntroductionState> {
  IntroductionNotifier() : super(IntroductionState(0));

  void setPageIndex(int index) {
    state = IntroductionState(index);
  }
}

final introductionProvider =
    StateNotifierProvider<IntroductionNotifier, IntroductionState>((ref) {
  return IntroductionNotifier();
});

class IntroductionPage extends ConsumerWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(introductionProvider);
    final notifier = ref.read(introductionProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              _animatedOpacity('deliverer', 0, state.pageIndex),
              _animatedOpacity('delivery', 1, state.pageIndex),
              _animatedOpacity('deliverer', 2, state.pageIndex),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: screenHeight * 0.48,
              width: double.infinity,
              child: Image.asset(
                'assets/images/introduction_bg.png',
                fit: BoxFit.fill,
                color: Variables.generalRed,
                colorBlendMode: BlendMode.srcATop,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 9,
                child: Container(),
              ),
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    _pageControlTexts(
                        const FirstIntroduction(), 0, state.pageIndex),
                    _pageControlTexts(
                        const SecondIntroduction(), 1, state.pageIndex),
                    _pageControlTexts(
                        const ThirdIntroduction(), 2, state.pageIndex),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                flex: 9,
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.05, 0, screenWidth * 0.05, 0),
                        child: MaterialButton(
                          shape: const StadiumBorder(),
                          height: screenHeight * 0.04,
                          color: Variables.generalRed,
                          onPressed: () {
                            if (state.pageIndex != 0) {
                              notifier.setPageIndex(state.pageIndex - 1);
                            } else {
                              ref.read(startWidget.notifier).updateWidget(null);
                            }
                          },
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              state.pageIndex == 0 ? 'Atla' : 'Geri',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _dots(0, 3, 0, state.pageIndex),
                          _dots(3, 3, 1, state.pageIndex),
                          _dots(3, 0, 2, state.pageIndex),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.05, 0, screenWidth * 0.05, 0),
                        child: MaterialButton(
                          shape: const StadiumBorder(),
                          height: screenHeight * 0.04,
                          color: Variables.generalRed,
                          onPressed: () {
                            if (state.pageIndex == 2) {
                              ref.read(startWidget.notifier).updateWidget(null);
                            } else {
                              notifier.setPageIndex(state.pageIndex + 1);
                            }
                          },
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              state.pageIndex == 2 ? 'Giriş' : 'İleri',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pageControlTexts(Widget child, int index, int pageIndex) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: pageIndex == index ? 1 : 0,
      child: child,
    );
  }

  Widget _dots(double left, double right, int index, int pageIndex) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, 0, right, 0),
      child: Container(
        width: pageIndex == index ? screenWidth * 0.0425 : screenWidth * 0.035,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: pageIndex == index
              ? Variables.generalRed
              : Variables.generalRed.withOpacity(0.25),
        ),
      ),
    );
  }

  Widget _animatedOpacity(String image, int index, int pageIndex) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: pageIndex == index ? 1 : 0,
      child: _pages('assets/images/$image.jpg'),
    );
  }

  Widget _pages(String image) {
    return Center(
      child: SizedBox(
        height: screenHeight,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: screenWidth,
            height: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
