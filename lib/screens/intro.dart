import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      showNextButton: true,
      showDoneButton: true,
      showSkipButton: true,
      pages: [
        PageViewModel(
          image: SvgPicture.asset('assets/intro1.svg'),
          title: "Todo App",
        )
      ],
    );
  }
}
