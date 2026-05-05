import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'audio_manager.dart';

final AudioManager audioManager = AudioManager();

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
    ),
    iosConfiguration: IosConfiguration(),
  );
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  print("SERVICE STARTED");

  print("SERVICE AUDIO MANAGER: $audioManager");
  audioManager.positionStream.listen((pos) {
    service.invoke("position", {"position": pos.inSeconds});
  });

  audioManager.durationStream.listen((dur) {
    if (dur != null) {
      service.invoke("duration", {"duration": dur.inSeconds});
    }
  });
  // 🔥 NOTIFICATION FOREGROUND (OBLIGATOIRE)
  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Quran Player",
      content: "En attente...",
    );
  }

  // 🔥 PLAY
  service.on("play").listen((event) async {
    print("PLAY EVENT RECEIVED");

    final surah = event?["surah"] ?? 1;
    await audioManager.playSurah(surah);

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Sourate $surah",
        content: audioManager.getReciterName(),
      );
    }
    service.invoke("update", {
      "surah": audioManager.currentSurah,
      "reciter": audioManager.reciter,
    });
  });

  // 🔥 PAUSE
  service.on("pause").listen((event) async {
    print("PAUSE EVENT RECEIVED");
    await audioManager.pause();
  });

  // 🔥 RESUME
  service.on("resume").listen((event) async {
    print("RESUME EVENT RECEIVED");
    await audioManager.play();
  });

  // 🔥 NEXT
  service.on("next").listen((event) async {
    print("NEXT EVENT RECEIVED");

    await audioManager.skipToNext();

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Sourate ${audioManager.currentSurah}",
        content: audioManager.getReciterName(),
      );
    }

    // ✅ SYNCHRO UI
    service.invoke("update", {
      "surah": audioManager.currentSurah,
      "reciter": audioManager.reciter,
    });
  });

  // 🔥 PREVIOUS
  service.on("previous").listen((event) async {
    print("PREVIOUS EVENT RECEIVED");

    await audioManager.skipToPrevious();

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Sourate ${audioManager.currentSurah}",
        content: audioManager.getReciterName(),
      );
    }

    // ✅ SYNCHRO UI
    service.invoke("update", {
      "surah": audioManager.currentSurah,
      "reciter": audioManager.reciter,
    });
  });

  // 🔥 RECITER
  service.on("reciter").listen((event) async {
    print("RECITER EVENT RECEIVED");

    final newReciter = event?["reciter"];
    if (newReciter != null) {
      await audioManager.changeReciter(newReciter);

      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Sourate ${audioManager.currentSurah}",
          content: audioManager.getReciterName(),
        );
      }
    }
    service.invoke("update", {
      "surah": audioManager.currentSurah,
      "reciter": audioManager.reciter,
    });
  });

  // 🔥 STOP
  service.on("stop").listen((event) async {
    print("STOP EVENT RECEIVED");
    await audioManager.stop();
    service.stopSelf();
  });
}
