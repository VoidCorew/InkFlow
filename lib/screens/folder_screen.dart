import 'package:flutter/material.dart';
import 'package:note_app/hive_models/save_folder.dart';
import 'package:note_app/providers/note_provider.dart';
import 'package:note_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

class FolderScreen extends StatelessWidget {
  final SaveFolder folder;
  const FolderScreen({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final notes = noteProvider.getNotesByFolder(folder.key as int);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Папка: ${folder.title}',
          style: TextStyle(fontFamily: 'Oswald'),
        ),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                'В этой папке ничего нет',
                style: TextStyle(fontFamily: 'Oswald'),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteCard(note: note, noteProvider: noteProvider);
                },
              ),
            ),
    );
  }
}
