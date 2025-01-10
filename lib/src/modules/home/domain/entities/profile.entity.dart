// Abstract class representing a Profile
import '../../../../core/infrastructure/models/attachment.dart';

abstract class ProfileModel {
  String get fullname;
  String get storeName;
  String get phone;
  double get averageRating;
  Attachment get avatar;
  Attachment get background;

}

class Avatar {
  final String fileName;
  final String filePath;
  final String type;

  Avatar({required this.fileName, required this.filePath, required this.type});
}


class Background {
  final String fileName;
  final String filePath;
  final String type;

  Background({required this.fileName, required this.filePath, required this.type});
}


class Address {
  final int id;
  final String city;
  final String street;

  Address({required this.id, required this.city, required this.street});
}


class Post {
  final int id;
  final String content;
  final PostImage postImage;

  Post({required this.id, required this.content, required this.postImage});
}

class PostImage {
  final String fileName;
  final String filePath;
  final String type;

  PostImage({required this.fileName, required this.filePath, required this.type});
}



