import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../main.dart'; // pour audioHandler
class AudioPage extends StatefulWidget {
  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // 🔥 mettre un audio (exemple internet)
    player.setUrl(
      "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    );
  }

  void play() {
  audioHandler.play();
  }

  void pause() {
  audioHandler.pause(); 
  }

  void stop() {
    audioHandler.stop();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Audio Player")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 100),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.play_arrow, size: 40),
                onPressed: play,
              ),
              IconButton(icon: Icon(Icons.pause, size: 40), onPressed: pause),
              IconButton(icon: Icon(Icons.stop, size: 40), onPressed: stop),
            ],
          ),
        ],
      ),
    );
  }
}
