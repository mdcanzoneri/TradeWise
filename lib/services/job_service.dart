import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';
import 'package:uuid/uuid.dart';

class JobService {
  static const String _jobsKey = 'jobs';
  static final _uuid = Uuid();

  // Get all jobs
  static Future<List<Job>> getAllJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final jobsJson = prefs.getStringList(_jobsKey) ?? [];
    return jobsJson
        .map((json) => Job.fromJson(jsonDecode(json)))
        .toList()
        .reversed
        .toList(); // Most recent first
  }

  // Add a new job
  static Future<Job> addJob({
    required String title,
    required String description,
    required String transcript,
    required String location,
    required String customerName,
    required String audioUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final jobsJson = prefs.getStringList(_jobsKey) ?? [];

    final newJob = Job(
      id: _uuid.v4(),
      title: title,
      description: description,
      transcript: transcript,
      createdAt: DateTime.now(),
      status: 'New',
      location: location,
      customerName: customerName,
      audioUrl: audioUrl,
    );

    jobsJson.add(jsonEncode(newJob.toJson()));
    await prefs.setStringList(_jobsKey, jobsJson);

    return newJob;
  }
}
