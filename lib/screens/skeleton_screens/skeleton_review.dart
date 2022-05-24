import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonReview extends StatelessWidget {
  const SkeletonReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        decoration: BoxDecoration(color: Colors.white),
        child: SkeletonItem(
            child: Column(
          children: [
            Row(
              children: [
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      shape: BoxShape.rectangle,
                      width: size * .13,
                      height: size * .13,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 25,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 10,
                              borderRadius: BorderRadius.circular(8),
                              minLength: size / 9,
                              maxLength: size / 8,
                            )),
                      ),
                      SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 25,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 10,
                              borderRadius: BorderRadius.circular(8),
                              minLength: size / 11,
                              maxLength: size / 10,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 25,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 22,
                              borderRadius: BorderRadius.circular(8),
                              minLength: size / 7,
                              maxLength: size / 6,
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        )),
      ),
    );
  }
}
