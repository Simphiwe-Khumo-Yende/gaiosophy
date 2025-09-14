import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';
import '../widgets/bookmark_button.dart';

class AudioPlayerScreen extends StatefulWidget {
  final content_model.Content content;
  final String? audioUrl;

  const AudioPlayerScreen({
    super.key,
    required this.content,
    this.audioUrl,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  double _currentPosition = 0.0; // Start at 0%
  bool isPlaying = false;
  bool isLoading = false;
  bool hasAudio = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    // Check if we have audio available
    hasAudio = widget.content.audioId != null && widget.content.audioId!.isNotEmpty;
    print('Audio Player initialized - Audio ID: ${widget.content.audioId}, Has Audio: $hasAudio');
    
    if (hasAudio) {
      _initializeAudio();
    }
    
    // Listen to audio player state changes
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
        isLoading = state.processingState == ProcessingState.loading || 
                   state.processingState == ProcessingState.buffering;
      });
    });
    
    // Listen to position changes
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
        if (_duration.inMilliseconds > 0) {
          _currentPosition = position.inMilliseconds / _duration.inMilliseconds;
        }
      });
    });
    
    // Listen to duration changes
    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });
  }
  
  Future<void> _initializeAudio() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      // For now, we'll construct a hypothetical URL from the audioId
      // You'll need to replace this with your actual audio URL construction logic
      final audioUrl = _getAudioUrl(widget.content.audioId!);
      print('Attempting to load audio from: $audioUrl');
      
      await _audioPlayer.setUrl(audioUrl);
      print('Audio loaded successfully');
      
    } catch (e) {
      print('Error loading audio: $e');
      setState(() {
        hasAudio = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading audio: ${e.toString()}'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  String _getAudioUrl(String audioId) {
    // Construct Firebase Storage URL for M4A audio files
    // Using the actual Firebase Storage bucket from your project
    const String firebaseStorageBucket = 'i7y932.firebasestorage.app';
    
    // Construct the path - assuming audio files are stored in an 'audio' folder
    // and using M4A format
    final String encodedPath = Uri.encodeComponent('audio/$audioId.m4a');
    
    return 'https://firebasestorage.googleapis.com/v0/b/$firebaseStorageBucket/o/$encodedPath?alt=media';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2), // Match app theme
      body: SafeArea(
        child: Column(
          children: [
            // Album Art Container
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Background Image
                      widget.content.featuredImageId != null
                          ? FirebaseStorageImage(
                              imageId: widget.content.featuredImageId!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                              child: const Center(
                                child: Icon(
                                  Icons.audiotrack,
                                  size: 80,
                                  color: Color(0xFF8B6B47),
                                ),
                              ),
                            ),
                      
                      // Dark overlay for better readability
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                      
                      // Home icon in top right
                      Positioned(
                        top: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () => context.go('/'),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.home_outlined,
                              color: Color(0xFF1A1612),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      
                      // Back button in top left
                      Positioned(
                        top: 16,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF1A1612),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Player Controls Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Title and Menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Refresh icon
                      IconButton(
                        onPressed: () {
                          // TODO: Implement restart functionality
                          setState(() {
                            _currentPosition = 0;
                          });
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Color(0xFF8B6B47),
                          size: 24,
                        ),
                      ),
                      
                      // Title
                      Expanded(
                        child: Text(
                          widget.content.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1612),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Bookmark icon
                      BookmarkButton(
                        content: widget.content,
                        iconColor: const Color(0xFF8B6B47),
                        iconSize: 24,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Progress bar
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 16,
                          ),
                          activeTrackColor: const Color(0xFF8B6B47),
                          inactiveTrackColor: const Color(0xFF8B6B47).withValues(alpha: 0.2),
                          thumbColor: const Color(0xFF8B6B47),
                          overlayColor: Color(0xFF8B6B47).withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: _currentPosition,
                          onChanged: hasAudio ? (value) async {
                            final newPosition = Duration(milliseconds: (value * _duration.inMilliseconds).round());
                            await _audioPlayer.seek(newPosition);
                            print('Seeking to position: ${(value * 100).toStringAsFixed(1)}%');
                          } : null,
                        ),
                      ),
                      
                      // Time labels
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_position),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8B6B47),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _duration.inSeconds > 0 ? '-${_formatDuration(_duration - _position)}' : '--:--',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8B6B47),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Playback controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Previous/Rewind
                      IconButton(
                        onPressed: hasAudio ? () async {
                          try {
                            final newPosition = _position - const Duration(seconds: 10);
                            await _audioPlayer.seek(newPosition.isNegative ? Duration.zero : newPosition);
                            print('Rewinding 10 seconds');
                          } catch (e) {
                            print('Error rewinding: $e');
                          }
                        } : null,
                        icon: Icon(
                          Icons.replay_10,
                          size: 36,
                          color: hasAudio ? const Color(0xFF8B6B47) : const Color(0xFF8B6B47).withValues(alpha: 0.3),
                        ),
                      ),
                      
                      const SizedBox(width: 32),
                      
                      // Play/Pause
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: hasAudio ? const Color(0xFF8B6B47) : const Color(0xFF8B6B47).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: hasAudio ? [
                            BoxShadow(
                              color: const Color(0xFF8B6B47).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ] : [],
                        ),
                        child: IconButton(
                          onPressed: hasAudio ? () async {
                            try {
                              if (!isPlaying) {
                                print('Starting audio playback for ID: ${widget.content.audioId}');
                                await _audioPlayer.play();
                              } else {
                                print('Pausing audio playback');
                                await _audioPlayer.pause();
                              }
                            } catch (e) {
                              print('Error controlling audio playback: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Audio playback error: ${e.toString()}'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } : () {
                            // Show message when no audio is available
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No audio available for this content'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                          icon: Icon(
                            !hasAudio ? Icons.music_off : 
                            isLoading ? Icons.hourglass_empty :
                            (isPlaying ? Icons.pause : Icons.play_arrow),
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 32),
                      
                      // Next/Fast Forward
                      IconButton(
                        onPressed: hasAudio ? () async {
                          try {
                            final newPosition = _position + const Duration(seconds: 10);
                            await _audioPlayer.seek(newPosition > _duration ? _duration : newPosition);
                            print('Fast forwarding 10 seconds');
                          } catch (e) {
                            print('Error fast forwarding: $e');
                          }
                        } : null,
                        icon: Icon(
                          Icons.forward_10,
                          size: 36,
                          color: hasAudio ? const Color(0xFF8B6B47) : const Color(0xFF8B6B47).withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Audio status or additional info
                  
                    const SizedBox(height: 12),
                  
                  // Additional info
                  if (widget.content.summary != null) ...[
                    Text(
                      widget.content.summary!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF1A1612).withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}
