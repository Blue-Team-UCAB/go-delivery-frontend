import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FastLoadingImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Color placeholderColor;

  const FastLoadingImage({
    Key? key,
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
    this.placeholderColor = const Color(0xFFEEEEEE),
  }) : super(key: key);

  @override
  _FastLoadingImageState createState() => _FastLoadingImageState();
}

class _FastLoadingImageState extends State<FastLoadingImage> {
  late Future<Uint8List> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadImage();
  }

  @override
  void didUpdateWidget(FastLoadingImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _imageFuture = _loadImage();
      });
    }
  }

  Future<Uint8List> _loadImage() async {
    try {
      final response = await http.get(Uri.parse(widget.imageUrl));
      if (response.statusCode == 200) {
        return compute(decodeImage, response.bodyBytes);
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }

  static Uint8List decodeImage(Uint8List bytes) {
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(widget.imageUrl),
      child: FutureBuilder<Uint8List>(
        future: _imageFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: widget.width,
                  height: widget.height,
                  color: widget.placeholderColor,
                );
              },
            );
          } else {
            return Container(
              width: widget.width,
              height: widget.height,
              color: widget.placeholderColor,
            );
          }
        },
      ),
    );
  }
}