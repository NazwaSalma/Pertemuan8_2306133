import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import '../services/photo_service.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {

  late Future<List<PhotoModel>> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePhotos = PhotoService.getPhotos();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<PhotoModel>>(
      future: futurePhotos,

      builder: (context, snapshot) {

        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        else if (snapshot.hasError) {

          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        else if (snapshot.hasData) {

          final photos = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(12),

            itemCount: photos.length,

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),

            itemBuilder: (context, index) {

              final photo = photos[index];

              return Card(
                elevation: 5,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),

                        child: Image.network(
                          photo.downloadUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),

                      child: Text(
                        photo.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
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