import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sum_cap/core/utils/assets_manager.dart';
import 'package:sum_cap/features/auth/presentation/widgets/onboarding_widget.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/themes/colors.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<String> images = [
    Assets.onBoaring1,
    Assets.onBoaring2,
    Assets.onBoaring3,
  ];
  List<String> titles = [
    "Audio To Text",
    "text to conversation",
    "Sync across devices",
  ];
  List<String> subTitles = [
    "Transform spoken words into text effortlessly with SumCap's audio-to-text conversion feature.",
    "Convert transcribed audio recordings into structured AI-based conversations for improved note-taking and data extraction, focusing on key information and action items.",
    "Manage recording ,transcripts and notes seamlessly across different devicdevices .",
  ];

  final controller = PageController();
  int currentPage = 0;
  PageEnum page = PageEnum.page1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffF3F8F4),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: controller,
                  onPageChanged: (value) {
                    if (value == 0) {
                      page = PageEnum.page1;
                    } else if (value == 1) {
                      page = PageEnum.page2;
                    } else if (value == 2) {
                      page = PageEnum.page3;
                    }
                    currentPage = value;
                    setState(() {});
                  },
                  itemCount: images.length,
                  itemBuilder: (_, index) {
                    return OnBoardingItem(
                      imagePath: images[index],
                      title: titles[index],
                      subTitle: subTitles[index],
                    );
                  }),
            ),
            SizedBox(
              height: 75.h,
              child: Row(
                children: [
                  (page.name != PageEnum.page1.name)
                      ? CupertinoButton(
                          child: const Text(
                            "Previous",
                            style: TextStyle(color: AppColor.primaryColor),
                          ),
                          onPressed: () {
                            controller.animateToPage(currentPage - 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                            currentPage -= 1;
                          },
                        )
                      : const Text(
                          "Previous",
                          style: TextStyle(color: Colors.transparent),
                        ),
                  const Spacer(),
                  SmoothPageIndicator(
                    controller: controller,
                    onDotClicked: (index) {
                      controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                      currentPage = index;
                    },
                    count: images.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 15,
                      activeDotColor: Colors.black,
                      dotColor: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  (page.name != PageEnum.page3.name)
                      ? CupertinoButton(
                          child: const Text(
                            "Next",
                            style: TextStyle(color: AppColor.primaryColor),
                          ),
                          onPressed: () {
                            controller.animateToPage(currentPage + 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                            currentPage += 1;
                            setState(() {});
                          },
                        )
                      : CupertinoButton(
                          child: const Text(
                            "Get Started",
                            style: TextStyle(color: AppColor.primaryColor),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.login);
                          },
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum PageEnum {
  page1,
  page2,
  page3,
}
