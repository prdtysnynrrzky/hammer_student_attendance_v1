class UserModel {
  final int? id;
  final String? rfid;
  final String? name;

  UserModel({
    this.id,
    this.rfid,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      rfid: json['rfid'] as String?,
      name: json['name'] as String?,
    );
  }
}
