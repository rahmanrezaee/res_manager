import 'package:admin/modules/customers/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
//pacakges
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CommentItem extends StatelessWidget {
  final ReviewModel review;
  final name;
  final profile;
  CommentItem(this.review, this.name, this.profile);
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: FadeInImage.assetNetwork(
                  image: "$profile",
                  placeholder: "",
                ),
                title: Text(
                  "$name",
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${Jiffy(review.date).yMEd}"),
                    SizedBox(height: 5),
                    SmoothStarRating(
                      allowHalfRating: false,
                      onRated: (v) {},
                      starCount: review.rate.toInt(),
                      rating: 4,
                      size: 20.0,
                      isReadOnly: true,
                      color: Theme.of(context).primaryColor,
                      borderColor: Theme.of(context).primaryColor,
                      spacing: 0.0,
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "${review.message}",
                    style: TextStyle(height: 1.3),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
