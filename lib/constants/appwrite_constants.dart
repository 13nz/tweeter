class AppwriteConstants {
  static const String databaseId = '6649f145002f0a2c364b';
  static const String projectId = '6649f05e0004e3e5e600';
  static const String endPoint = 'http://localhost:80/v1';
  //static const String endPoint = 'https://192.168.1.1:80/v1';
  static const String usersCollection = '664b37fc00355ad77087';
  static const String tweetsCollection = '664ca8020006dfe286f3';
  static const String imagesBucket = '664cb906002cab8d8855';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
