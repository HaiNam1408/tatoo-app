import 'package:flutter/material.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/tag_custom.dart';
import '../../../../core/infrastructure/models/profile.dart';

class SearchShopCard extends StatelessWidget {
  final ProfileModel profile;

  const SearchShopCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(profile.avatar?.filePath ?? ''),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.storeName ?? '',
                    style: context.textTheme.bold
                        .copyWith(fontSize: 14, color: ColorName.dark),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Assets.icons.location.svg(height: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${profile.address?.street}, ${profile.address?.city}}',
                        style: context.textTheme.regular
                            .copyWith(fontSize: 12, color: ColorName.dark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 26,
                    child: ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: profile.profileTag?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TagCustom(
                            text: profile.profileTag?[index].tags.name ?? '',
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
