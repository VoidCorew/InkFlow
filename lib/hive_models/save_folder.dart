import 'package:hive/hive.dart';

part 'save_folder.g.dart';

@HiveType(typeId: 1)
class SaveFolder extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  int colorValue;

  SaveFolder({required this.title, required this.colorValue});
}
