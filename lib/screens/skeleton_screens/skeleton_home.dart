import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonHome extends StatelessWidget {
  const SkeletonHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        decoration: const BoxDecoration(color: Colors.white),
        child: SkeletonItem(
            child: Column(
          children: [
            Row(
              children: [
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      shape: BoxShape.rectangle,
                      width: 26.w,
                      height: 14.h,
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(15))),
                ),
                SizedBox(width: 1.h),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                                lines: 1,
                                spacing: 25,
                                lineStyle: SkeletonLineStyle(
                                  randomLength: true,
                                  height: 2.h,
                                  borderRadius: const BorderRadius.vertical(),
                                  minLength: 23.w,
                                  maxLength: 24.w,
                                )),
                          ),
                          SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                                lines: 1,
                                spacing: 25,
                                lineStyle: SkeletonLineStyle(
                                  randomLength: true,
                                  height: 3.h,
                                  borderRadius: BorderRadius.circular(8),
                                  minLength: 20.w,
                                  maxLength: 21.w,
                                )),
                          ),
                        ],
                      ),
                      SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 25,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 1.6.h,
                              borderRadius: BorderRadius.circular(8),
                              minLength: 20.w,
                              maxLength: 21.w,
                            )),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                                lines: 1,
                                spacing: 25,
                                lineStyle: SkeletonLineStyle(
                                  randomLength: true,
                                  height: 3.h,
                                  borderRadius: BorderRadius.circular(8),
                                  minLength: 24.w,
                                  maxLength: 25.w,
                                )),
                          ),
                          SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                                lines: 1,
                                spacing: 25,
                                lineStyle: SkeletonLineStyle(
                                  randomLength: true,
                                  height: 3.h,
                                  borderRadius: BorderRadius.circular(8),
                                  minLength: 18.w,
                                  maxLength: 19.w,
                                )),
                          ),
                        ],
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
