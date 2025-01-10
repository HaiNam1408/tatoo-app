import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

Future<List<MultipartFile>> imageToMultiPart(File image) async {
  final multipartFiles = <MultipartFile>[];

  final fileBytes = await image.readAsBytes();
  final multipartFile = MultipartFile.fromBytes(
    fileBytes,
    filename: image.path.split('/').last,
    contentType: MediaType('image', '*'),
  );
  multipartFiles.add(multipartFile);
  return multipartFiles;
}