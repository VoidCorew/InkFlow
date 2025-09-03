// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaveNoteAdapter extends TypeAdapter<SaveNote> {
  @override
  final int typeId = 0;

  @override
  SaveNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveNote(
      title: fields[0] as String,
      content: fields[1] as String,
      folderId: fields[2] as int?,
      backgroundImagePath: fields[3] as String?,
      textColorValue: fields[4] as int?,
      backgroundColorValue: fields[5] as int?,
      audioNotes: (fields[6] as List?)?.cast<String>(),
      audioTitles: (fields[7] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SaveNote obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.folderId)
      ..writeByte(3)
      ..write(obj.backgroundImagePath)
      ..writeByte(4)
      ..write(obj.textColorValue)
      ..writeByte(5)
      ..write(obj.backgroundColorValue)
      ..writeByte(6)
      ..write(obj.audioNotes)
      ..writeByte(7)
      ..write(obj.audioTitles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
