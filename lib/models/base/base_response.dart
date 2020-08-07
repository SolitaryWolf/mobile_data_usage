/*
Normal
{
    "data": any,
    "error": null
}
Error
{
    "data": null,
    "error": {
            "code": 1029,
            "message": "User not found!."
        }
}
 */
import 'dart:core';

class BaseResponse<T> {
  BaseResponse(Map<String, dynamic> fullJson) {
    parsing(fullJson);
  }

  T result;
  BaseError error;

  /// Abstract json to data
  T jsonToData(Map<String, dynamic> dataJson) {
    return null;
  }

  /// Abstract data to json
  dynamic dataToJson(T data) {
    return null;
  }

  /// Parsing data to object
  dynamic parsing(Map<String, dynamic> fullJson) {
    if (fullJson != null) {
      result = fullJson['result'] != null
          ? jsonToData(fullJson['result'] as Map<String, dynamic>)
          : null;
      error = fullJson['error'] != null
          ? BaseError.fromJson(fullJson['error'] as Map<String, dynamic>)
          : null;
    }
  }

  /// Data to json
  Map<String, dynamic> toJson() => <String, dynamic>{
        'result': result != null ? dataToJson(result) : null,
        'error': error?.toJson(),
      };
}

class BaseError {
  BaseError({
    this.type,
    this.extras,
  });

  factory BaseError.fromJson(Map<String, dynamic> json) => BaseError(
        type: json['type'] as String,
    extras: json['extras'] as List,
      );

  String type;
  List<String> extras;

  Map<String, dynamic> toJson() => <String, dynamic>{
        '__type': type,
        '__extras': extras,
      };
}
