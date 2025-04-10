import 'dart:async';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class VoiceRecorderService {
  AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _recordingPath;
  
  Future<bool> hasPermission() async {
    debugPrint('=== Starting permission check ===');
    
    try {
      // Try direct recorder permission check first
      final hasRecorderPermission = await _audioRecorder.hasPermission();
      debugPrint('Direct recorder permission check: $hasRecorderPermission');
      if (hasRecorderPermission) {
        return true;
      }

      // Check system permission status
      final micStatus = await Permission.microphone.status;
      debugPrint('System permission status: $micStatus');

      if (micStatus.isGranted) {
        return true;
      }

      // Request permission using platform channel
      const platform = MethodChannel('com.mdc.tradewise/permissions');
      try {
        final bool result = await platform.invokeMethod('requestMicrophonePermission');
        debugPrint('Platform channel permission result: $result');
        return result;
      } on PlatformException catch (e) {
        debugPrint('Platform channel error: ${e.message}');
        
        // Fall back to permission_handler if platform channel fails
        final result = await Permission.microphone.request();
        debugPrint('Fallback permission request result: $result');
        return result.isGranted;
      }
    } catch (e) {
      debugPrint('Error during permission check: $e');
      return false;
    }
  }

  Future<void> startRecording() async {
    debugPrint('Attempting to start recording...');
    
    if (!await hasPermission()) {
      debugPrint('No microphone permission');
      throw Exception('Microphone permission not granted');
    }

    final directory = await getApplicationDocumentsDirectory();
    _recordingPath = path.join(
      directory.path,
      'recording_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
    debugPrint('Recording will be saved to: $_recordingPath');

    try {
      // Initialize a new recorder instance
      await _audioRecorder.dispose();
      _audioRecorder = AudioRecorder();
      
      debugPrint('Starting recording with config...');
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _recordingPath!,
      );
      debugPrint('Recording started successfully');
      _isRecording = true;
    } catch (e) {
      debugPrint('Error starting recording: $e');
      throw Exception('Failed to start recording: $e');
    }
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) return null;
    
    try {
      await _audioRecorder.stop();
      debugPrint('Recording stopped, saved to: $_recordingPath');
      _isRecording = false;
      return _recordingPath;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      return null;
    }
  }

  Future<void> pauseRecording() async {
    if (_isRecording) {
      try {
        await _audioRecorder.pause();
        debugPrint('Recording paused');
      } catch (e) {
        debugPrint('Error pausing recording: $e');
      }
    }
  }

  Future<void> resumeRecording() async {
    if (!_isRecording) {
      try {
        await _audioRecorder.resume();
        debugPrint('Recording resumed');
      } catch (e) {
        debugPrint('Error resuming recording: $e');
      }
    }
  }

  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }

  bool get isRecording => _isRecording;
}
