import 'package:flutter/material.dart';
import 'models/post_model.dart';
import 'services/post_service.dart';
import 'pages/photos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consume API',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const PostPage(),
    const PhotosPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentIndex == 0
              ? 'Daftar Postingan API'
              : 'Gallery Photos',

          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        backgroundColor: Colors.orangeAccent,
      ),

      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Posts',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Photos',
          ),
        ],
      ),
    );
  }
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  late Future<List<PostModel>> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = PostService.getPosts();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<PostModel>>(
      future: futurePost,

      builder: (context, snapshot) {

        // Loading
        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error
        else if (snapshot.hasError) {

          return Center(
            child: Text(
              'Error: ${snapshot.error}',
            ),
          );
        }

        // Success
        else if (snapshot.hasData) {

          final posts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),

            itemCount: posts.length,

            itemBuilder: (context, index) {

              final post = posts[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 15),

                child: Card(
                  elevation: 5,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
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

        return const Center(
          child: Text('Tidak ada data'),
        );
      },
    );
  }
}