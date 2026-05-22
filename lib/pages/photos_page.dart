import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<PhotoProvider>(
        context,
        listen: false,
      ).fetchPhotos();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<PhotoProvider>(context);

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
    return GridView.builder(
      padding: const EdgeInsets.all(12),

      itemCount: provider.photos.length,

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),

      itemBuilder: (context, index) {

        final photo = provider.photos[index];

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
}