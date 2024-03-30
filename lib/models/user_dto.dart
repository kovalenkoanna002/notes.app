class UserDto {
  int id;
  String name;

  UserDto({required this.id, required this.name});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      name: json['name']
    );
  }
}