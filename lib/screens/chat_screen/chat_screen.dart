import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/chat_widgets/message_textfield.dart';
import '../../widgets/chat_widgets/single_message.dart';

class ChatScreen extends StatelessWidget {
  final String patientId;
  final String patientName;
  final String patientImage;

  ChatScreen({Key? key, 
    required this.patientId,
    required this.patientName,
    required this.patientImage,
  }) : super(key: key);

  User currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlue,
        title: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: Image.network(
                  patientImage,
                  width: 12.w,
                  height: 6.h,
                  fit: BoxFit.cover,
                )),
            SizedBox(
              width: 5.w,
            ),
            SizedBox(
              width: 60.w,
              child: Text(
                patientName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 235, 231, 231),
             ),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser.uid)
                    .collection('messages')
                    .doc(patientId)
                    .collection('chats')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                 // debugPrint(snapshot.data);
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return const Center(
                        child: Text(
                          "Say Hi",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isMe = snapshot.data.docs[index]['senderId'] ==
                              currentUser.uid;
                          return SingleMessage(
                              message: snapshot.data.docs[index]['message'],
                              isMe: isMe);
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          )),
          MessageTextField(currentUser.uid, patientId),
        ],
      ),
    );
  }
}
