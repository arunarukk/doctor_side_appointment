import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:doc_side_appoinment/models/doc_appointment.dart';
import 'package:doc_side_appoinment/resources/data_methods.dart';
import 'package:doc_side_appoinment/screens/review_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GetBuilder<DataController>(
        id: 'past',
        init: DataController(),
        builder: (pastcontrol) {
          return FutureBuilder<List<DoctorAppointment>>(
              future: pastcontrol.getPastApp(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                //else if (!snapshot.hasData) {
                //   return Center(
                //     child: Text('No data'),
                //   );
                // }
                // print(snapshot.data);
                return snapshot.data == null
                    ? Center(
                        child: Text('No data'),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        itemBuilder: (ctx, index) {
                          final data = snapshot.data![index];
                          final photo = data.appoDetails.photoUrl;
                          final name = data.appoDetails.name;
                          final phone = data.appoDetails.phoneNumber;
                          final age = data.appoDetails.age;
                          final gender = data.appoDetails.gender;
                          final review = data.appoDetails.review;
                          final rating = data.appoDetails.rating;

                          //print(rating);

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
                                            builder: (context) =>
                                                ReviewDetailScreen(data: data,)));
                                  },
                                  leading: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(photo),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(name.capitalize!),
                                        kHeight10,
                                        Text(
                                          review,
                                          overflow: TextOverflow.fade,
                                        ),
                                        kHeight10,
                                        RatingBar.builder(
                                          itemSize: 20,
                                          initialRating: rating,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          // itemPadding: EdgeInsets.symmetric(
                                          //     horizontal: 1.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
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
                        itemCount: snapshot.data!.length);
              });
        },
      ),
    );
  }
}
