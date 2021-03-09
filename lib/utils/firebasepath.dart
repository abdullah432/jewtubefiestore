class FirestorePath {
  static String avatar(String useruid) => 'users/$useruid/avatar.png';
  static String channelavatar(String channelname) =>
      'channel/$channelname/avatar.png';
  static String filePath(String useruid, String contentType, String filename) =>
      "users/$useruid/${contentType.split("/")[0]}/$filename";
  static String fileThumbnailPath(String useruid, String filename) =>
      "users/$useruid/thumbnails/$filename.png";
}
