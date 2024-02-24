import 'package:flutter/material.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';

class AudioDetailsScreen extends StatelessWidget {
  AudioModel audioModel;
  AudioDetailsScreen({Key? key, required this.audioModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Details'),
      ),
      body: Center(
        child: Text(audioModel.transcriptionText),
      ),
    );
  }
}
