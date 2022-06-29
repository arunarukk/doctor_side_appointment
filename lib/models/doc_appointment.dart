

import 'package:doc_side_appoinment/models/patients_model.dart';

import 'appointment_model.dart';


class DoctorAppointment {
  final Patients  patientDetails;
  final Appointment appoDetails;
  DoctorAppointment({
    required this.patientDetails,
    required this.appoDetails,
  });
}
