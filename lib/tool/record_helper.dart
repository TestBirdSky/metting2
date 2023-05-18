import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class RecordHelper {
  static Future<void> startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/recording.mp3');

    final sound = FlutterSoundRecorder();
    await sound.startRecorder(toFile: file.path);
  }

  static Future<void> stopRecording() async {
    final sound = FlutterSoundRecorder();
    await sound.stopRecorder();
  }

  static Future<Duration?> playRecording(String uri) async {
    return FlutterSoundPlayer().startPlayer(fromURI: uri, codec: Codec.mp3);
  }
}
