// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TaskRecordsTable extends TaskRecords
    with TableInfo<$TaskRecordsTable, TaskRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toolIdMeta = const VerificationMeta('toolId');
  @override
  late final GeneratedColumn<String> toolId = GeneratedColumn<String>(
    'tool_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _inputNameMeta = const VerificationMeta(
    'inputName',
  );
  @override
  late final GeneratedColumn<String> inputName = GeneratedColumn<String>(
    'input_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inputPathMeta = const VerificationMeta(
    'inputPath',
  );
  @override
  late final GeneratedColumn<String> inputPath = GeneratedColumn<String>(
    'input_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inputMimeTypeMeta = const VerificationMeta(
    'inputMimeType',
  );
  @override
  late final GeneratedColumn<String> inputMimeType = GeneratedColumn<String>(
    'input_mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inputSizeBytesMeta = const VerificationMeta(
    'inputSizeBytes',
  );
  @override
  late final GeneratedColumn<int> inputSizeBytes = GeneratedColumn<int>(
    'input_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outputPathMeta = const VerificationMeta(
    'outputPath',
  );
  @override
  late final GeneratedColumn<String> outputPath = GeneratedColumn<String>(
    'output_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outputMimeTypeMeta = const VerificationMeta(
    'outputMimeType',
  );
  @override
  late final GeneratedColumn<String> outputMimeType = GeneratedColumn<String>(
    'output_mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outputSizeBytesMeta = const VerificationMeta(
    'outputSizeBytes',
  );
  @override
  late final GeneratedColumn<int> outputSizeBytes = GeneratedColumn<int>(
    'output_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parametersJsonMeta = const VerificationMeta(
    'parametersJson',
  );
  @override
  late final GeneratedColumn<String> parametersJson = GeneratedColumn<String>(
    'parameters_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorCodeMeta = const VerificationMeta(
    'errorCode',
  );
  @override
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
    'error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ffmpegReturnCodeMeta = const VerificationMeta(
    'ffmpegReturnCode',
  );
  @override
  late final GeneratedColumn<int> ffmpegReturnCode = GeneratedColumn<int>(
    'ffmpeg_return_code',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _logSummaryMeta = const VerificationMeta(
    'logSummary',
  );
  @override
  late final GeneratedColumn<String> logSummary = GeneratedColumn<String>(
    'log_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    toolId,
    status,
    progress,
    inputName,
    inputPath,
    inputMimeType,
    inputSizeBytes,
    outputPath,
    outputMimeType,
    outputSizeBytes,
    parametersJson,
    errorCode,
    errorMessage,
    ffmpegReturnCode,
    logSummary,
    createdAt,
    startedAt,
    completedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tool_id')) {
      context.handle(
        _toolIdMeta,
        toolId.isAcceptableOrUnknown(data['tool_id']!, _toolIdMeta),
      );
    } else if (isInserting) {
      context.missing(_toolIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('input_name')) {
      context.handle(
        _inputNameMeta,
        inputName.isAcceptableOrUnknown(data['input_name']!, _inputNameMeta),
      );
    } else if (isInserting) {
      context.missing(_inputNameMeta);
    }
    if (data.containsKey('input_path')) {
      context.handle(
        _inputPathMeta,
        inputPath.isAcceptableOrUnknown(data['input_path']!, _inputPathMeta),
      );
    }
    if (data.containsKey('input_mime_type')) {
      context.handle(
        _inputMimeTypeMeta,
        inputMimeType.isAcceptableOrUnknown(
          data['input_mime_type']!,
          _inputMimeTypeMeta,
        ),
      );
    }
    if (data.containsKey('input_size_bytes')) {
      context.handle(
        _inputSizeBytesMeta,
        inputSizeBytes.isAcceptableOrUnknown(
          data['input_size_bytes']!,
          _inputSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('output_path')) {
      context.handle(
        _outputPathMeta,
        outputPath.isAcceptableOrUnknown(data['output_path']!, _outputPathMeta),
      );
    }
    if (data.containsKey('output_mime_type')) {
      context.handle(
        _outputMimeTypeMeta,
        outputMimeType.isAcceptableOrUnknown(
          data['output_mime_type']!,
          _outputMimeTypeMeta,
        ),
      );
    }
    if (data.containsKey('output_size_bytes')) {
      context.handle(
        _outputSizeBytesMeta,
        outputSizeBytes.isAcceptableOrUnknown(
          data['output_size_bytes']!,
          _outputSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('parameters_json')) {
      context.handle(
        _parametersJsonMeta,
        parametersJson.isAcceptableOrUnknown(
          data['parameters_json']!,
          _parametersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parametersJsonMeta);
    }
    if (data.containsKey('error_code')) {
      context.handle(
        _errorCodeMeta,
        errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('ffmpeg_return_code')) {
      context.handle(
        _ffmpegReturnCodeMeta,
        ffmpegReturnCode.isAcceptableOrUnknown(
          data['ffmpeg_return_code']!,
          _ffmpegReturnCodeMeta,
        ),
      );
    }
    if (data.containsKey('log_summary')) {
      context.handle(
        _logSummaryMeta,
        logSummary.isAcceptableOrUnknown(data['log_summary']!, _logSummaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      toolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      inputName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_name'],
      )!,
      inputPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_path'],
      ),
      inputMimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_mime_type'],
      ),
      inputSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}input_size_bytes'],
      ),
      outputPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}output_path'],
      ),
      outputMimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}output_mime_type'],
      ),
      outputSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}output_size_bytes'],
      ),
      parametersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parameters_json'],
      )!,
      errorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_code'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      ffmpegReturnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ffmpeg_return_code'],
      ),
      logSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}log_summary'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskRecordsTable createAlias(String alias) {
    return $TaskRecordsTable(attachedDatabase, alias);
  }
}

