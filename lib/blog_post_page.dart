import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      body: _markdownContent.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Markdown(
              data: _markdownContent,
            ),
    );
  }
}
