class Job {
  final String id;
  final String title;
  final String description;
  final String transcript;
  final DateTime createdAt;
  final String status;
  final String location;
  final String customerName;
  final String audioUrl;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.transcript,
    required this.createdAt,
    required this.status,
    required this.location,
    required this.customerName,
    required this.audioUrl,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      transcript: json['transcript'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
      location: json['location'] as String,
      customerName: json['customerName'] as String,
      audioUrl: json['audioUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'transcript': transcript,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'location': location,
      'customerName': customerName,
      'audioUrl': audioUrl,
    };
  }
}
