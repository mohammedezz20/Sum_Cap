import 'dart:convert';
import 'dart:io';

import 'package:sum_cap/core/utils/enums.dart';

class AudioModel {
  String title;
  String transcriptionText;
  DateTime createdAt;
  String? id;
  String audio;
  String? owner;
  String duration;
  String audioName;
  FileStatus status;

  AudioModel({
    required this.title,
    required this.transcriptionText,
    required this.createdAt,
    this.id,
    required this.audio,
    required this.duration,
    this.owner,
    required this.audioName,
    this.status = FileStatus.done,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      title: json['title'],
      transcriptionText: json['transcriptionText'],
      createdAt: DateTime.parse(json['createdAt']),
      id: json['_id'],
      audio: json['audio'],
      owner: json['owner'],
      audioName: json['audioName'],
      duration: json['duration'] ?? '00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'transcriptionText': transcriptionText,
      'createdAt': createdAt.toIso8601String(),
      'audio': audio,
      'audioName': audioName,
      'duration': duration,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  AudioModel copyWith({
    String? title,
    String? transcriptionText,
    DateTime? createdAt,
    String? id,
    String? audio,
    String? owner,
    String? audioName,
  }) {
    return AudioModel(
      title: title ?? this.title,
      transcriptionText: transcriptionText ?? this.transcriptionText,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      audio: audio ?? this.audio,
      owner: owner ?? this.owner,
      audioName: audioName ?? this.audioName,
      duration: duration,
    );
  }
}
