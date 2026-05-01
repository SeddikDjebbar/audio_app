import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    await _player.setUrl(
      "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    );

    // 🔥 IMPORTANT : metadata
    mediaItem.add(MediaItem(id: "1", title: "Music Demo", artist: "Audio App"));

    // 🔥 état dynamique
    _player.playerStateStream.listen((state) {
      playbackState.add(
        PlaybackState(
          controls: [MediaControl.play, MediaControl.pause, MediaControl.stop],
          playing: state.playing,
          processingState: AudioProcessingState.ready,
        ),
      );
    });
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }
}
