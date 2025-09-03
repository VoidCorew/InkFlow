import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/hive_models/save_folder.dart';
import 'package:note_app/hive_models/save_note.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SaveNoteAdapter());
    Hive.registerAdapter(SaveFolderAdapter());

    // await Hive.deleteBoxFromDisk('notes');
    await Hive.openBox<SaveNote>('notes');

    // await Hive.deleteBoxFromDisk('archive');
    await Hive.openBox<SaveNote>('archive');

    // await Hive.deleteBoxFromDisk('trash_notes');
    await Hive.openBox<SaveNote>('trash_notes');

    // await Hive.deleteBoxFromDisk('trash_folders');
    await Hive.openBox<SaveFolder>('trash_folders');

    // await Hive.deleteBoxFromDisk('folders');
    await Hive.openBox<SaveFolder>('folders');
  }

  static Box<SaveNote> getNotesBox() => Hive.box<SaveNote>('notes');
  static Box<SaveNote> getArchiveBox() => Hive.box<SaveNote>('archive');
  static Box<SaveNote> getTrashNotesBox() => Hive.box<SaveNote>('trash_notes');
  static Box<SaveFolder> getTrashFoldersBox() =>
      Hive.box<SaveFolder>('trash_folders');
  static Box<SaveFolder> getFoldersBox() => Hive.box<SaveFolder>('folders');
}
