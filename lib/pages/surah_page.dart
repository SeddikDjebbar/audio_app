import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../data/surah_list.dart';

class SurahPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = FlutterBackgroundService();

    return Scaffold(
      appBar: AppBar(title: Text("Sourates")),
      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];

          return ListTile(
            title: Text("${surah['id']} - ${surah['name']}"),
            onTap: () async {
              final service = FlutterBackgroundService();

              await service.startService(); // 🔥 IMPORTANT
              
              service.invoke("play", {"surah": surah['id']});

              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
