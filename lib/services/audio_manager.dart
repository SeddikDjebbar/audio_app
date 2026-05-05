import 'dart:developer';
import 'package:just_audio/just_audio.dart';

class AudioManager {
  final AudioPlayer _player = AudioPlayer();

  int currentSurah = 1;
  String reciter = "abdul_basit_murattal";

  // 🔥 nom réciteur
  String getReciterName() {
    switch (reciter) {
      case "abdul_basit_murattal":
        return "Abdul Baset";
      case "husary":
        return "Al-Husary";
      case "ali_jaber":
        return "Ali Jaber";
      default:
        return reciter;
    }
  }

  // 🔥 URL
  String getSurahUrl(int surah) {
    String s = surah.toString().padLeft(3, '0');
    return "https://download.quranicaudio.com/quran/$reciter/$s.mp3";
  }

  // 🔥 PLAY SURAH
  Future<void> playSurah(int surah) async {
    print("PLAY SURAH: $surah");
    currentSurah = surah;

    try {
      await _player.stop();
      await _player.setUrl(getSurahUrl(currentSurah));
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (e) {
      log("Erreur audio: $e");
    }
  }

  // 🔥 CONTROLS
  Future<void> play() async => _player.play();

  Future<void> pause() async {
    print("PAUSE CLICKED");
    await _player.pause();
  }

  Future<void> stop() async => _player.stop();

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  // 🔥 STREAMS
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  // 🔥 CHANGE RECITER
  Future<void> changeReciter(String newReciter) async {
    reciter = newReciter;
    await playSurah(currentSurah);
  }

  // 🔥 NEXT / PREVIOUS
  Future<void> skipToNext() async {
    currentSurah++;
    if (currentSurah > 114) currentSurah = 1;
    await playSurah(currentSurah);
  }

  Future<void> skipToPrevious() async {
    currentSurah--;
    if (currentSurah < 1) currentSurah = 114;
    await playSurah(currentSurah);
  }
}
