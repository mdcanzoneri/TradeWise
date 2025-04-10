import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,  
        title: Image.asset(
          'assets/images/logo_with_text.png',
          height: 55,  
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Title section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Text(
                'Record Job Details',
                style: TextStyle(
                  color: AppColors.darkGray,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Recording section
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isRecording)
                          FloatingActionButton(
                            onPressed: _togglePause,
                            backgroundColor: Colors.grey[200],
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
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.close,
                              color: AppColors.darkGray,
                            ),
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
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
