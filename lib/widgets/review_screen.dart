import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:doc_side_appoinment/models/doc_appointment.dart';
import 'package:doc_side_appoinment/resources/data_methods.dart';
import 'package:doc_side_appoinment/screens/review_details.dart';
import 'package:doc_side_appoinment/screens/skeleton_screens/skeleton_review.dart';
import 'package:doc_side_appoinment/widgets/connection_lost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasData && snapshot.data != ConnectivityResult.none) {
              return GetBuilder<DataController>(
                id: 'past',
                init: DataController(),
                builder: (pastcontrol) {
                  return FutureBuilder<List<DoctorAppointment>>(
                      future: pastcontrol.pastRefresh(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SkeletonReview();
                        }
                        if (snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/no appointment.png',
                                  scale: .8,
                                ),
                                const Text('No appointments'),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            controller: scrollController,
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            itemBuilder: (ctx, index) {
                              final data = snapshot.data![index];
                              final photo = data.appoDetails.photoUrl;
                              final name = data.appoDetails.name;
                              final review = data.appoDetails.review;
                              final rating = data.appoDetails.rating;

                              return Card(
                                elevation: 0,
                                color: Colors.grey.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: SizedBox(
                                  height: size * .14,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReviewDetailScreen(
                                                      data: data,
                                                    )));
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius
                                                      .horizontal(
                                                  left: Radius.circular(15.0),
                                                  right: Radius.circular(15.0)),
                                              child: SizedBox(
                                                width: size * .12,
                                                child: FittedBox(
                                                    fit: BoxFit.cover,
                                                    child:
                                                        Image.network(photo)),
                                                height: size * .12,
                                              ),
                                            ),
                                          ),
                                          kWidth20,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: size * .25,
                                                    child: Text(
                                                      name.capitalize!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: kBlue),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Discription : ',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kBlue),
                                                  ),
                                                  SizedBox(
                                                    width: size * .17,
                                                    child: Text(
                                                      review,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: kBlue),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              RatingBar.builder(
                                                itemSize: 20,
                                                initialRating: rating,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                itemCount: 5,
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {},
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
                            separatorBuilder: (ctx, index) {
                              return SizedBox(
                                height: 1.h,
                              );
                            },
                            itemCount: snapshot.data!.length);
                      });
                },
              );
            } else {
              return const ConnectionLost();
            }
          }),
    );
  }
}
