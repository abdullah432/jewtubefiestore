class FirestorePath {
  static String avatar(String useruid) => 'users/$useruid/avatar.png';
  static String channelavatar(String channelname) =>
      'channel/${channelname}avatar.png';
  static String filePath(
          String channeluid, String contentType, String filename) =>
      "channels/$channeluid/${contentType.split("/")[0]}/$filename";
  static String fileThumbnailPath(String useruid, String filename) =>
      "users/$useruid/thumbnails/$filename.png";
}
