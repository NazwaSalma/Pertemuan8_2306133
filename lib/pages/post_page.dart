import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<PostProvider>(
        context,
        listen: false,
      ).fetchPost();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<PostProvider>(context);

    // Loading
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error
    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Text(provider.errorMessage),
      );
    }

    // Success
    return ListView.builder(
      padding: const EdgeInsets.all(12),

      itemCount: provider.posts.length,

      itemBuilder: (context, index) {

        final post = provider.posts[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 15),

          child: Card(
            elevation: 5,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),

            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // Badge Postingan
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,

                      borderRadius:
                          BorderRadius.circular(12),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [

                        Icon(
                          Icons.local_fire_department,
                          size: 18,
                          color:
                              Colors.orange.shade900,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          'Postingan #${post.id}',

                          style: TextStyle(
                            color:
                                Colors.orange.shade900,

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Title
                  Text(
                    post.title,

                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Body
                  Text(
                    post.body,

                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}