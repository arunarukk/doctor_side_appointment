import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String email;
  final String uid;
  final String photoUrl;
  final String userName;
  final String phoneNumber;
  final String speciality;

  const Doctor({
    required this.userName,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.phoneNumber,
    required this.speciality,
  });

  // static Doctor fromSnap(DocumentSnapshot snap) {
  //   var snapshot = snap.data() as Map<String, dynamic>;

  //   return Doctor(
  //     userName: snapshot["userName"],
  //     uid: snapshot["uid"],
  //     email: snapshot["email"],
  //     photoUrl: snapshot["photoUrl"],
  //     phoneNumber: snapshot["phoneNumber"],
  //     speciality: snapshot["speciality"],
  //   );
  // }

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "phoneNumber": phoneNumber,
        "speciality": speciality,
      };

  static Doctor fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Doctor(
      userName: snap['userName'],
      uid: snap['uid'],
      photoUrl: snap['photoUrl'],
      email: snap['email'],
      phoneNumber: snap['phoneNumber'],
      speciality: snap['speciality'],
    );
  }
}
