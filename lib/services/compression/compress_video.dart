import 'dart:io';

import 'package:video_compress/video_compress.dart';

Future<File> compressVideo(String path) async {
  final compressedVideo = await VideoCompress.compressVideo(path,
      quality: VideoQuality.MediumQuality);
  return compressedVideo!.file!;
}

Future<File> getThumbNail(String videoPath) async {
  final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
  return thumbnail;
}
