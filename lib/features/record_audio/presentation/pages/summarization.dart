import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';

class SummarizationScreens extends StatefulWidget {
  SummarizationScreens(
      {super.key, required this.SummaryText, required this.isArabic});
  String SummaryText;
  bool isArabic;
  @override
  State<SummarizationScreens> createState() => _SummarizationScreensState();
}

class _SummarizationScreensState extends State<SummarizationScreens> {
  final FlutterTts _flutterTts = FlutterTts();

  bool isPaused = true;
  List<Map> _voices = [];
  Map? _currentVoice;

  int? _currentWordStart, _currentWordEnd;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);
        setState(() {
          _voices = (widget.isArabic)
              ? voices.where((voice) => voice["name"].contains("ar")).toList()
              : voices.where((voice) => voice["name"].contains("en")).toList();
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Summary",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColor.blackColor),
        ),
        leading: IconButton(
            onPressed: () {
              _flutterTts.stop();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
      ),
      backgroundColor: AppColor.offWhiteColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.whiteColor,
                    ),
                    child: DropdownButton(
                      underline: Container(),
                      dropdownColor: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      style: Theme.of(context).textTheme.titleSmall,
                      value: _currentVoice,
                      items: _voices
                          .map(
                            (voice) => DropdownMenuItem(
                              value: voice,
                              child: Text(
                                voice["name"],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        _currentVoice = value;
                        setVoice(_currentVoice!);
                        setState(() {});
                      },
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (isPaused == true) {
                            _flutterTts.speak(widget.SummaryText.substring(
                                _currentWordStart ?? 0));
                            isPaused = false;
                            setState(() {});
                          } else {
                            _flutterTts.pause();
                            isPaused = true;
                            setState(() {});
                          }
                        },
                        icon: isPaused
                            ? Container(
                                padding: EdgeInsets.all(5.w),
                                decoration: const BoxDecoration(
                                  color: AppColor.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: AppColor.whiteColor,
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(5.w),
                                decoration: const BoxDecoration(
                                  color: AppColor.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.pause,
                                  color: AppColor.whiteColor,
                                ),
                              ),
                      ),
                      IconButton(
                        onPressed: () {
                          _flutterTts.stop();
                        },
                        icon: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: const BoxDecoration(
                            color: AppColor.redColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.stop,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              10.h.sizedBoxHeight,
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.primaryColor),
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColor.blackColor,
                          fontSize: 16.sp,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            widget.SummaryText.substring(0, _currentWordStart),
                      ),
                      if (_currentWordStart != null)
                        TextSpan(
                          text: widget.SummaryText.substring(
                              _currentWordStart!, _currentWordEnd),
                          style: const TextStyle(
                            color: Colors.black,
                            backgroundColor: AppColor.greyColor,
                          ),
                        ),
                      if (_currentWordEnd != null)
                        TextSpan(
                          text: widget.SummaryText.substring(_currentWordEnd!),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
