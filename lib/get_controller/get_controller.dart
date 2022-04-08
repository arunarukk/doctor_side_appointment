import 'package:doc_side_appoinment/models/doctor_model.dart';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:get/get.dart';

class StateController extends GetxController {
  Doctor? user;

  final AuthMethods _authMethods = AuthMethods();

 // Doctor get getUser => _user!;

  Future<void> refreshUser() async {
    Doctor _user = await _authMethods.getUserDetails();
    user = _user;
    update();
  }

  
}
