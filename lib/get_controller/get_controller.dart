import 'package:doc_side_appoinment/models/doctor_model.dart';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:get/get.dart';

final stateControl = Get.put(StateController());

class StateController extends GetxController {
  Doctor? user;
  dynamic dropvalue;
  DateTime? selectedDate;

  bool nine = false;
  bool ten = false;
  bool eleven = false;
  bool twel = false;
  bool one = false;
  bool two = false;
  bool three = false;
  bool four = false;
  bool five = false;
  bool six = false;

  Future<void> checkvar() async {
    print(six);
  }

  final AuthMethods _authMethods = AuthMethods();

  // Doctor get getUser => _user!;

  Future<void> refreshUser() async {
    Doctor _user = await _authMethods.getUserDetails();
    user = _user;
    update();
  }

  void dropDownChange(String newValue) {
    dropvalue = newValue;
    update();
  }

  @override
  void onInit() {
    refreshUser();
    // TODO: implement onInit
    super.onInit();
  }
}
