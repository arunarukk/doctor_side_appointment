import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonName extends StatelessWidget {
  const SkeletonName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SkeletonAvatar(
          style: SkeletonAvatarStyle(
              shape: BoxShape.rectangle,
              width: 18.w,
              height: 9.h,
              borderRadius: BorderRadius.circular(50)),
        ),
        SizedBox(
          width: 2.w,
        ),
        SkeletonParagraph(
          style: SkeletonParagraphStyle(
              lines: 1,
              spacing: 25,
              lineStyle: SkeletonLineStyle(
                randomLength: true,
                height: 4.h,
                borderRadius:const BorderRadius.vertical(),
                minLength: 34.w,
                maxLength: 35.w,
              )),
        ),
      ],
    ));
  }
}
