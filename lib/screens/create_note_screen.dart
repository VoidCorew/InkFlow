import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:note_app/hive_models/save_note.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/shared_preferences.dart/theme_provider.dart';
import 'package:note_app/widgets/audio_player_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class CreateNoteScreen extends StatefulWidget {
  final SaveNote? note;
  final int? folderId;

  const CreateNoteScreen({super.key, this.note, this.folderId});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Color _backgroundColor = Colors.yellow;
  Color _textColor = Colors.black;

  File? _selectedImage;
  // audio
  // File? audioFile;
  bool _isRecording = false;
  final AudioRecorder _record = AudioRecorder();
  // String? _currentPath;

  List<String> _audioPaths = [];
  List<String> _audioTitles = [];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      if (widget.note!.backgroundImagePath != null &&
          widget.note!.backgroundImagePath!.isNotEmpty) {
        _selectedImage = File(widget.note!.backgroundImagePath!);
      }
      _backgroundColor = widget.note!.backgroundColorValue != null
          ? Color(widget.note!.backgroundColorValue!)
          : Colors.yellow;
      _textColor = widget.note!.textColorValue != null
          ? Color(widget.note!.textColorValue!)
          : Colors.black;
      _audioPaths = widget.note!.audioNotes?.toList() ?? [];
      _audioTitles =
          widget.note!.audioTitles?.toList() ??
          List.filled(widget.note!.audioNotes?.length ?? 0, 'Аудио заметка');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _getAudioFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return '${dir.path}/note_audio_$timestamp.m4a';
  }

  Future<void> _startRecording() async {
    if (await _record.hasPermission()) {
      final path = await _getAudioFilePath();
      await _record.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    final path = await _record.stop();
    setState(() {
      _isRecording = false;
    });

    if (path != null) {
      setState(() {
        _audioPaths.add(path);
      });
    }
  }

  void _removeAudioPath(String path, int index) async {
    setState(() {
      _audioPaths.removeAt(index);
      if (_audioTitles.length > index) {
        _audioTitles.removeAt(index);
      }
    });

    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(FluentIcons.edit_arrow_back_24_regular),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(FluentIcons.options_24_regular),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(FluentIcons.more_vertical_24_regular),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // color: _backgroundColor,
              image: _selectedImage != null
                  ? DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          // Container(color: Colors.black.withValues(alpha: 0.1)),
          SingleChildScrollView(
            child: Column(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: Colors.yellow.withValues(alpha: 0.3),
                      selectionHandleColor: Colors.yellow,
                    ),
                  ),
                  child: TextField(
                    controller: _titleController,
                    maxLines: null,
                    cursorColor: Colors.yellow,
                    decoration: InputDecoration(
                      hint: Text(
                        "Введи название :>",
                        style: TextStyle(fontFamily: 'Oswald', fontSize: 25),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Jura',
                      fontFamilyFallback: ['Apple'],
                    ),
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: Colors.yellow.withValues(alpha: 0.3),
                      selectionHandleColor: Colors.yellow,
                    ),
                  ),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    cursorColor: Colors.yellow,
                    decoration: InputDecoration(
                      hint: Text(
                        "Введи заметку ^_^",
                        style: TextStyle(fontSize: 18, fontFamily: 'Oswald'),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Jura',
                      fontFamilyFallback: ['Apple'],
                    ),
                  ),
                ),
                if (_audioPaths.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: List.generate(
                        _audioPaths.length,
                        (index) => _buildAudioWidget(_audioPaths[index], index),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final note = SaveNote(
            title: _titleController.text,
            content: _contentController.text,
            folderId: widget.folderId,
            backgroundImagePath: _selectedImage?.path,
            textColorValue: _textColor.toARGB32(),
            backgroundColorValue: _backgroundColor.toARGB32(),
            audioNotes: _audioPaths,
            audioTitles: _audioTitles,
          );

          if (widget.note != null) {
            widget.note!
              ..title = _titleController.text
              ..content = _contentController.text
              ..folderId = widget.folderId ?? widget.note!.folderId
              ..backgroundImagePath = _selectedImage?.path
              ..textColorValue = _textColor.toARGB32()
              ..backgroundColorValue = _backgroundColor.toARGB32()
              ..audioNotes = note.audioNotes
              ..audioTitles = note.audioTitles;

            await widget.note!.save();
            Navigator.pop(context, widget.note);
          } else {
            Navigator.pop(context, note);
          }
        },
        backgroundColor: Colors.yellow,
        shape: CircleBorder(),
        child: Icon(FluentIcons.save_24_regular, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.yellow,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(
                FluentIcons.color_24_regular,
                color: Colors.black,
              ),
              onPressed: () => _showBackgroundColorDialog(context),
            ),
            IconButton(
              icon: const Icon(
                FluentIcons.text_16_regular,
                color: Colors.black,
              ),
              onPressed: () => _showTextColorDialog(context),
            ),
            IconButton(
              icon: const Icon(
                FluentIcons.image_24_regular,
                color: Colors.black,
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            IconButton(
              icon: const Icon(
                FluentIcons.arrow_reset_24_regular,
                color: Colors.black,
              ),
              onPressed: () => _showRestoreDialog(context),
            ),
            IconButton(
              icon: Icon(
                _isRecording
                    ? FluentIcons.stop_24_regular
                    : FluentIcons.mic_24_regular,
                color: Colors.black,
              ),
              onPressed: () async {
                if (_isRecording) {
                  await _stopRecording();
                } else {
                  await _startRecording();
                }
              },
            ),
            IconButton(
              icon: const Icon(
                FluentIcons.attach_24_regular,
                color: Colors.black,
              ),
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text(
          'Вы точно хотите вернуть задний фон по умолчанию?',
          style: TextStyle(fontFamily: 'Oswald'),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 25.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.red, width: 2),
              ),
              // backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Отмена",
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Oswald',
                fontSize: 18,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 25.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.green, width: 2),
              ),
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              setState(() {
                _selectedImage = null;
                widget.note?.backgroundImagePath = null;
              });
              Navigator.pop(context);
            },
            child: Text(
              "Восстановить",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Oswald',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBackgroundColorDialog(BuildContext context) {
    Color tempColor = _backgroundColor;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text(
          'Выберите цвет для заднего фона',
          style: TextStyle(fontFamily: 'Oswald'),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerAreaBorderRadius: BorderRadius.circular(10),
            pickerColor: tempColor,
            onColorChanged: (Color color) {
              tempColor = color;
            },
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 25.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(color: Colors.yellow[600]!, width: 2),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Отмена",
              style: TextStyle(
                color: themeProvider.isDark
                    ? Colors.yellow[600]!
                    : Colors.black,
                fontFamily: 'Oswald',
                fontSize: 18,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 25.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.yellow,
            ),
            onPressed: () {
              setState(() {
                _backgroundColor = tempColor;
              });
              Navigator.pop(context);
            },
            child: Text(
              "Выбрать",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Oswald',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTextColorDialog(BuildContext context) {
    Color tempColor = _textColor;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text(
          'Выберите цвет для текста',
          style: TextStyle(fontFamily: 'Oswald'),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerAreaBorderRadius: BorderRadius.circular(10),
            pickerColor: tempColor,
            onColorChanged: (Color color) {
              tempColor = color;
            },
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 25.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(color: Colors.yellow[600]!, width: 2),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Отмена",
              style: TextStyle(
                color: themeProvider.isDark
                    ? Colors.yellow[600]!
                    : Colors.black,
                fontFamily: 'Oswald',
                fontSize: 18,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 25.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.yellow,
            ),
            onPressed: () {
              setState(() {
                _textColor = tempColor;
              });
              Navigator.pop(context);
            },
            child: Text(
              "Выбрать",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Oswald',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioWidget(String path, int index) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return AudioPlayerWidget(
      filePath: path,
      audioTitle: _audioTitles.length > index
          ? _audioTitles[index]
          : 'Аудио заметка',
      onTitleChanged: (newTitle) => _updateAudioTitle(index, newTitle),
      onDelete: () => _removeAudioPath(path, index),
      themeProvider: themeProvider,
    );
  }

  void _updateAudioTitle(int index, String newTitle) {
    setState(() {
      if (_audioTitles.length <= index) {
        _audioTitles.addAll(
          List.filled(index - _audioTitles.length + 1, 'Аудио заметка'),
        );
      }
      _audioTitles[index] = newTitle;
    });
  }
}
