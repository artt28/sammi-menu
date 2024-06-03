import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/menu.dart';

class MenuDetailScreen extends StatelessWidget {
  final Menu menu;

  const MenuDetailScreen({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menu.name[context.locale.languageCode]!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: _getImageUrl(menu.imageUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error loading image: ${snapshot.error}');
                  return const Center(child: Icon(Icons.error));
                } else {
                  return snapshot.hasData
                      ? Image.network(snapshot.data!, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error))
                      : const Icon(Icons.error);
                }
              },
            ),
            const SizedBox(height: 16),
            Text(menu.name[context.locale.languageCode]!, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(menu.description[context.locale.languageCode]!),
            const SizedBox(height: 8),
            Text('₩${menu.price}', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }

  Future<String> _getImageUrl(String imageUrl) async {
    try {
      if (imageUrl.startsWith('gs://')) {
        final ref = firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
        final downloadUrl = await ref.getDownloadURL();
        print('Download URL: $downloadUrl');
        return downloadUrl;
      }
      return imageUrl;
    } catch (e) {
      print('Error getting image URL: $e');
      return '';
    }
  }
}
