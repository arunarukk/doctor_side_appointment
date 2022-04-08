import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:flutter/material.dart';

class ReviewDetailScreen extends StatelessWidget {
  const ReviewDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Doctor;
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        title: Text(
          'Patient profile',
          style: TextStyle(color: kBlack),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: kBlack,
            )),
        //automaticallyImplyLeading: true,
      ),
      body: Container(
        // decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //         colors: [
        //       Color.fromARGB(255, 0, 162, 255),
        //       Color.fromARGB(255, 60, 39, 176)
        //     ])),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                child: Column(
                  children: [
                    // Hero(
                    //   tag: 'assets/lukman.jpeg',
                    //   child: Material(
                    //       type: MaterialType.transparency,
                    //       child: Container(
                    //         alignment: Alignment.topCenter,
                    //         height: size * .5,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.only(
                    //               bottomLeft: Radius.circular(50),
                    //               bottomRight: Radius.circular(50)),
                    //           color: kGrey,
                    //           image: DecorationImage(
                    //             fit: BoxFit.cover,
                    //             image: AssetImage(
                    //               'assets/lukman.jpeg',
                    //             ),
                    //           ),
                    //         ),
                    //       )),
                    // ),
                    SizedBox(
                      height: size * .5,
                      child: Container(
                        height: size * .2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50)),
                          color: kGrey,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/lukman.jpeg',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //color: Colors.grey,
                      padding: const EdgeInsets.all(16),
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          kHeight30,
                          kHeight10,
                          Text('Rating & Feedbacks',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          kHeight20,
                          Text("⭐⭐⭐⭐⭐", style: TextStyle(fontSize: 20)),
                          kHeight10,
                          Divider(
                            thickness: 1.0,
                            color: kBlack,
                          ),
                          kHeight10,
                          Text(
                              'Dr name •  is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries ',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(
                            height: 16,
                          ),
                          // kHeight10,
                          Divider(
                            thickness: 1.0,
                            color: kBlack,
                          ),
                          //const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: size * .45,
                left: 75,
                child: Container(
                  // color: kGrey,
                  height: size * 0.1,
                  width: size * 0.3,
                  decoration: BoxDecoration(
                    color: kBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kWhite),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text('Age',
                          style: TextStyle(fontSize: 16, color: kWhite)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
