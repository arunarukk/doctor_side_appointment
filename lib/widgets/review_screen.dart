import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:doc_side_appoinment/screens/review_details.dart';
import 'package:doc_side_appoinment/widgets/appbar_wiget.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          itemBuilder: (ctx, index) {
            return Card(
              color: kWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SizedBox(
                height: 100,
                child: Center(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReviewDetailScreen()));
                    },
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/lukman.jpeg'),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name'),
                          kHeight10,
                          Text('Feedback'),
                          kHeight10,
                          Text('⭐⭐⭐⭐⭐')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              height: 5,
            );
          },
          itemCount: 10),
    );
  }
}
