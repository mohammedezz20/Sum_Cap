import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
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
          color: AppColor.whiteColor,
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
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ChatItemCard(chatItem: cubit.chatList[index]);
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
                        IconButton(
                          onPressed: () async {
                            cubit.askChatBot(transcriptionText);
                          },
                          icon: const Icon(
                            Icons.send,
                            color: AppColor.primaryColor,
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
