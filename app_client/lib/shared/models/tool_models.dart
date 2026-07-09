enum MediaKind { video, audio, image }

enum InputSource { photoLibrary, filePicker }

enum OutputTarget { appResult }

enum TaskStatus { queued, running, succeeded, failed, cancelled }

enum TaskErrorCode {
  permissionDenied,
  inputNotFound,
  unsupportedFormat,
  insufficientStorage,
  ffmpegFailed,
  cancelled,
  openFailed,
  shareFailed,
  unknown,
}

class ToolDefinition {
  const ToolDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.acceptedInputs,
    required this.supportedInputExtensions,
    required this.supportedInputMimeTypes,
    required this.outputFormats,
    required this.defaultOutputFormat,
    required this.defaultPresetId,
    required this.presets,
    required this.parameterSchema,
    required this.allowMultipleInputs,
    required this.isMvp,
    required this.tags,
  });

  final String id;
  final String title;
  final String description;
  final MediaKind category;
  final List<MediaKind> acceptedInputs;
  final List<String> supportedInputExtensions;
  final List<String> supportedInputMimeTypes;
  final List<String> outputFormats;
  final String defaultOutputFormat;
  final String defaultPresetId;
  final List<ToolPreset> presets;
  final ToolParameterSchema parameterSchema;
  final bool allowMultipleInputs;
  final bool isMvp;
  final List<String> tags;
}

class ToolPreset {
  const ToolPreset({
    required this.id,
    required this.title,
    required this.outputExtension,
    required this.parameters,
  });

  final String id;
  final String title;
  final String outputExtension;
  final Map<String, Object?> parameters;
}

class ToolParameterSchema {
  const ToolParameterSchema({this.fields = const []});

  final List<ToolParameterField> fields;
}

class ToolParameterField {
  const ToolParameterField({
    required this.key,
    required this.label,
    required this.type,
    this.options = const [],
  });

  final String key;
  final String label;
  final ToolParameterType type;
  final List<String> options;
}

enum ToolParameterType { choice, number, toggle }
