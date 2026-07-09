// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class TaskRecordAdapter extends TypeAdapter<TaskRecord> {
  @override
  final typeId = 32;

  @override
  TaskRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskRecord(
      id: fields[0] as String,
      toolId: fields[1] as String,
      status: fields[2] as TaskStatus,
      progress: (fields[3] as num).toInt(),
      inputName: fields[4] as String,
      createdAt: fields[13] as DateTime,
      inputPath: fields[5] as String?,
      outputPath: fields[6] as String?,
      outputMimeType: fields[7] as String?,
      outputSizeBytes: (fields[8] as num?)?.toInt(),
      errorCode: fields[9] as String?,
      errorMessage: fields[10] as String?,
      ffmpegReturnCode: (fields[11] as num?)?.toInt(),
      logSummary: fields[12] as String?,
      startedAt: fields[14] as DateTime?,
      completedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskRecord obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.toolId)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.progress)
      ..writeByte(4)
      ..write(obj.inputName)
      ..writeByte(5)
      ..write(obj.inputPath)
      ..writeByte(6)
      ..write(obj.outputPath)
      ..writeByte(7)
      ..write(obj.outputMimeType)
      ..writeByte(8)
      ..write(obj.outputSizeBytes)
      ..writeByte(9)
      ..write(obj.errorCode)
      ..writeByte(10)
      ..write(obj.errorMessage)
      ..writeByte(11)
      ..write(obj.ffmpegReturnCode)
      ..writeByte(12)
      ..write(obj.logSummary)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.startedAt)
      ..writeByte(15)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final typeId = 33;

  @override
  TaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskStatus.queued;
      case 1:
        return TaskStatus.running;
      case 2:
        return TaskStatus.succeeded;
      case 3:
        return TaskStatus.failed;
      case 4:
        return TaskStatus.cancelled;
      default:
        return TaskStatus.queued;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.queued:
        writer.writeByte(0);
      case TaskStatus.running:
        writer.writeByte(1);
      case TaskStatus.succeeded:
        writer.writeByte(2);
      case TaskStatus.failed:
        writer.writeByte(3);
      case TaskStatus.cancelled:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
