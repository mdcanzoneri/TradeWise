import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../services/voice_recorder_service.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final VoiceRecorderService _recorderService = VoiceRecorderService();
  bool _isRecording = false;
  bool _isPaused = false;

  Future<void> _checkAndRequestPermission() async {
    final status = await Permission.microphone.status;
    
    if (status.isDenied) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Microphone Permission Required'),
              content: const Text('TradeWise needs microphone access to record job details. Please grant access in Settings.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await openAppSettings();
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          );
        }
      }
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Microphone Permission Required'),
            content: const Text('TradeWise needs microphone access to record job details. Please grant access in Settings.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _toggleRecording() async {
    try {
      if (!_isRecording) {
        await _checkAndRequestPermission();
        await _recorderService.startRecording();
        setState(() {
          _isRecording = true;
          _isPaused = false;
        });
      } else {
        final path = await _recorderService.stopRecording();
        setState(() {
          _isRecording = false;
          _isPaused = false;
        });
        if (path != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recording saved to: $path')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _togglePause() async {
    if (_isRecording) {
      try {
        if (_isPaused) {
          await _recorderService.resumeRecording();
        } else {
          await _recorderService.pauseRecording();
        }
        setState(() {
          _isPaused = !_isPaused;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Record Job Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sound wave animation placeholder
            Container(
              height: 100,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: _isRecording ? AppColors.electricBlue.withOpacity(0.3) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Sound Wave Animation',
                  style: TextStyle(color: AppColors.electricBlue),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isRecording)
                  FloatingActionButton(
                    onPressed: _togglePause,
                    backgroundColor: AppColors.lightGray,
                    child: Icon(
                      _isPaused ? Icons.play_arrow : Icons.pause,
                      color: AppColors.darkGray,
                    ),
                  ),
                const SizedBox(width: 20),
                FloatingActionButton.large(
                  onPressed: _toggleRecording,
                  backgroundColor: _isRecording ? AppColors.constructionOrange : AppColors.electricBlue,
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 36,
                  ),
                ),
                if (_isRecording)
                  const SizedBox(width: 20),
                if (_isRecording)
                  FloatingActionButton(
                    onPressed: _toggleRecording,
                    backgroundColor: AppColors.darkGray,
                    child: const Icon(Icons.close),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _isRecording
                  ? _isPaused
                      ? 'Paused'
                      : 'Recording...'
                  : 'Tap to Start Recording',
              style: const TextStyle(
                color: AppColors.lightGray,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
