import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';

import '../../../../core/utils/enums.dart';

class AudioTopic extends StatefulWidget {
  AudioModel audioModel;
  AudioTopic({super.key, required this.audioModel});

  @override
  State<AudioTopic> createState() => _AudioTopicState();
}

class _AudioTopicState extends State<AudioTopic> {
  List<bool>? isexpanded;
  @override
  void initState() {
    isexpanded = List.filled(widget.audioModel.topics!.length, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Audio Topics',
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {});
                  isexpanded![index] = !isexpanded![index];
                },
                children: List.generate(
                  widget.audioModel.topics!.length,
                  (index) {
                    String title = '';
                    for (var element
                        in widget.audioModel.topics![index].topics) {
                      title += ' , ${element.topic}';
                    }
                    title = title.substring(2);
                    return ExpansionPanel(
                      backgroundColor: AppColor.offWhiteColor,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(title),
                          onTap: () {
                            setState(() {
                              log(isexpanded![index].toString());
                              isexpanded![index] = !isexpanded![index];
                            });
                          },
                        );
                      },
                      body: ListTile(
                        subtitle: Text(widget.audioModel.topics![index].text),
                      ),
                      isExpanded: isexpanded![index],
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
