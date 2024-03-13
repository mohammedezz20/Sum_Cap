// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rich_readmore/rich_readmore.dart';
// import 'package:sum_cap/config/themes/colors.dart';
//
// class ChatMessage extends StatelessWidget {
//   final String text;
//   bool isSending = true;
//
//   ChatMessage({super.key, required this.text, required this.isSending});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment:
//           isSending ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           padding: const EdgeInsets.all(10),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: isSending ? AppColor.primaryColor : AppColor.whiteColor,
//             borderRadius: const BorderRadius.all(
//               Radius.circular(10),
//             ),
//             border: Border.all(color: AppColor.primaryColor),
//           ),
//           child: RichReadMoreText.fromString(
//             text: text,
//             textStyle: isSending
//                 ? Theme.of(context)
//                     .textTheme
//                     .titleSmall!
//                     .copyWith(color: AppColor.whiteColor)
//                 : Theme.of(context).textTheme.titleSmall,
//             settings: LengthModeSettings(
//               trimLength: 30,
//               trimCollapsedText: 'show more',
//               trimExpandedText: ' show less ',
//               onPressReadMore: () {},
//               onPressReadLess: () {},
//               lessStyle: TextStyle(color: Colors.black),
//               moreStyle: TextStyle(color: Colors.black),
//             ),
//           ),
//           //     Text(
//           //   text,
//           //   style: isSending
//           //       ? Theme.of(context)
//           //           .textTheme
//           //           .titleSmall!
//           //           .copyWith(color: AppColor.whiteColor)
//           //       : Theme.of(context).textTheme.titleSmall,
//           // ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/features/app_layout/data/models/chat_model.dart';

class ChatItemCard extends StatefulWidget {
  final ChatModel chatItem;

  const ChatItemCard({
    super.key,
    required this.chatItem,
  });

  @override
  State<ChatItemCard> createState() => _ChatItemCardState();
}

class _ChatItemCardState extends State<ChatItemCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Row(
      mainAxisAlignment: widget.chatItem.chat == 0
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.chatItem.chat == 1)
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.reddit_rounded,
              color: AppColor.primaryColor,
            ),
            iconSize: 25,
          ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              margin: const EdgeInsets.only(left: 0, right: 10, top: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.chatItem.chatType == ChatType.error
                    ? Colors.red.withOpacity(0.5)
                    : widget.chatItem.chat == 0
                        ? AppColor.primaryColor
                        : AppColor.whiteColor,
                borderRadius: widget.chatItem.chatType == ChatType.error
                    ? const BorderRadius.all(Radius.circular(30))
                    : widget.chatItem.chat == 0
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(10),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(10),
                          ),
              ),
              child: Column(
                crossAxisAlignment: widget.chatItem.chatType == ChatType.error
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  if (widget.chatItem.chatType == ChatType.loading)
                    const SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                  if (widget.chatItem.chatType != ChatType.loading)
                    ReadMoreText(
                      widget.chatItem.message,
                      style: widget.chatItem.chat == 0
                          ? Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColor.whiteColor)
                          : Theme.of(context).textTheme.titleSmall,
                      trimLines: 5,
                      colorClickableText: AppColor.primaryColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: ' Show less',
                      moreStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.blackColor),
                      lessStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.blackColor),
                    ),
                  // RichReadMoreText.fromString(
                  //   text: widget.chatItem.message,
                  //   textStyle: widget.chatItem.chat == 0
                  //       ? Theme.of(context)
                  //           .textTheme
                  //           .titleSmall!
                  //           .copyWith(color: AppColor.whiteColor)
                  //       : Theme.of(context).textTheme.titleSmall,
                  //   settings: LengthModeSettings(
                  //     trimLength: 30,
                  //
                  //     trimCollapsedText: 'show more',
                  //     trimExpandedText: ' show less ',
                  //     onPressReadMore: () {},
                  //     onPressReadLess: () {},
                  //     lessStyle: const TextStyle(color: AppColor.blackColor),
                  //     moreStyle: const TextStyle(color: AppColor.blackColor),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  TextSpan formatText(String text) {
    RegExp regex = RegExp(r'\*\*(.*?)\*\*');
    List<TextSpan> spans = [];

    text.splitMapJoin(
      regex,
      onMatch: (Match match) {
        spans.add(TextSpan(
          text: match.group(1),
          style: widget.chatItem.chat == 0
              ? Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: AppColor.whiteColor)
              : Theme.of(context).textTheme.titleSmall,
        ));
        return '';
      },
      onNonMatch: (String text) {
        spans.add(TextSpan(text: text));
        return '';
      },
    );
    return TextSpan(children: spans);
  }
}
