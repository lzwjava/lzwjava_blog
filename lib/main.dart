import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Blog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlogListPage(),
    );
  }
}

class BlogListPage extends StatelessWidget {
  Future<List<String>> _loadPosts() async {
    String jsonString = await rootBundle.loadString('../assets/posts.json');
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Posts"),
      ),
      body: FutureBuilder<List<String>>(
        future: _loadPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(posts[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BlogPostPage(postName: posts[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

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
        .loadString('../assets/_posts/${widget.postName}');
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
            : Text(_markdownContent),
      ),
    );
  }
}
