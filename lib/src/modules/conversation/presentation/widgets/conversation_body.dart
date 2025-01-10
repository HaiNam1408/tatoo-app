import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/extensions/shimmer_effect.dart';
import '../../../../common/utils/format_time_utils.dart';
import '../../application/conversation_cubit.dart';
import '../../application/conversation_state.dart';
import '../widgets/message_card.dart';
import '../widgets/message_input.dart';

class ConversationBody extends StatefulWidget {
  final String userName;
  final String avatarUrl;
  final int receiverId;
  const ConversationBody(
      {super.key,
      required this.userName,
      required this.avatarUrl,
      required this.receiverId});

  @override
  State<ConversationBody> createState() => _ConversationBodyState();
}

class _ConversationBodyState extends State<ConversationBody>
    with TickerProviderStateMixin {
  late final AnimationController topAnimationController;
  late final AnimationController bottomAnimationController;

  late final Animation<Offset> slideTopAnimation;
  late final Animation<Offset> slideBottomAnimation;

  @override
  void initState() {
    super.initState();

    topAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    bottomAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    slideTopAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: topAnimationController,
      curve: Curves.easeInOut,
    ));

    slideBottomAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: bottomAnimationController,
      curve: Curves.linear,
    ));

    topAnimationController.forward();
    bottomAnimationController.forward();
  }

  @override
  void dispose() {
    topAnimationController.dispose();
    bottomAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationCubit, ConversationState>(
        builder: (context, state) => PopScope(
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) {
                  topAnimationController.reverse();
                  bottomAnimationController.reverse();
                }
              },
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(80),
                  child: AppBar(
                    scrolledUnderElevation: 0,
                    leading: const SizedBox(),
                    titleSpacing: 0,
                    flexibleSpace: SlideTransition(
                      position: slideTopAnimation,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => context.router.maybePop(),
                                child: SlideTransition(
                                  position: slideTopAnimation,
                                  child: Assets.icons.arrowLeft.svg(
                                      colorFilter: const ColorFilter.mode(
                                          ColorName.white, BlendMode.srcIn)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: ColorName.primary,
                                      backgroundImage:
                                          NetworkImage(widget.avatarUrl),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: Text(widget.userName,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.titleMedium
                                              .copyWith(
                                                  color: ColorName.primary)),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Assets.icons.menu.svg(),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    backgroundColor: ColorName.dark,
                  ),
                ),
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: ColorName.dark,
                        child: Hero(
                          tag: 'message_body',
                          transitionOnUserGestures: true,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Skeletonizer(
                              effect: CustomShimmerEffect.shimmerEffect,
                              ignoreContainers: true,
                              enabled: state.isLoading,
                              child: ListView.builder(
                                  controller: context
                                      .read<ConversationCubit>()
                                      .scrollController,
                                  shrinkWrap: true,
                                  reverse: true,
                                  physics: const BouncingScrollPhysics().applyTo(
                                      const AlwaysScrollableScrollPhysics()),
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 80),
                                  itemCount: state.messageList.length +
                                      (state.isFetchingMore ? 3 : 0),
                                  itemBuilder: (context, index) {
                                    if (index >= state.messageList.length) {
                                      return Skeletonizer(
                                        enabled: true,
                                        effect:
                                            CustomShimmerEffect.shimmerEffect,
                                        ignoreContainers: true,
                                        child: MessageCard(
                                          id: index,
                                          text: state.messages[0].content ?? '',
                                          time: '03:03',
                                          isSender: index % 2 == 0,
                                          attachment: null,
                                        ),
                                      );
                                    }

                                    // Group messages by date
                                    final message = state.messageList[index];
                                    final isSender =
                                        message.receiverId == widget.receiverId;

                                    // Determine if this is the first message of the day
                                    bool isFirstMessageOfTheDay = true;
                                    if (index < state.messageList.length - 1) {
                                      final currentDate = DateTime.parse(
                                          message.createdAt ?? '');
                                      final previousDate = DateTime.parse(state
                                              .messageList[index + 1]
                                              .createdAt ??
                                          '');
                                      isFirstMessageOfTheDay =
                                          currentDate.day != previousDate.day ||
                                              currentDate.month !=
                                                  previousDate.month ||
                                              currentDate.year !=
                                                  previousDate.year;
                                    }

                                    // Build message item with optional date header
                                    return Column(
                                      crossAxisAlignment: isSender
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        if (isFirstMessageOfTheDay)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Center(
                                              child: Text(
                                                FormatTimeUtils.getDayMonthYear(
                                                    message.createdAt ?? ''),
                                                style: context
                                                    .textTheme.labelMedium
                                                    .copyWith(
                                                        color:
                                                            ColorName.greyText),
                                              ),
                                            ),
                                          ),
                                        MessageCard(
                                          id: message.id ?? 0,
                                          text: message.content,
                                          time:
                                              FormatTimeUtils.getHourAndMinute(
                                                  message.createdAt ?? ''),
                                          attachment:
                                              message.attachments != null &&
                                                      message.attachments!
                                                          .isNotEmpty
                                                  ? message.attachments![0]
                                                  : null,
                                          isSender: isSender,
                                        ),
                                      ],
                                    );
                                  },
                                )

                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: SlideTransition(
                            position: slideBottomAnimation,
                            child: const MessageInput())),
                  ],
                ),
              ),
            ));
  }
}
