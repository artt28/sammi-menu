import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<String> getTypeImageUrl(String typeName) async {
  try {
    final ref = firebase_storage.FirebaseStorage.instance.ref().child('images/menu/${typeName.toLowerCase()}.png');
    final downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref().child('images/menu/${typeName.toLowerCase()}.jpeg');
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return '';
    }
  }
}

Future<String> getImageUrl(String imageUrl) async {
  try {
    if (imageUrl.startsWith('gs://')) {
      final ref = firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    }
    return imageUrl;
  } catch (e) {
    print('Error getting image URL: $e, $imageUrl');
    return '';
  }
}