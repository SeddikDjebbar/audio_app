import 'dart:async';
import '../data/surah_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../services/audio_service_bg.dart'; // pour audioManager
import 'surah_page.dart';

class AudioPage extends StatefulWidget {
  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final service = FlutterBackgroundService();

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  String selectedReciter = "abdul_basit_murattal";
  int currentSurah = 1;
  String currentReciter = "abdul_basit_murattal";
  StreamSubscription? posSub;
  StreamSubscription? durSub;
  StreamSubscription? updateSub;

  @override
  void initState() {
    super.initState();
    print("AUDIO MANAGER INSTANCE: $audioManager");

    posSub = service.on("position").listen((event) {
      print("POSITION: ${event?["position"]}");
      setState(() {
        position = Duration(seconds: event?["position"] ?? 0);
      });
    });

    durSub = service.on("duration").listen((event) {
      setState(() {
        duration = Duration(seconds: event?["duration"] ?? 0);
      });
    });
    updateSub = service.on("update").listen((event) {
      setState(() {
        currentSurah = event?["surah"] ?? currentSurah;
        currentReciter = event?["reciter"] ?? currentReciter;
      });
    });
  }

  String getSurahName(int id) {
    final surah = surahs.firstWhere(
      (s) => s["id"] == id,
      orElse: () => {"name": "Unknown"},
    );
    return surah["name"];
  }

  @override
  void dispose() {
    updateSub?.cancel();
    posSub?.cancel();
    durSub?.cancel();
    super.dispose();
  }

  String format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  String getReciterName(String reciter) {
    switch (reciter) {
      case "abdul_basit_murattal":
        return "Abdul Baset";
      case "mahmood_khaleel_al-husaree":
        return "Al-Husary";
      case "mishary_rashid_alafasy":
        return "Mishary Alafasy";
      case "ali_jaber":
        return "Ali Jaber";
      default:
        return reciter;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quran Player")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 100),

            SizedBox(height: 20),

            // 🔥 ouvrir liste sourates
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SurahPage()),
                );
              },
              child: Text("Choisir Sourate"),
            ),

            SizedBox(height: 20),
            Text(
              getSurahName(currentSurah),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // 🔥 choix réciteur
            DropdownButton<String>(
              value: selectedReciter,
              items: [
                DropdownMenuItem(
                  value: "abdul_basit_murattal",
                  child: Text("Abdul Baset"),
                ),
                DropdownMenuItem(
                  value: "mahmood_khaleel_al-husaree",
                  child: Text("Al-Husary"),
                ),
                DropdownMenuItem(value: "ali_jaber", child: Text("Ali Jaber")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedReciter = value);
                  service.invoke("reciter", {"reciter": value});
                }
              },
            ),

            SizedBox(height: 20),

            // 🔥 BARRE PROGRESSION
            Slider(
              min: 0,
              max: duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1,
              value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
              onChanged: (value) {
                audioManager.seek(Duration(seconds: value.toInt()));
              },
            ),

            // 🔥 TEMPS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(format(position)), Text(format(duration))],
            ),

            SizedBox(height: 20),

            // 🔥 CONTROLS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: () {
                    service.invoke("previous");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {
                    service.invoke("resume");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.pause),
                  onPressed: () {
                    service.invoke("pause");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: () {
                    service.invoke("stop");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: () {
                    service.invoke("next");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
