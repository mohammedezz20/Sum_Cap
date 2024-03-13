import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/enums.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_cubit.dart';
import 'package:sum_cap/features/record_audio/presentation/pages/audio_topics.dart';
import 'package:sum_cap/features/record_audio/presentation/pages/chatbot_screen.dart';
import 'package:sum_cap/features/record_audio/presentation/widgets/option_file_widget.dart';
import 'package:sum_cap/features/record_audio/presentation/widgets/play_audio_file.dart'
    as play_audio_file;

class RecordDetails extends StatefulWidget {
  AudioModel audio;

  RecordDetails(this.audio, {super.key});

  @override
  State<RecordDetails> createState() => _RecordDetailsState();
}

class _RecordDetailsState extends State<RecordDetails> {
  late AudioPlayer advancedPlayer;
  @override
  void initState() {
    advancedPlayer = AudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AudioCubit.get(context);
    return DefaultTabController(
      length: 2,
      child: BlocConsumer<AudioCubit, AudioState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            color: AppColor.whiteColor,
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  actions: [
                    CupertinoButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.audio.status = FileStatus.removing;
                          cubit.deleteAudio(widget.audio, context);
                        },
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColor.primaryColor,
                        )),
                    20.w.sizedBoxWidth,
                  ],
                ),
                backgroundColor: AppColor.offWhiteColor,
                body: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.w),
                          child: TextFormField(
                            cursorColor: AppColor.blackColor,
                            style: const TextStyle(
                              color: AppColor.blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            readOnly: (cubit.dataStatus == DataStatus.readOnly)
                                ? true
                                : false,
                            controller: cubit.nameController,
                            decoration: const InputDecoration(
                              hintText: 'New Recording',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(),
                              focusedErrorBorder: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(10),
                              hintStyle: TextStyle(
                                color: AppColor.blackColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        5.h.sizedBoxHeight,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: AppColor.greyColor,
                                  size: 14.w,
                                ),
                                Text(
                                  "${widget.audio.createdAt.day}/${widget.audio.createdAt.month}/${widget.audio.createdAt.year}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: AppColor.greyColor,
                                          fontSize: 14.sp),
                                ),
                                20.w.sizedBoxWidth,
                                Text(
                                  DateFormat('hh:mm a').format(
                                    widget.audio.createdAt.toUtc().add(
                                          const Duration(hours: 2),
                                        ),
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: AppColor.greyColor,
                                          fontSize: 14.sp),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 14.w,
                                  color: AppColor.primaryColor,
                                ),
                                5.w.sizedBoxWidth,
                                Text(
                                  widget.audio.duration,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.text_fields_outlined,
                                  size: 15.w,
                                  color: AppColor.primaryColor,
                                ),
                                5.w.sizedBoxWidth,
                                Text(
                                  '${widget.audio.transcriptionText.length}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontSize: 14.sp,
                                          color: AppColor.greyColor),
                                ),
                                Text(
                                  ' letters',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontSize: 14.sp,
                                          color: AppColor.greyColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                        20.h.sizedBoxHeight,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OptionButton(
                                buttonText:
                                    (cubit.dataStatus == DataStatus.readOnly)
                                        ? 'Edit'
                                        : 'Save',
                                icon: (cubit.dataStatus == DataStatus.readOnly)
                                    ? Icons.edit
                                    : FontAwesomeIcons.floppyDisk,
                                onTap: () {
                                  cubit.changeDataStatus(context);
                                },
                                width: 65.w,
                                height: 36.h,
                              ),
                              20.w.sizedBoxWidth,
                              (state is SummarizeAudioLoadingState)
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColor.primaryColor,
                                      ),
                                    )
                                  : OptionButton(
                                      buttonText: 'Summary',
                                      icon: FontAwesomeIcons.wandMagicSparkles,
                                      onTap: () {
                                        cubit.summarizeText(
                                            widget.audio.transcriptionText,
                                            context);
                                      },
                                      width: 93.w,
                                      height: 36.h,
                                    ),
                              20.w.sizedBoxWidth,
                              (state is TranslateAudioLoadingState)
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColor.primaryColor,
                                      ),
                                    )
                                  : OptionButton(
                                      buttonText: 'Translate',
                                      icon: FontAwesomeIcons.language,
                                      onTap: () {
                                        cubit.translateText(
                                            widget.audio.transcriptionText,
                                            context);
                                      },
                                      width: 87.w,
                                      height: 36.h,
                                    ),
                              20.w.sizedBoxWidth,
                              OptionButton(
                                buttonText: 'Copy',
                                icon: FontAwesomeIcons.copy,
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: widget.audio.transcriptionText));
                                  context.showAwesomeSnackbar(
                                      contentType: ContentType.success,
                                      title: '',
                                      message: 'Copied to clipboard');
                                },
                                width: 65.w,
                                height: 36.h,
                              ),
                              20.w.sizedBoxWidth,
                              OptionButton(
                                buttonText: 'Topics',
                                icon: FontAwesomeIcons.layerGroup,
                                onTap: () {
                                  var newaudioModel = widget.audio;
                                  List<Topic> topic = [];
                                  for (var element in widget.audio.topics!) {
                                    if (element.topics.isNotEmpty) {
                                      topic.add(element);
                                    }
                                  }
                                  newaudioModel.topics = topic;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AudioTopic(
                                                audioModel: newaudioModel,
                                              )));
                                },
                                width: 75.w,
                                height: 36.h,
                              ),
                              20.w.sizedBoxWidth,
                              OptionButton(
                                buttonText: ' ChatBot',
                                icon: FontAwesomeIcons.robot,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatBotScreen(
                                                transcriptionText: widget
                                                    .audio.transcriptionText,
                                              )));
                                },
                                width: 80.w,
                                height: 36.h,
                              ),
                            ],
                          ),
                        ),
                        20.h.sizedBoxHeight,
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.w),
                          child: SingleChildScrollView(
                            child: TextFormField(
                              cursorColor: AppColor.blackColor,
                              style: const TextStyle(
                                color: AppColor.blackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              onTapOutside: (_) {
                                widget.audio.transcriptionText =
                                    cubit.transcriptionController.text;

                                FocusScope.of(context).unfocus();
                              },
                              readOnly:
                                  (cubit.dataStatus == DataStatus.readOnly)
                                      ? true
                                      : false,
                              controller: cubit.transcriptionController,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                hintText: 'Transcription ...',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(5),
                                hintStyle: TextStyle(
                                  color: AppColor.blackColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        play_audio_file.AdvancedAudioPlayer(
                          audioModel: widget.audio,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum DataStatus { readOnly, readAndWrite }
