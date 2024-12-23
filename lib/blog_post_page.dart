import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class BlogPostPage extends StatefulWidget {
  final String postName;

  BlogPostPage({required this.postName});

  @override
  _BlogPostPageState createState() => _BlogPostPageState();
}

class _BlogPostPageState extends State<BlogPostPage> {
  String _markdownContent = "";

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    String content = await DefaultAssetBundle.of(context)
        .loadString('assets/_posts/${widget.postName}');
    setState(() {
      _markdownContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _markdownContent.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Markdown(
                data: _markdownContent,
                imageBuilder: (uri, title, alt) {
                  // Dynamically load images based on the uri provided in the Markdown
                  return Image.asset(
                    '$uri', // Dynamically resolve the image path from the URI in the Markdown
                    width: 100, // Set the image width
                    height: 100, // Set the image height
                    fit: BoxFit.cover,
                  );
                },
              ),
      ),
    );
  }
}
