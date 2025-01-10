import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/infrastructure/models/post.dart';
import '../../application/post_detail_cubit.dart';
import '../widgets/post_detail_body.dart';

@RoutePage()
class PostDetailPage extends StatelessWidget {
  final PostModel? post;
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostDetailCubit>(
      create: (context) => PostDetailCubit(),
      child: Scaffold(
        body: PostDetailBody(post: post),
      ),
    );
  }
}
