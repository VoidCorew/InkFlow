import 'package:hive/hive.dart';

part 'save_note.g.dart';

@HiveType(typeId: 0)
class SaveNote extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  int? folderId;

  @HiveField(3)
  String? backgroundImagePath;

  @HiveField(4)
  int? textColorValue;

  @HiveField(5)
  int? backgroundColorValue;

  @HiveField(6)
  List<String>? audioNotes;

  @HiveField(7)
  List<String>? audioTitles;

  SaveNote({
    required this.title,
    required this.content,
    this.folderId,
    this.backgroundImagePath,
    this.textColorValue,
    this.backgroundColorValue,
    this.audioNotes,
    this.audioTitles,
  });
}
