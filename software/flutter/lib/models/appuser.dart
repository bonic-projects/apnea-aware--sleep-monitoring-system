class AppUser {
  final String id;
  final String fullName;
  final String photoUrl;
  final String email;
  final String userRole;

  final DateTime regTime;

  final String? videoId;
  final bool? isVideoOn;

  AppUser({
    required this.id,
    required this.fullName,
    required this.photoUrl,
    required this.email,
    required this.userRole,
    required this.regTime,
    this.videoId,
    this.isVideoOn,
  });

  AppUser.fromMap(Map<String, dynamic> data)
      : id = data['id'] ?? "",
        fullName = data['fullName'] ?? "nil",
        photoUrl = data['photoUrl'] ?? "nil",
        email = data['email'] ?? "nil",
        userRole = data['userRole'] ?? "patient",
        isVideoOn = data[false],
        videoId = data['videoId'],
        regTime =
            data['regTime'] != null ? data['regTime'].toDate() : DateTime.now();

  Map<String, dynamic> toJson(keyword) {
    Map<String, dynamic> map = {
      'id': id,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'keyword': keyword,
      'email': email,
      'userRole': userRole,
      'isVideoOn': isVideoOn,
    };
    // if (imgString != null) map['imgString'] = imgString!;
    return map;
  }
}
