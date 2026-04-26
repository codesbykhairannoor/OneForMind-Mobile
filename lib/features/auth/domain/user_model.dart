import 'package:isar/isar.dart';

part 'user_model.g.dart';

@collection
class UserLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String email;
  
  late String name;
  
  late String planType; // explorer, architect, quantum
  
  late bool isPremium;
}