class TaskRecord extends DataClass implements Insertable<TaskRecord> {
  final String id;
  final String toolId;
  final String status;
  final int progress;
  final String inputName;
  final String? inputPath;
  final String? inputMimeType;
  final int? inputSizeBytes;
  final String? outputPath;
  final String? outputMimeType;
  final int? outputSizeBytes;
  final String parametersJson;
  final String? errorCode;
  final String? errorMessage;
  final int? ffmpegReturnCode;
  final String? logSummary;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime updatedAt;
  const TaskRecord({
    required this.id,
    required this.toolId,
    required this.status,
    required this.progress,
    required this.inputName,
    this.inputPath,
    this.inputMimeType,
    this.inputSizeBytes,
    this.outputPath,
    this.outputMimeType,
    this.outputSizeBytes,
    required this.parametersJson,
    this.errorCode,
    this.errorMessage,
    this.ffmpegReturnCode,
    this.logSummary,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tool_id'] = Variable<String>(toolId);
    map['status'] = Variable<String>(status);
    map['progress'] = Variable<int>(progress);
    map['input_name'] = Variable<String>(inputName);
    if (!nullToAbsent || inputPath != null) {
      map['input_path'] = Variable<String>(inputPath);
    }
    if (!nullToAbsent || inputMimeType != null) {
      map['input_mime_type'] = Variable<String>(inputMimeType);
    }
    if (!nullToAbsent || inputSizeBytes != null) {
      map['input_size_bytes'] = Variable<int>(inputSizeBytes);
    }
    if (!nullToAbsent || outputPath != null) {
      map['output_path'] = Variable<String>(outputPath);
    }
    if (!nullToAbsent || outputMimeType != null) {
      map['output_mime_type'] = Variable<String>(outputMimeType);
    }
    if (!nullToAbsent || outputSizeBytes != null) {
      map['output_size_bytes'] = Variable<int>(outputSizeBytes);
    }
    map['parameters_json'] = Variable<String>(parametersJson);
    if (!nullToAbsent || errorCode != null) {
      map['error_code'] = Variable<String>(errorCode);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || ffmpegReturnCode != null) {
      map['ffmpeg_return_code'] = Variable<int>(ffmpegReturnCode);
    }
    if (!nullToAbsent || logSummary != null) {
      map['log_summary'] = Variable<String>(logSummary);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskRecordsCompanion toCompanion(bool nullToAbsent) {
    return TaskRecordsCompanion(
      id: Value(id),
      toolId: Value(toolId),
      status: Value(status),
      progress: Value(progress),
      inputName: Value(inputName),
      inputPath: inputPath == null && nullToAbsent
          ? const Value.absent()
          : Value(inputPath),
      inputMimeType: inputMimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(inputMimeType),
      inputSizeBytes: inputSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(inputSizeBytes),
      outputPath: outputPath == null && nullToAbsent
          ? const Value.absent()
          : Value(outputPath),
      outputMimeType: outputMimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(outputMimeType),
      outputSizeBytes: outputSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(outputSizeBytes),
      parametersJson: Value(parametersJson),
      errorCode: errorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCode),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      ffmpegReturnCode: ffmpegReturnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(ffmpegReturnCode),
      logSummary: logSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(logSummary),
      createdAt: Value(createdAt),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRecord(
      id: serializer.fromJson<String>(json['id']),
      toolId: serializer.fromJson<String>(json['toolId']),
      status: serializer.fromJson<String>(json['status']),
      progress: serializer.fromJson<int>(json['progress']),
      inputName: serializer.fromJson<String>(json['inputName']),
      inputPath: serializer.fromJson<String?>(json['inputPath']),
      inputMimeType: serializer.fromJson<String?>(json['inputMimeType']),
      inputSizeBytes: serializer.fromJson<int?>(json['inputSizeBytes']),
      outputPath: serializer.fromJson<String?>(json['outputPath']),
      outputMimeType: serializer.fromJson<String?>(json['outputMimeType']),
      outputSizeBytes: serializer.fromJson<int?>(json['outputSizeBytes']),
      parametersJson: serializer.fromJson<String>(json['parametersJson']),
      errorCode: serializer.fromJson<String?>(json['errorCode']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      ffmpegReturnCode: serializer.fromJson<int?>(json['ffmpegReturnCode']),
      logSummary: serializer.fromJson<String?>(json['logSummary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'toolId': serializer.toJson<String>(toolId),
      'status': serializer.toJson<String>(status),
      'progress': serializer.toJson<int>(progress),
      'inputName': serializer.toJson<String>(inputName),
      'inputPath': serializer.toJson<String?>(inputPath),
      'inputMimeType': serializer.toJson<String?>(inputMimeType),
      'inputSizeBytes': serializer.toJson<int?>(inputSizeBytes),
      'outputPath': serializer.toJson<String?>(outputPath),
      'outputMimeType': serializer.toJson<String?>(outputMimeType),
      'outputSizeBytes': serializer.toJson<int?>(outputSizeBytes),
      'parametersJson': serializer.toJson<String>(parametersJson),
      'errorCode': serializer.toJson<String?>(errorCode),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'ffmpegReturnCode': serializer.toJson<int?>(ffmpegReturnCode),
      'logSummary': serializer.toJson<String?>(logSummary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskRecord copyWith({
    String? id,
    String? toolId,
    String? status,
    int? progress,
    String? inputName,
    Value<String?> inputPath = const Value.absent(),
    Value<String?> inputMimeType = const Value.absent(),
    Value<int?> inputSizeBytes = const Value.absent(),
    Value<String?> outputPath = const Value.absent(),
    Value<String?> outputMimeType = const Value.absent(),
    Value<int?> outputSizeBytes = const Value.absent(),
    String? parametersJson,
    Value<String?> errorCode = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    Value<int?> ffmpegReturnCode = const Value.absent(),
    Value<String?> logSummary = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => TaskRecord(
    id: id ?? this.id,
    toolId: toolId ?? this.toolId,
    status: status ?? this.status,
    progress: progress ?? this.progress,
    inputName: inputName ?? this.inputName,
    inputPath: inputPath.present ? inputPath.value : this.inputPath,
    inputMimeType: inputMimeType.present
        ? inputMimeType.value
        : this.inputMimeType,
    inputSizeBytes: inputSizeBytes.present
        ? inputSizeBytes.value
        : this.inputSizeBytes,
    outputPath: outputPath.present ? outputPath.value : this.outputPath,
    outputMimeType: outputMimeType.present
        ? outputMimeType.value
        : this.outputMimeType,
    outputSizeBytes: outputSizeBytes.present
        ? outputSizeBytes.value
        : this.outputSizeBytes,
    parametersJson: parametersJson ?? this.parametersJson,
    errorCode: errorCode.present ? errorCode.value : this.errorCode,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    ffmpegReturnCode: ffmpegReturnCode.present
        ? ffmpegReturnCode.value
        : this.ffmpegReturnCode,
    logSummary: logSummary.present ? logSummary.value : this.logSummary,
    createdAt: createdAt ?? this.createdAt,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskRecord copyWithCompanion(TaskRecordsCompanion data) {
    return TaskRecord(
      id: data.id.present ? data.id.value : this.id,
      toolId: data.toolId.present ? data.toolId.value : this.toolId,
      status: data.status.present ? data.status.value : this.status,
      progress: data.progress.present ? data.progress.value : this.progress,
      inputName: data.inputName.present ? data.inputName.value : this.inputName,
      inputPath: data.inputPath.present ? data.inputPath.value : this.inputPath,
      inputMimeType: data.inputMimeType.present
          ? data.inputMimeType.value
          : this.inputMimeType,
      inputSizeBytes: data.inputSizeBytes.present
          ? data.inputSizeBytes.value
          : this.inputSizeBytes,
      outputPath: data.outputPath.present
          ? data.outputPath.value
          : this.outputPath,
      outputMimeType: data.outputMimeType.present
          ? data.outputMimeType.value
          : this.outputMimeType,
      outputSizeBytes: data.outputSizeBytes.present
          ? data.outputSizeBytes.value
          : this.outputSizeBytes,
      parametersJson: data.parametersJson.present
          ? data.parametersJson.value
          : this.parametersJson,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      ffmpegReturnCode: data.ffmpegReturnCode.present
          ? data.ffmpegReturnCode.value
          : this.ffmpegReturnCode,
      logSummary: data.logSummary.present
          ? data.logSummary.value
          : this.logSummary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecord(')
          ..write('id: $id, ')
          ..write('toolId: $toolId, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('inputName: $inputName, ')
          ..write('inputPath: $inputPath, ')
          ..write('inputMimeType: $inputMimeType, ')
          ..write('inputSizeBytes: $inputSizeBytes, ')
          ..write('outputPath: $outputPath, ')
          ..write('outputMimeType: $outputMimeType, ')
          ..write('outputSizeBytes: $outputSizeBytes, ')
          ..write('parametersJson: $parametersJson, ')
          ..write('errorCode: $errorCode, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('ffmpegReturnCode: $ffmpegReturnCode, ')
          ..write('logSummary: $logSummary, ')
          ..write('createdAt: $createdAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    toolId,
    status,
    progress,
    inputName,
    inputPath,
    inputMimeType,
    inputSizeBytes,
    outputPath,
    outputMimeType,
    outputSizeBytes,
    parametersJson,
    errorCode,
    errorMessage,
    ffmpegReturnCode,
    logSummary,
    createdAt,
    startedAt,
    completedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRecord &&
          other.id == this.id &&
          other.toolId == this.toolId &&
          other.status == this.status &&
          other.progress == this.progress &&
          other.inputName == this.inputName &&
          other.inputPath == this.inputPath &&
          other.inputMimeType == this.inputMimeType &&
          other.inputSizeBytes == this.inputSizeBytes &&
          other.outputPath == this.outputPath &&
          other.outputMimeType == this.outputMimeType &&
          other.outputSizeBytes == this.outputSizeBytes &&
          other.parametersJson == this.parametersJson &&
          other.errorCode == this.errorCode &&
          other.errorMessage == this.errorMessage &&
          other.ffmpegReturnCode == this.ffmpegReturnCode &&
          other.logSummary == this.logSummary &&
          other.createdAt == this.createdAt &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt);
}

class TaskRecordsCompanion extends UpdateCompanion<TaskRecord> {
  final Value<String> id;
  final Value<String> toolId;
  final Value<String> status;
  final Value<int> progress;
  final Value<String> inputName;
  final Value<String?> inputPath;
  final Value<String?> inputMimeType;
  final Value<int?> inputSizeBytes;
  final Value<String?> outputPath;
  final Value<String?> outputMimeType;
  final Value<int?> outputSizeBytes;
  final Value<String> parametersJson;
  final Value<String?> errorCode;
  final Value<String?> errorMessage;
  final Value<int?> ffmpegReturnCode;
  final Value<String?> logSummary;
  final Value<DateTime> createdAt;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskRecordsCompanion({
    this.id = const Value.absent(),
    this.toolId = const Value.absent(),
    this.status = const Value.absent(),
    this.progress = const Value.absent(),
    this.inputName = const Value.absent(),
    this.inputPath = const Value.absent(),
    this.inputMimeType = const Value.absent(),
    this.inputSizeBytes = const Value.absent(),
    this.outputPath = const Value.absent(),
    this.outputMimeType = const Value.absent(),
    this.outputSizeBytes = const Value.absent(),
    this.parametersJson = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.ffmpegReturnCode = const Value.absent(),
    this.logSummary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskRecordsCompanion.insert({
    required String id,
    required String toolId,
    required String status,
    this.progress = const Value.absent(),
    required String inputName,
    this.inputPath = const Value.absent(),
    this.inputMimeType = const Value.absent(),
    this.inputSizeBytes = const Value.absent(),
    this.outputPath = const Value.absent(),
    this.outputMimeType = const Value.absent(),
    this.outputSizeBytes = const Value.absent(),
    required String parametersJson,
    this.errorCode = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.ffmpegReturnCode = const Value.absent(),
    this.logSummary = const Value.absent(),
    required DateTime createdAt,
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       toolId = Value(toolId),
       status = Value(status),
       inputName = Value(inputName),
       parametersJson = Value(parametersJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskRecord> custom({
    Expression<String>? id,
    Expression<String>? toolId,
    Expression<String>? status,
    Expression<int>? progress,
    Expression<String>? inputName,
    Expression<String>? inputPath,
    Expression<String>? inputMimeType,
    Expression<int>? inputSizeBytes,
    Expression<String>? outputPath,
    Expression<String>? outputMimeType,
    Expression<int>? outputSizeBytes,
    Expression<String>? parametersJson,
    Expression<String>? errorCode,
    Expression<String>? errorMessage,
    Expression<int>? ffmpegReturnCode,
    Expression<String>? logSummary,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (toolId != null) 'tool_id': toolId,
      if (status != null) 'status': status,
      if (progress != null) 'progress': progress,
      if (inputName != null) 'input_name': inputName,
      if (inputPath != null) 'input_path': inputPath,
      if (inputMimeType != null) 'input_mime_type': inputMimeType,
      if (inputSizeBytes != null) 'input_size_bytes': inputSizeBytes,
      if (outputPath != null) 'output_path': outputPath,
      if (outputMimeType != null) 'output_mime_type': outputMimeType,
      if (outputSizeBytes != null) 'output_size_bytes': outputSizeBytes,
      if (parametersJson != null) 'parameters_json': parametersJson,
      if (errorCode != null) 'error_code': errorCode,
      if (errorMessage != null) 'error_message': errorMessage,
      if (ffmpegReturnCode != null) 'ffmpeg_return_code': ffmpegReturnCode,
      if (logSummary != null) 'log_summary': logSummary,
      if (createdAt != null) 'created_at': createdAt,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? toolId,
    Value<String>? status,
    Value<int>? progress,
    Value<String>? inputName,
    Value<String?>? inputPath,
    Value<String?>? inputMimeType,
    Value<int?>? inputSizeBytes,
    Value<String?>? outputPath,
    Value<String?>? outputMimeType,
    Value<int?>? outputSizeBytes,
    Value<String>? parametersJson,
    Value<String?>? errorCode,
    Value<String?>? errorMessage,
    Value<int?>? ffmpegReturnCode,
    Value<String?>? logSummary,
    Value<DateTime>? createdAt,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskRecordsCompanion(
      id: id ?? this.id,
      toolId: toolId ?? this.toolId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      inputName: inputName ?? this.inputName,
      inputPath: inputPath ?? this.inputPath,
      inputMimeType: inputMimeType ?? this.inputMimeType,
      inputSizeBytes: inputSizeBytes ?? this.inputSizeBytes,
      outputPath: outputPath ?? this.outputPath,
      outputMimeType: outputMimeType ?? this.outputMimeType,
      outputSizeBytes: outputSizeBytes ?? this.outputSizeBytes,
      parametersJson: parametersJson ?? this.parametersJson,
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
      ffmpegReturnCode: ffmpegReturnCode ?? this.ffmpegReturnCode,
      logSummary: logSummary ?? this.logSummary,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (toolId.present) {
      map['tool_id'] = Variable<String>(toolId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (inputName.present) {
      map['input_name'] = Variable<String>(inputName.value);
    }
    if (inputPath.present) {
      map['input_path'] = Variable<String>(inputPath.value);
    }
    if (inputMimeType.present) {
      map['input_mime_type'] = Variable<String>(inputMimeType.value);
    }
    if (inputSizeBytes.present) {
      map['input_size_bytes'] = Variable<int>(inputSizeBytes.value);
    }
    if (outputPath.present) {
      map['output_path'] = Variable<String>(outputPath.value);
    }
    if (outputMimeType.present) {
      map['output_mime_type'] = Variable<String>(outputMimeType.value);
    }
    if (outputSizeBytes.present) {
      map['output_size_bytes'] = Variable<int>(outputSizeBytes.value);
    }
    if (parametersJson.present) {
      map['parameters_json'] = Variable<String>(parametersJson.value);
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (ffmpegReturnCode.present) {
      map['ffmpeg_return_code'] = Variable<int>(ffmpegReturnCode.value);
    }
    if (logSummary.present) {
      map['log_summary'] = Variable<String>(logSummary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecordsCompanion(')
          ..write('id: $id, ')
          ..write('toolId: $toolId, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('inputName: $inputName, ')
          ..write('inputPath: $inputPath, ')
          ..write('inputMimeType: $inputMimeType, ')
          ..write('inputSizeBytes: $inputSizeBytes, ')
          ..write('outputPath: $outputPath, ')
          ..write('outputMimeType: $outputMimeType, ')
          ..write('outputSizeBytes: $outputSizeBytes, ')
          ..write('parametersJson: $parametersJson, ')
          ..write('errorCode: $errorCode, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('ffmpegReturnCode: $ffmpegReturnCode, ')
          ..write('logSummary: $logSummary, ')
          ..write('createdAt: $createdAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskRecordsTable taskRecords = $TaskRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [taskRecords];
}

typedef $$TaskRecordsTableCreateCompanionBuilder =
    TaskRecordsCompanion Function({
      required String id,
      required String toolId,
      required String status,
      Value<int> progress,
      required String inputName,
      Value<String?> inputPath,
      Value<String?> inputMimeType,
      Value<int?> inputSizeBytes,
      Value<String?> outputPath,
      Value<String?> outputMimeType,
      Value<int?> outputSizeBytes,
      required String parametersJson,
      Value<String?> errorCode,
      Value<String?> errorMessage,
      Value<int?> ffmpegReturnCode,
      Value<String?> logSummary,
      required DateTime createdAt,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TaskRecordsTableUpdateCompanionBuilder =
    TaskRecordsCompanion Function({
      Value<String> id,
      Value<String> toolId,
      Value<String> status,
      Value<int> progress,
      Value<String> inputName,
      Value<String?> inputPath,
      Value<String?> inputMimeType,
      Value<int?> inputSizeBytes,
      Value<String?> outputPath,
      Value<String?> outputMimeType,
      Value<int?> outputSizeBytes,
      Value<String> parametersJson,
      Value<String?> errorCode,
      Value<String?> errorMessage,
      Value<int?> ffmpegReturnCode,
      Value<String?> logSummary,
      Value<DateTime> createdAt,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TaskRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toolId => $composableBuilder(
    column: $table.toolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputName => $composableBuilder(
    column: $table.inputName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputPath => $composableBuilder(
    column: $table.inputPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputMimeType => $composableBuilder(
    column: $table.inputMimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inputSizeBytes => $composableBuilder(
    column: $table.inputSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outputPath => $composableBuilder(
    column: $table.outputPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outputMimeType => $composableBuilder(
    column: $table.outputMimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outputSizeBytes => $composableBuilder(
    column: $table.outputSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parametersJson => $composableBuilder(
    column: $table.parametersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ffmpegReturnCode => $composableBuilder(
    column: $table.ffmpegReturnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logSummary => $composableBuilder(
    column: $table.logSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toolId => $composableBuilder(
    column: $table.toolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputName => $composableBuilder(
    column: $table.inputName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputPath => $composableBuilder(
    column: $table.inputPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputMimeType => $composableBuilder(
    column: $table.inputMimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inputSizeBytes => $composableBuilder(
    column: $table.inputSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outputPath => $composableBuilder(
    column: $table.outputPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outputMimeType => $composableBuilder(
    column: $table.outputMimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outputSizeBytes => $composableBuilder(
    column: $table.outputSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parametersJson => $composableBuilder(
    column: $table.parametersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ffmpegReturnCode => $composableBuilder(
    column: $table.ffmpegReturnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logSummary => $composableBuilder(
    column: $table.logSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get toolId =>
      $composableBuilder(column: $table.toolId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get inputName =>
      $composableBuilder(column: $table.inputName, builder: (column) => column);

  GeneratedColumn<String> get inputPath =>
      $composableBuilder(column: $table.inputPath, builder: (column) => column);

  GeneratedColumn<String> get inputMimeType => $composableBuilder(
    column: $table.inputMimeType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get inputSizeBytes => $composableBuilder(
    column: $table.inputSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outputPath => $composableBuilder(
    column: $table.outputPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outputMimeType => $composableBuilder(
    column: $table.outputMimeType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get outputSizeBytes => $composableBuilder(
    column: $table.outputSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parametersJson => $composableBuilder(
    column: $table.parametersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ffmpegReturnCode => $composableBuilder(
    column: $table.ffmpegReturnCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logSummary => $composableBuilder(
    column: $table.logSummary,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaskRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskRecordsTable,
          TaskRecord,
          $$TaskRecordsTableFilterComposer,
          $$TaskRecordsTableOrderingComposer,
          $$TaskRecordsTableAnnotationComposer,
          $$TaskRecordsTableCreateCompanionBuilder,
          $$TaskRecordsTableUpdateCompanionBuilder,
          (
            TaskRecord,
            BaseReferences<_$AppDatabase, $TaskRecordsTable, TaskRecord>,
          ),
          TaskRecord,
          PrefetchHooks Function()
        > {
  $$TaskRecordsTableTableManager(_$AppDatabase db, $TaskRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> toolId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<String> inputName = const Value.absent(),
                Value<String?> inputPath = const Value.absent(),
                Value<String?> inputMimeType = const Value.absent(),
                Value<int?> inputSizeBytes = const Value.absent(),
                Value<String?> outputPath = const Value.absent(),
                Value<String?> outputMimeType = const Value.absent(),
                Value<int?> outputSizeBytes = const Value.absent(),
                Value<String> parametersJson = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int?> ffmpegReturnCode = const Value.absent(),
                Value<String?> logSummary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskRecordsCompanion(
                id: id,
                toolId: toolId,
                status: status,
                progress: progress,
                inputName: inputName,
                inputPath: inputPath,
                inputMimeType: inputMimeType,
                inputSizeBytes: inputSizeBytes,
                outputPath: outputPath,
                outputMimeType: outputMimeType,
                outputSizeBytes: outputSizeBytes,
                parametersJson: parametersJson,
                errorCode: errorCode,
                errorMessage: errorMessage,
                ffmpegReturnCode: ffmpegReturnCode,
                logSummary: logSummary,
                createdAt: createdAt,
                startedAt: startedAt,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String toolId,
                required String status,
                Value<int> progress = const Value.absent(),
                required String inputName,
                Value<String?> inputPath = const Value.absent(),
                Value<String?> inputMimeType = const Value.absent(),
                Value<int?> inputSizeBytes = const Value.absent(),
                Value<String?> outputPath = const Value.absent(),
                Value<String?> outputMimeType = const Value.absent(),
                Value<int?> outputSizeBytes = const Value.absent(),
                required String parametersJson,
                Value<String?> errorCode = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int?> ffmpegReturnCode = const Value.absent(),
                Value<String?> logSummary = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TaskRecordsCompanion.insert(
                id: id,
                toolId: toolId,
                status: status,
                progress: progress,
                inputName: inputName,
                inputPath: inputPath,
                inputMimeType: inputMimeType,
                inputSizeBytes: inputSizeBytes,
                outputPath: outputPath,
                outputMimeType: outputMimeType,
                outputSizeBytes: outputSizeBytes,
                parametersJson: parametersJson,
                errorCode: errorCode,
                errorMessage: errorMessage,
                ffmpegReturnCode: ffmpegReturnCode,
                logSummary: logSummary,
                createdAt: createdAt,
                startedAt: startedAt,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskRecordsTable,
      TaskRecord,
      $$TaskRecordsTableFilterComposer,
      $$TaskRecordsTableOrderingComposer,
      $$TaskRecordsTableAnnotationComposer,
      $$TaskRecordsTableCreateCompanionBuilder,
      $$TaskRecordsTableUpdateCompanionBuilder,
      (
        TaskRecord,
        BaseReferences<_$AppDatabase, $TaskRecordsTable, TaskRecord>,
      ),
      TaskRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskRecordsTableTableManager get taskRecords =>
      $$TaskRecordsTableTableManager(_db, _db.taskRecords);
}
