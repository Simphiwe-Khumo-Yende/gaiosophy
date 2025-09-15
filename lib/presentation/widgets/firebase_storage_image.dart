import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:cached_network_image/cached_network_image.dart';

class FirebaseStorageImage extends StatefulWidget {
  const FirebaseStorageImage({
    super.key,
    required this.imageId,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  final String imageId;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  State<FirebaseStorageImage> createState() => _FirebaseStorageImageState();
}

class _FirebaseStorageImageState extends State<FirebaseStorageImage> {
  String? _imageUrl;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    try {
      // Ensure we're signed in (anonymous) so storage rules that require auth pass
      try {
        if (FirebaseAuth.instance.currentUser == null) {
          await FirebaseAuth.instance.signInAnonymously();
          
        }
      } catch (e) {
        // ignore auth errors; we'll still try to fetch URL
        
      }

      // Try the content-images path with .webp first (most of your assets are webp)
      final exts = ['webp', 'png', 'jpg', 'jpeg'];
      String? foundUrl;
      for (final ext in exts) {
        final path = 'media/content-images/${widget.imageId}.$ext';
        try {
          
          final url = await FirebaseStorage.instance.ref().child(path).getDownloadURL();
          foundUrl = url;
          
          break;
        } catch (e) {
          // not found, try next extension
          //
        }
      }

      final url = foundUrl;
      if (mounted) {
        setState(() {
          _imageUrl = url;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ?? Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null || _imageUrl == null) {
      return widget.errorWidget ?? Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.grey,
        ),
      );
    }

    // On web in debug mode, show a placeholder to avoid CORS errors
    if (kIsWeb && kDebugMode) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_android,
              color: Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              'Mobile only',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }

    // On web (production), still try to load the image
    if (kIsWeb) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          _imageUrl!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (context, error, stack) {
            
            return widget.errorWidget ?? Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
              ),
            );
          },
        ),
      );
    }

    // On native platforms keep CachedNetworkImage for caching benefits
    return CachedNetworkImage(
      imageUrl: _imageUrl!,
      width: widget.width,
      height: widget.height,
      imageBuilder: (context, imageProvider) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: widget.fit),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      placeholder: (context, url) => widget.placeholder ?? Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) {
        
        return widget.errorWidget ?? Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}