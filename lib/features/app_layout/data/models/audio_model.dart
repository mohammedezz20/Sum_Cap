import 'package:sum_cap/core/utils/enums.dart';

class AudioModel {
  String title;
  String transcriptionText;
  DateTime createdAt;
  String? audioId;
  String duration;
  String audioUrl;
  String? owner;
  String audioName;
  List<Paragraph>? paragraphs;
  List<Topic>? topics;
  FileStatus status;

  AudioModel({
    required this.title,
    required this.transcriptionText,
    required this.createdAt,
    this.audioId,
    required this.duration,
    required this.audioUrl,
    this.owner,
    required this.audioName,
    this.paragraphs,
    this.topics,
    this.status = FileStatus.done,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      title: json['title'],
      transcriptionText: json['transcriptionText'],
      createdAt: DateTime.parse(json['createdAt']),
      audioId: json['_id'],
      duration: json['duration'],
      audioUrl: json['audio'],
      owner: json['owner'],
      audioName: json['audioName'],
      paragraphs: List<Paragraph>.from(json['paragraphs']?.map((x) {
            return Paragraph.fromJson(x);
          }) ??
          []),
      topics: List<Topic>.from(json['topics']?.map((x) {
            return Topic.fromJson(x);
          }) ??
          []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'transcriptionText': transcriptionText,
      'createdAt': createdAt,
      '_id': audioId,
      'duration': duration,
      'audio': audioUrl,
      'owner': owner,
      'audioName': audioName,
      'paragraphs': List<dynamic>.from(paragraphs!.map((x) => x.toJson())),
      'topics': List<dynamic>.from(topics!.map((x) => x.toJson())),
    };
  }

  @override
  String toString() {
    return 'AudioModel { title: $title, transcriptionText: $transcriptionText, '
        'createdAt: $createdAt, audioId: $audioId, duration: $duration, '
        'audioUrl: $audioUrl, owner: $owner, audioName: $audioName, '
        'paragraphs: ${paragraphs.toString()}, topics: ${topics.toString()}, status: $status }';
  }

  factory AudioModel.fromJsonWithTranscript(Map<String, dynamic> json) {
    String transcriptData = json['paragraphs']['transcript'];

    return AudioModel(
      title: json['title'] ?? '',
      transcriptionText: transcriptData,
      createdAt: DateTime.now(),
      audioId: json['_id'] ?? '',
      duration: json['duration'] ?? '',
      audioUrl: json['audio'] ?? '',
      owner: json['owner'] ?? '',
      audioName: json['audioName'] ?? '',
      paragraphs: List<Paragraph>.from(
          json['topics']?.map((x) => Paragraph.fromJson(x)) ?? []),
      topics:
          List<Topic>.from(json['topics']?.map((x) => Topic.fromJson(x)) ?? []),
    );
  }
}

class Paragraph {
  String paragraphId;
  num end;
  int numWords;
  List<Sentence> sentences;
  double start;

  Paragraph({
    required this.paragraphId,
    required this.end,
    required this.numWords,
    required this.sentences,
    required this.start,
  });

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    return Paragraph(
      paragraphId: json['_id'] ?? '',
      end: json['end'] ?? 0.0,
      numWords: json['num_words'] ?? 0,
      sentences: List<Sentence>.from(
          json['sentences']?.map((x) => Sentence.fromJson(x)) ?? []),
      start: json['start'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'end': end ?? 0.0,
      'num_words': numWords ?? 0,
      'sentences': List<dynamic>.from(sentences.map((x) => x.toJson())),
      'start': start ?? 0.0,
    };
  }

  @override
  String toString() {
    return 'Paragraph { paragraphId: $paragraphId, end: $end, numWords: $numWords, '
        'sentences: $sentences, start: $start }';
  }
}

class Sentence {
  String sentenceId;
  num end;
  double start;
  String text;

  Sentence({
    required this.sentenceId,
    required this.end,
    required this.start,
    required this.text,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      sentenceId: json['_id'] ?? '',
      end: json['end'],
      start: json['start'] ?? 0.0,
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sentenceId,
      'end': end,
      'start': start,
      'text': text,
    };
  }

  @override
  String toString() {
    return 'Sentence { sentenceId: $sentenceId, end: $end, start: $start, '
        'text: $text }';
  }
}

class Topic {
  String topicId;
  int endWord;
  int startWord;
  String text;
  List<TopicDetail> topics;

  Topic({
    required this.topicId,
    required this.endWord,
    required this.startWord,
    required this.text,
    required this.topics,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topicId: json['_id'] ?? '',
      endWord: json['end_word'] ?? 0,
      startWord: json['start_word'] ?? 0,
      text: json['text'],
      topics: List<TopicDetail>.from(
          json['topics']?.map((x) => TopicDetail.fromJson(x)) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': topicId,
      'end_word': endWord,
      'start_word': startWord,
      'text': text,
      'topics': List<dynamic>.from(topics.map((x) => x.toJson())),
    };
  }

  @override
  String toString() {
    return 'Topic { topicId: $topicId, endWord: $endWord, startWord: $startWord, '
        'text: $text, topics: ${topics.toString()} }';
  }
}

class TopicDetail {
  String? topicId;
  double? confidence;
  String? topic;

  TopicDetail({
    required this.topicId,
    required this.confidence,
    required this.topic,
  });

  factory TopicDetail.fromJson(Map<String, dynamic> json) {
    return TopicDetail(
      topicId: json['_id'] ?? '',
      confidence: json['confidence'] ?? 0.0,
      topic: json['topic'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': topicId,
      'confidence': confidence,
      'topic': topic,
    };
  }

  @override
  String toString() {
    return 'TopicDetail { topicId: $topicId, confidence: $confidence, topic: $topic }';
  }
}
