import 'package:flutter/material.dart';
import 'package:tradewise/models/job.dart';
import 'package:tradewise/screens/job_details_screen.dart';
import 'package:tradewise/screens/recording_screen.dart';
import 'package:tradewise/widgets/job_card.dart';
import 'package:tradewise/widgets/bottom_nav_bar.dart';

class JobsListScreen extends StatelessWidget {
  const JobsListScreen({super.key});

  // TODO: Replace with actual data fetching
  List<Job> _getDummyJobs() {
    return [
      Job(
        id: '1',
        title: 'Kitchen Renovation',
        description: 'Complete kitchen remodel including new cabinets, countertops, and appliances.',
        transcript: 'Customer wants a full kitchen renovation. They have requested new cabinets in a modern style, granite countertops, and all new stainless steel appliances. The existing layout works well, but everything needs updating. Budget is flexible but targeting around \$30,000.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        status: 'New',
        location: 'San Francisco, CA',
        customerName: 'John Smith',
        audioUrl: 'path/to/audio1.mp3',
      ),
      Job(
        id: '2',
        title: 'Bathroom Remodel',
        description: 'Master bathroom update with new shower, vanity, and flooring.',
        transcript: 'Master bathroom needs a complete update. Customer wants a large walk-in shower with glass doors, double vanity with quartz countertop, and new tile flooring. They also mentioned wanting heated floors if possible.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: 'In Progress',
        location: 'Oakland, CA',
        customerName: 'Jane Doe',
        audioUrl: 'path/to/audio2.mp3',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _getDummyJobs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
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
