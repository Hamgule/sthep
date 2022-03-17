import 'package:sthep/model/user/exp.dart';

class User {
  /// variables
  String id;
  String nickname;
  String password;

  Exp exp = Exp();

  /// constructor
  User({
    required this.id,
    required this.nickname,
    required this.password,
  });

}