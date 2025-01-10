import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'dart:ui';

import '../../../../core/infrastructure/models/post.dart';
import '../../application/post_detail_cubit.dart';
import '../../application/post_detail_state.dart';

class PostDetailBody extends StatelessWidget {
  final PostModel? post;
  const PostDetailBody({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailCubit, PostDetail>(
      builder: (context, state) {
        return postDetailPage(context, state);
      },
    );
  }

  Widget postDetailPage(BuildContext context, PostDetail state) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: NetworkImage(post?.postImage?.filePath ?? ''),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BlocBuilder<PostDetailCubit, PostDetail>(
              builder: (context, state) {
                return ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post?.content ?? '',
                              maxLines: state.isToggleReadMore ? null : 3,
                              overflow: state.isToggleReadMore
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Gap(24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '14 Th10, 23',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => context
                                      .read<PostDetailCubit>()
                                      .readMore(),
                                  child: Text(
                                    state.isToggleReadMore ? 'Ẩn' : 'Xem thêm',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
