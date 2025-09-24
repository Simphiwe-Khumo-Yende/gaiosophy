import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/content.dart' as content_model;
import '../../data/services/offline_storage_service.dart';
import '../widgets/firebase_storage_image.dart';
import '../widgets/bookmark_button.dart';
import '../theme/typography.dart';

class AudioPlayerScreen extends ConsumerStatefulWidget {
  final content_model.Content content;
  final String? audioUrl;

  const AudioPlayerScreen({
    super.key,
    required this.content,
    this.audioUrl,
  });

  @override
  ConsumerState<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends ConsumerState<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  double _currentPosition = 0.0; // Start at 0%
  bool isPlaying = false;
  bool isLoading = false;
  bool hasAudio = false;
  bool isRepeating = false; // Add repeat state
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  content_model.Content? _fullContent; // Store the complete content data

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _fullContent = widget.content; // Initialize with passed content

    // Sign in anonymously to Firebase Auth (if not already signed in)
    _signInAndInitAudio();
    
    // If featuredImageId is missing, try to fetch complete content
    if (widget.content.featuredImageId == null) {
      _fetchCompleteContent();
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

  Future<void> _fetchCompleteContent() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('content')
          .doc(widget.content.id)
          .get();
      
      if (doc.exists && mounted) {
        final completeContent = content_model.Content.fromFirestore(doc);
        setState(() {
          _fullContent = completeContent;
        });
        print('Fetched complete content - Featured Image ID: ${completeContent.featuredImageId}');
      }
    } catch (e) {
      print('Error fetching complete content: $e');
    }
  }

  Future<void> _signInAndInitAudio() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
        
      }
    } catch (e) {
      
    }
    // Check if we have audio available - either from audioUrl parameter or content.audioId
    hasAudio = (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) || 
               (widget.content.audioId != null && widget.content.audioId!.isNotEmpty);
    
    if (hasAudio) {
      _resolveAndInitializeAudio();
    }
  }
  
  Future<void> _resolveAndInitializeAudio() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Use audioUrl if provided, otherwise use content.audioId
      String audioId = widget.audioUrl ?? widget.content.audioId!;
      String audioPath;
      
      // If audioUrl is provided and content.audioId is null/different, it's block audio
      // If they're the same (or audioUrl is null), it's global content audio
      bool isBlockAudio = widget.audioUrl != null && 
                         (widget.content.audioId == null || widget.audioUrl != widget.content.audioId);
      
      if (isBlockAudio) {
        // Block audio uses media/audio bucket
        if (audioId.startsWith('media/audio/')) {
          // audioId already has full path
          audioPath = audioId.endsWith('.m4a') || audioId.endsWith('.mp4') ? audioId : audioId + '.m4a';
        } else if (audioId.startsWith('media/audio')) {
          // audioId has path but might be missing trailing slash
          audioPath = audioId.endsWith('.m4a') || audioId.endsWith('.mp4') ? audioId : audioId + '.m4a';
        } else {
          // audioId is just the filename, prepend media/audio/
          audioPath = 'media/audio/' + (audioId.endsWith('.m4a') || audioId.endsWith('.mp4') ? audioId : audioId + '.m4a');
        }
      } else {
        // Global content audio uses media/content-audio bucket
        if (audioId.startsWith('media/content-audio/')) {
          // audioId already has full path
          audioPath = audioId.endsWith('.m4a') || audioId.endsWith('.mp4') ? audioId : audioId + '.m4a';
        } else if (audioId.startsWith('media/content-audio')) {
          // audioId has path but might be missing trailing slash
          audioPath = audioId.endsWith('.m4a') || audioId.endsWith('.mp4') ? audioId : audioId + '.m4a';
        } else {
          // audioId is just the filename, prepend media/content-audio/
          audioPath = 'media/content-audio/' + (audioId.endsWith('.m4a') || audioId.endsWith('.mp4') ? audioId : audioId + '.m4a');
        }
      }

      String? foundUrl;
      try {
        final ref = FirebaseStorage.instance.ref().child(audioPath);
        foundUrl = await ref.getDownloadURL();
        
      } catch (e) {
        // Try with mp4 extension if m4a fails
        try {
          String audioPathMp4 = audioPath.replaceAll('.m4a', '.mp4');
          final refMp4 = FirebaseStorage.instance.ref().child(audioPathMp4);
          foundUrl = await refMp4.getDownloadURL();
          
        } catch (e2) {
          throw e2;
        }
      }
      await _audioPlayer.setUrl(foundUrl);
      
    } catch (e) {
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the complete content if available, otherwise use the original
    final displayContent = _fullContent ?? widget.content;
    
    // Debug: Print content details
    print('AudioPlayer Debug:');
    print('  - Content ID: ${widget.content.id}');
    print('  - Content Title: ${widget.content.title}');
    print('  - Original Featured Image ID: ${widget.content.featuredImageId}');
    print('  - Complete Featured Image ID: ${displayContent.featuredImageId}');
    print('  - Audio ID: ${widget.content.audioId}');
    print('  - Audio URL param: ${widget.audioUrl}');
    
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      body: SafeArea(
        child: Column(
          children: [
            // Full-width image without margins
            Expanded(
              child: Stack(
                children: [
                  // Background Image - Full width
                  displayContent.featuredImageId != null
                      ? FirebaseStorageImage(
                          imageId: displayContent.featuredImageId!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorWidget: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 80,
                                    color: Color(0xFF8B6B47),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image not found',
                                    style: TextStyle(
                                      color: Color(0xFF8B6B47),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          placeholder: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF8B6B47),
                              ),
                            ),
                          ),
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
                  
                  // Bookmark button in top right
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: BookmarkButton(
                        content: displayContent,
                        iconColor: const Color(0xFF1A1612),
                        iconSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Player Controls Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFFCF9F2),
              ),
              child: Column(
                children: [
                  // Title with repeat and save icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Repeat button (left)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isRepeating = !isRepeating;
                          });
                          _audioPlayer.setLoopMode(isRepeating ? LoopMode.one : LoopMode.off);
                        },
                        icon: Icon(
                          Icons.repeat,
                          size: 20,
                          color: isRepeating ? const Color(0xFF8B6B47) : const Color(0xFF8B6B47).withValues(alpha: 0.5),
                        ),
                      ),
                      
                      // Title (center)
                      Expanded(
                        child: Text(
                          widget.content.title,
                          textAlign: TextAlign.center,
                          style: context.primaryTitleMedium.copyWith(
                            color: const Color(0xFF5A4E3C),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Save/Download button with circle plus icon (right)
                      IconButton(
                        onPressed: hasAudio ? () => _downloadAudioForOffline() : null,
                        icon: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: hasAudio ? const Color(0xFF8B6B47) : const Color(0xFF8B6B47).withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 16,
                            color: hasAudio ? const Color(0xFF8B6B47) : const Color(0xFF8B6B47).withValues(alpha: 0.3),
                          ),
                        ),
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
                  
                  // Playback controls - 3 centered controls as per Figma
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Previous/Rewind 
                      IconButton(
                        onPressed: hasAudio ? () async {
                          try {
                            final newPosition = _position - const Duration(seconds: 10);
                            await _audioPlayer.seek(newPosition.isNegative ? Duration.zero : newPosition);
                          } catch (e) {
                            // Handle error
                          }
                        } : null,
                        icon: Icon(
                          Icons.fast_rewind,
                          size: 32,
                          color: hasAudio ? const Color(0xFF8B6B47) : const Color(0xFF8B6B47).withValues(alpha: 0.3),
                        ),
                      ),
                      
                      const SizedBox(width: 24),
                      
                      // Play/Pause (center)
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: hasAudio ? const Color(0xFF8B6B47) : const Color(0xFF8B6B47).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: IconButton(
                          onPressed: hasAudio ? () async {
                            try {
                              if (!isPlaying) {
                                await _audioPlayer.play();
                              } else {
                                await _audioPlayer.pause();
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Audio playback error: ${e.toString()}'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } : () {
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
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 24),
                      
                      // Next/Fast Forward
                      IconButton(
                        onPressed: hasAudio ? () async {
                          try {
                            final newPosition = _position + const Duration(seconds: 10);
                            await _audioPlayer.seek(newPosition > _duration ? _duration : newPosition);
                          } catch (e) {
                            // Handle error
                          }
                        } : null,
                        icon: Icon(
                          Icons.fast_forward,
                          size: 32,
                          color: hasAudio ? const Color(0xFF8B6B47) : const Color(0xFF8B6B47).withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Download audio for offline access
  Future<void> _downloadAudioForOffline() async {
    if (!hasAudio) return;
    
    try {
      final offlineService = ref.read(offlineStorageServiceProvider);
      
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('Saving audio for offline access...'),
            ],
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Color(0xFF8B6B47),
        ),
      );

      // Save content for offline access (this will include the audio file reference)
      await offlineService.toggleBookmark(widget.content.id, widget.content);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text('Audio saved for offline access!'),
              ],
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving audio: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}
