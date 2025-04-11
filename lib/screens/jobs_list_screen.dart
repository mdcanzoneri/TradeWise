import 'package:flutter/material.dart';
import 'package:tradewise/models/job.dart';
import 'package:tradewise/screens/job_details_screen.dart';
import 'package:tradewise/screens/recording_screen.dart';
import 'package:tradewise/services/job_service.dart';
import 'package:tradewise/widgets/job_card.dart';
import 'package:tradewise/widgets/bottom_nav_bar.dart';

class JobsListScreen extends StatelessWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<Job>>(
        future: JobService.getAllJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final jobs = snapshot.data ?? [];
          
          if (jobs.isEmpty) {
            return const Center(
              child: Text(
                'No jobs yet.\nTap the microphone icon to record a new job.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return JobCard(
                job: job,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailsScreen(job: job),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            try {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecordingScreen(),
                ),
              );
            } catch (e) {
              // Fallback if navigation fails
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unable to switch screens. Please try again.'),
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}
