import 'staff.dart';

abstract class Appointment {
  int get id;
  String get time_start;
  String get time_end;
  String get title;
  String get content;
  bool get is_important;
  int get price;
  int get deposit;
  String get name_customer;
  String get phone;
  bool get is_done;
  int get authId;
  int get image_id;
  bool get is_delete;
  DateTime get create_at;
  DateTime get update_at;
  Staff get staff;
}
