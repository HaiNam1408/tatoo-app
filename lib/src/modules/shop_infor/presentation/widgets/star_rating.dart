import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../../generated/assets.gen.dart';

class StarRating extends StatefulWidget {
  const StarRating({super.key, required this.onRating});
  final Function (double rating) onRating;

  @override
  StarRatingState createState() => StarRatingState();
}

class StarRatingState extends State<StarRating> {
  double _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemBuilder: (context, index) {
        return _currentRating >= index + 1
            ? Assets.icons.starFilled.svg()
            : Assets.icons.starOutline.svg();
      },
      onRatingUpdate: (rating) {
        setState(() {
          _currentRating = rating;
        });
        widget.onRating(rating);
      },
      initialRating: _currentRating, 
      itemCount: 5,
      itemSize: 32,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
    );
  }
}
