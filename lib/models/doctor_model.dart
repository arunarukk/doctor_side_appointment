import 'dart:convert';


class Doctor {
  final String email;
  final String uid;
  final String photoUrl;
  final String userName;
  final String phoneNumber;
  final Map<String, dynamic> speciality;
  final String about;
  final String experience;
  final double rating;
  final int patients;
  final String qualifications;
  final String address;

  const Doctor({
    required this.userName,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.phoneNumber,
    required this.speciality,
    required this.about,
    required this.experience,
    required this.rating,
    required this.patients,
    required this.qualifications,
    required this.address,
  });

 
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uid': uid,
      'photoUrl': photoUrl,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'speciality': speciality,
      'about': about,
      'experience': experience,
      'rating': rating,
      'patients': patients,
      'qualifications': qualifications,
      'address': address,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      userName: map['userName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      speciality: Map<String, dynamic>.from(map['speciality']),
      about: map['about'] ?? '',
      experience: map['experience'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      patients: map['patients']?.toInt() ?? 0,
      qualifications: map['qualifications'] ?? '',
      address: map['address'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Doctor.fromJson(String source) => Doctor.fromMap(json.decode(source));
}
