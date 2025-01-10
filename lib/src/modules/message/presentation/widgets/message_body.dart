import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/extensions/shimmer_effect.dart';
import '../../../../common/utils/format_time_utils.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../../core/infrastructure/models/profile.dart';
import '../../../app/app_router.dart';
import '../../../tabbar/application/tabbar_cubit.dart';
import '../../application/message_cubit.dart';
import '../../application/message_state.dart';
import 'message_item.dart';

class MessageBody extends StatefulWidget {
  const MessageBody({super.key});

  @override
  State<MessageBody> createState() => _MessageBodyState();
}

class _MessageBodyState extends State<MessageBody>
    with TickerProviderStateMixin {
  late final AnimationController enterAnimationController;
  late final Animation<Offset> slideTopAnimation;
  late final Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();

    enterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    slideTopAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: enterAnimationController,
      curve: Curves.easeInOut,
    ));

    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: enterAnimationController,
        curve: Curves.linear,
      ),
    );

    enterAnimationController.forward();
  }

  @override
  void dispose() {
    enterAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageCubit, MessageState>(
      builder: (context, state) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(132),
          child: AppBar(
            backgroundColor: ColorName.dark,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: Center(
              child: SlideTransition(
                position: slideTopAnimation,
                child: FadeTransition(
                  opacity: opacityAnimation,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 40, bottom: 8),
                          child: Text(
                            // TODO: localize
                            'Tin nhắn',
                            style: context.textTheme.bold.copyWith(
                                fontSize: 24, color: ColorName.primary),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            height: 48,
                            child: TextField(
                              onChanged: (value) => context
                                  .read<MessageCubit>()
                                  .changeSearchMessage(value),
                              controller:
                                  context.read<MessageCubit>().searchController,
                              style: const TextStyle(
                                  color: ColorName.dark, fontSize: 18),
                              decoration: InputDecoration(
                                // TODO: localize
                                hintText: 'Nhập tìm kiếm',
                                hintStyle: context.textTheme.regular
                                    .copyWith(color: ColorName.greyText),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Assets.icons.searchOutline.svg(
                                      colorFilter: const ColorFilter.mode(
                                          ColorName.greyText, BlendMode.srcIn)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                  child: DefaultTextStyle(
                    style: context.textTheme.regular,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: RefreshIndicator(
                        color: ColorName.dark,
                        onRefresh: () async {
                          context
                              .read<MessageCubit>()
                              .handleGetConversationList(1, 10);
                        },
                        child: ListView.builder(
                          controller:
                              context.read<MessageCubit>().scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                          physics: const BouncingScrollPhysics()
                              .applyTo(const AlwaysScrollableScrollPhysics()),
                          itemCount: state.conversationList.length +
                              (state.isFetchingMore ? 5 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.conversationList.length) {
                              return Skeletonizer(
                                enabled: true,
                                effect: CustomShimmerEffect.shimmerEffect,
                                child: MessageItem(
                                  title: state.conversationList[0].userId1
                                          ?.fullname ??
                                      '',
                                  subtitle: state.conversationList[0].message
                                          ?.content ??
                                      '',
                                  avatarUrl: state.conversationList[0].userId1
                                          ?.avatar?.filePath ??
                                      '',
                                  time: 'Vừa mới',
                                ),
                              );
                            }
                            final conversation = state.conversationList[index];
                            ProfileModel? receiverUser =
                                conversation.receiverId ==
                                        conversation.userId1?.id
                                    ? conversation.userId1
                                    : conversation.userId2;
                            String receiverName = receiverUser?.fullname ??
                                receiverUser?.storeName ??
                                '';
                            String? subtitle = conversation.message?.content;
                            subtitle ??=
                                '${receiverUser?.id != conversation.message?.receiverId ? receiverName.split(' ').first : 'Bạn'} đã gửi 1 file đính kèm';
                            if (subtitle == '') {
                              subtitle =
                                  '${receiverUser?.id != conversation.message?.receiverId ? receiverName.split(' ').first : 'Bạn'} đã thu hồi 1 tin nhắn';
                            }
                            return Skeletonizer(
                              effect: CustomShimmerEffect.shimmerEffect,
                              enabled: state.isLoading,
                              child: GestureDetector(
                                onTap: () async {
                                  enterAnimationController.reverse();
                                  getIt<TabbarCubit>().animateTabbar(
                                      animetionTime: 300, bottomPadding: -80);
                                  await Future.delayed(
                                      const Duration(milliseconds: 250));
                                  context.router
                                      .push(ConversationRoute(
                                    key: UniqueKey(),
                                    userName: receiverName,
                                    avatarUrl:
                                        receiverUser?.avatar?.filePath ?? '',
                                    receiverId: conversation.receiverId ?? 0,
                                  ))
                                      .then((value) {
                                    enterAnimationController.reset();
                                    enterAnimationController.forward();
                                    getIt<TabbarCubit>().animateTabbar(
                                        animetionTime: 800, bottomPadding: 24);
                                  });
                                },
                                child: MessageItem(
                                  title: receiverName,
                                  subtitle: subtitle,
                                  avatarUrl:
                                      receiverUser?.avatar?.filePath ?? '',
                                  time: FormatTimeUtils.timeAgo(DateTime.parse(
                                      conversation.message?.createdAt ?? '')),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
