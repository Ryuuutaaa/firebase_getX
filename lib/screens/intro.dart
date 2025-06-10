import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/get_core.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      showNextButton: true,
      showDoneButton: true,
      showSkipButton: false,
      done: const Text("Done"),
      onDone: () => Get.to(() => Home()),
      next: const Icon(Icons.arrow_forward),
      pages: [
        PageViewModel(
          image: SvgPicture.asset('assets/intro1.svg'),
          title: "Todo App",
          body: "A simple todo app with a lorem 12 words and a button",
          decoration: const PageDecoration(
            imagePadding: EdgeInsets.only(top: 50.0),
          ),
        ),
        PageViewModel(
          image: SvgPicture.asset('assets/intro2.svg'),
          title: "Easy to use",
          body: "A simple todo app with a lorem 12 words and a button",
          decoration: const PageDecoration(
            imagePadding: EdgeInsets.only(top: 50.0),
          ),
        ),
      ],
    );
  }
}
