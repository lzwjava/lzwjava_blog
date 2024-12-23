import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart'; // Import YAML package
import 'blog_post_page.dart';

class BlogListPage extends StatefulWidget {
  @override
  _BlogListPageState createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  late Future<List<Map<String, String>>> _postFiles;

  @override
  void initState() {
    super.initState();
    _postFiles = _loadPostFiles();
  }

  Future<List<Map<String, String>>> _loadPostFiles() async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = jsonDecode(manifestJson);

    List<Map<String, String>> postDetails = [];

    // Filter out markdown files in the _posts directory
    for (var key in manifestMap.keys) {
      if (key.startsWith('assets/_posts/') && key.endsWith('.md')) {
        String filename = key.replaceFirst('assets/_posts/', '');
        String title = await _extractTitleFromFile(filename);
        postDetails.add({
          'filename': filename,
          'title': title,
        });
      }
    }

    // Sort the posts by file name in descending order
    postDetails.sort((a, b) => b['filename']!.compareTo(a['filename']!));

    return postDetails;
  }

  Future<String> _extractTitleFromFile(String filename) async {
    String content = await rootBundle.loadString('assets/_posts/$filename');
    final frontMatter = _extractFrontMatter(content);
    return frontMatter['title'] ?? 'Untitled';
  }

  Map<String, dynamic> _extractFrontMatter(String content) {
    // Extract the front matter (between ---)
    RegExp frontMatterRegex = RegExp(r'---\s*\n(.*?)\n---', dotAll: true);
    var match = frontMatterRegex.firstMatch(content);
    if (match != null) {
      String frontMatter = match.group(1)!;
      var yamlMap = loadYaml(frontMatter); // Returns a YamlMap
      return Map<String, dynamic>.from(
          yamlMap); // Convert YamlMap to Map<String, dynamic>
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Posts"),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _postFiles,
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
                title: Text(posts[index]['title']!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BlogPostPage(postName: posts[index]['filename']!),
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
