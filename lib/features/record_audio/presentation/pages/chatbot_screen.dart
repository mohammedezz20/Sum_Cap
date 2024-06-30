import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/core/widgets/custom_form_field.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/chatbot_cubit/chatbot_cubit.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/chatbot_cubit/chatbot_states.dart';
import 'package:sum_cap/features/record_audio/presentation/widgets/chat_message_widget.dart';

class ChatBotScreen extends StatelessWidget {
  String transcriptionText = '';

  ChatBotScreen({super.key, required this.transcriptionText});

  @override
  Widget build(BuildContext context) {
    ChatBotCubit cubit = ChatBotCubit.get(context);
    return BlocConsumer<ChatBotCubit, ChatBotStates>(
      bloc: cubit.init(transcriptionText),
      builder: (BuildContext context, state) {
        return Container(
          color: AppColor.offWhiteColor,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColor.offWhiteColor,
              appBar: AppBar(
                backgroundColor: AppColor.whiteColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    cubit.chatList.clear();
                    cubit.messages = [];
                    transcriptionText = '';
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  'SumCap Bot',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColor.blackColor),
                ),
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  cubit.chatList.isEmpty
                      ? Expanded(
                          child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5.w),
                              child: CustomButton(
                                  widget: Padding(
                                    padding: EdgeInsets.all(5.w),
                                    child: const Text(
                                      'key topics discussed in the audio?',
                                      style: TextStyle(
                                          color: AppColor.primaryColor),
                                    ),
                                  ),
                                  height: 50.h,
                                  width: double.infinity,
                                  onTap: () {
                                    cubit.askChatBot(transcriptionText,
                                        "key topics discussed in the audio?");
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.w),
                              child: CustomButton(
                                  widget: Padding(
                                    padding: EdgeInsets.all(5.w),
                                    child: const Text(
                                      'Are there any important dates or events mentioned?',
                                      style: TextStyle(
                                          color: AppColor.primaryColor),
                                    ),
                                  ),
                                  height: 60.h,
                                  width: double.infinity,
                                  onTap: () {
                                    cubit.askChatBot(transcriptionText,
                                        "Are there any important dates or events mentioned?");
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.w),
                              child: CustomButton(
                                  widget: Padding(
                                    padding: EdgeInsets.all(5.w),
                                    child: const Text(
                                      'Can you list any notable quotes from the audio?',
                                      style: TextStyle(
                                          color: AppColor.primaryColor),
                                    ),
                                  ),
                                  height: 60.h,
                                  width: double.infinity,
                                  onTap: () {
                                    cubit.askChatBot(transcriptionText,
                                        "Can you list any notable quotes from the audio?");
                                  }),
                            ),
                          ],
                        ))
                      : Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return ChatItemCard(
                                  chatItem: cubit.chatList[index]);
                            },
                            itemCount: cubit.chatList.length,
                          ),
                        ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomFormField(
                            controller: cubit.textController,
                            backgroundColor: AppColor.offWhiteColor,
                            hintText: 'ask anything...',
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        10.w.sizedBoxWidth,
                        (state is AskChatBotLoadingState)
                            ? const CircularProgressIndicator(
                                color: AppColor.primaryColor,
                              )
                            : IconButton(
                                onPressed: () async {
                                  if (cubit.textController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please enter text'),
                                      ),
                                    );
                                    return;
                                  }
                                  cubit.askChatBot(transcriptionText,
                                      cubit.textController.text);
                                },
                                icon: CircleAvatar(
                                  radius: 25.h,
                                  backgroundColor:
                                      const Color.fromARGB(255, 72, 241, 112),
                                  child: const Icon(
                                    Icons.send,
                                    size: 20,
                                    color: AppColor.blackColor,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
