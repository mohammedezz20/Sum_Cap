import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini_bot/services/gemini_ai_api.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/chatbot_cubit/chatbot_states.dart';

import '../../../../app_layout/data/models/chat_model.dart';

class ChatBotCubit extends Cubit<ChatBotStates> {
  ChatBotCubit() : super(ChatBotInitState());

  static ChatBotCubit get(context) => BlocProvider.of(context);
  final List<ChatModel> chatList = [];
  List<Map<String, String>> messages = [];
  TextEditingController textController = TextEditingController();

  init(String transcriptionText) {
    messages.add({"text": transcriptionText});
    emit(ChatBotInitState());
  }

  askChatBot(String transcriptionText, String question) async {
    chatList.add(
      ChatModel(
          chat: 0,
          message: question,
          time: "${DateTime.now().hour}:${DateTime.now().second}"),
    );

    chatList.add(
      ChatModel(chatType: ChatType.loading, chat: 1, message: '', time: ""),
    );
    messages.add({
      "text": "$transcriptionText\n$question",
    });
    textController.text = "";
    emit(AskChatBotLoadingState());
    var (responseString, response) = await GeminiApi.geminiChatApi(
        messages: messages, apiKey: 'AIzaSyAZ9fB6JQB_FyuuQtaatHaGDFIRhMBaWDY');
    if (response.statusCode == 200) {
      chatList.removeLast();
      chatList.add(
        ChatModel(
            chat: 1,
            message: responseString,
            time: "${DateTime.now().hour}:${DateTime.now().second}"),
      );
      emit(AskChatBotSuccessState());
    } else {
      chatList.removeLast();
      chatList.add(ChatModel(
          chat: 0,
          chatType: ChatType.error,
          message: 'error while fetching data.',
          time: "${DateTime.now().hour}:${DateTime.now().second}"));
      emit(AskChatBotErrorState());
    }
  }
}
