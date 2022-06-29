import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_side_appoinment/resources/data_methods.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String patientId;

   const MessageTextField(this.currentId, this.patientId, {Key? key}) : super(key: key);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
 final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 235, 231, 231),
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                labelText: "Type your Message",
                fillColor: const Color.fromARGB(255, 235, 231, 231),
                filled: true,
                border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(50))),
          )),
          SizedBox(
            width: 2.w,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentId)
                  .collection('messages')
                  .doc(widget.patientId)
                  .collection('chats')
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.patientId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.currentId)
                    .collection('messages')
                    .doc(widget.patientId)
                    .set({
                  'last_msg': message,
                });
              });

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.patientId)
                  .collection('messages')
                  .doc(widget.currentId)
                  .collection("chats")
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.patientId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.patientId)
                    .collection('messages')
                    .doc(widget.currentId)
                    .set({"last_msg": message});
              });
              dataController.patientDetails(patientId: widget.patientId);
              //notifyC.sendPushMessage('You have a new message', 'title', fcmToken)
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
