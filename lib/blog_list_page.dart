import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'blog_post_page.dart';

class BlogListPage extends StatelessWidget {
  Future<List<String>> _loadPosts() async {
    String jsonString = await rootBundle.loadString('assets/posts.json');
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
