import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'surah_page.dart';

class AudioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = FlutterBackgroundService();

    return Scaffold(
      appBar: AppBar(title: Text("Quran Player")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book, size: 100),

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

          // 🔥 choix réciteur
          DropdownButton<String>(
            value: "abdul_basit_murattal",
            items: [
              DropdownMenuItem(
                value: "abdul_basit_murattal",
                child: Text("Abdul Baset"),
              ),
              DropdownMenuItem(value: "husary", child: Text("Al-Husary")),
              DropdownMenuItem(value: "ali_jaber", child: Text("Ali Jaber")),
            ],
            onChanged: (value) {
              if (value != null) {
                service.invoke("reciter", {"reciter": value});
              }
            },
          ),

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
    );
  }
}
