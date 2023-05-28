import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:metting/tool/log.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordAudioHelper {
  final _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInit = false;
  int recorderTime = 0;
  int _startRecorderTimeMill = 0;
  File? recordAudioFile;

  bool isHaveRecordFile() {
    return recorderTime > 0 && recordAudioFile != null;
  }

  Future<void> startRecorder({String? path}) async {
    if (!_mRecorderIsInit) await _openTheRecorder();
    path ??= "${DateTime.now().millisecondsSinceEpoch}.mp4";
    deleteFile2(recordAudioFile);
    recorderTime = 0;
    _startRecorderTimeMill = DateTime.now().millisecondsSinceEpoch;
    await _mRecorder.startRecorder(toFile: path, codec: Codec.aacMP4);
  }

  Future<void> _openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return;
    }
    await _mRecorder.openRecorder();
    _mRecorderIsInit = true;
  }

  Future<void> destroy() async {
    _mRecorder.closeRecorder();
    recorderTime = 0;
    _startRecorderTimeMill = 0;
    deleteFile2(recordAudioFile);
    recordAudioFile = null;
  }

  Future<String?> stopRecording() async {
    return _mRecorder.stopRecorder();
  }

  Future<File?> stopRecording1() async {
    final s = await stopRecording();
    if (s != null) {
      recordAudioFile = File(s);
      recorderTime =
          (DateTime.now().millisecondsSinceEpoch - _startRecorderTimeMill) ~/
                  1000;
      logger.i('stopRecording1$s --$recorderTime --${_startRecorderTimeMill}');
      return recordAudioFile;
    }
    recorderTime = 0;
    return null;
  }

  // static Future<File> startRecording() async {
  //   final dir = await getTemporaryDirectory();
  //   final file = File('${dir.path}/recording.mp3');
  //
  //   final sound = FlutterSoundRecorder();
  //   sound.openRecorder();
  //   await sound.startRecorder(toFile: file.path);
  //   return file;
  // }
  //
  // static Future<String?> stopRecording() async {
  //   final sound = FlutterSoundRecorder();
  //   await sound.stopRecorder();
  // }

  void deleteFile(String path) {
    File file = File(path);
    file.exists().then((value) => {if (value) file.delete()});
  }

  void deleteFile2(File? file) {
    file?.exists().then((value) => {if (value) file.delete()});
  }
}
