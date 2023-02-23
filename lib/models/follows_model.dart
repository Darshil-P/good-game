import 'follow_model.dart';

class Follows {
  List users;

  Follows({
    required this.users,
  });

  Map<String, dynamic> toMap() {
    return {
      'users': users.map((follow) => follow.toMap()).toList(),
    };
  }

  factory Follows.fromMap(Map<String, dynamic> map) {
    return Follows(
      users: map['users'].map((user) => Follow.fromMap(user)).toList(),
    );
  }
}
