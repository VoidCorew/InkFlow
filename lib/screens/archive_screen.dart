import 'package:flutter/material.dart';
import 'package:note_app/providers/note_provider.dart';
import 'package:provider/provider.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final archive = noteProvider.archive;

    return Scaffold(
      body: archive.isEmpty
          ? const Center(
              child: Text(
                'Архив пустой',
                style: TextStyle(fontFamily: 'Oswald'),
              ),
            )
          : ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              itemCount: noteProvider.archive.length,
              itemBuilder: (context, index) {
                final note = noteProvider.archive[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // tileColor: Colors.yellow,
                  tileColor: note.backgroundColorValue != null
                      ? Color(note.backgroundColorValue!)
                      : Colors.yellow,
                  title: Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Jura',
                      fontFamilyFallback: ['Apple'],
                      // color: Colors.black,
                      color: note.textColorValue != null
                          ? Color(note.textColorValue!)
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    note.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Jura',
                      fontFamilyFallback: ['Apple'],
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.restore, color: Colors.blue),
                        onPressed: () {
                          noteProvider.restoreNoteFromTrash(note);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Заметка восстановлена',
                                style: TextStyle(fontFamily: 'Oswald'),
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_forever, color: Colors.red),
                        onPressed: () {
                          noteProvider.moveNoteToTrash(note);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Заметка перемещена в корзину',
                                style: TextStyle(fontFamily: 'Oswald'),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
