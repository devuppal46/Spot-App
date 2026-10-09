/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// A user-facing error, e.g. "This event is full". The message is safe to show.
abstract class SpotException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  SpotException._({required this.message});

  factory SpotException({required String message}) = _SpotExceptionImpl;

  factory SpotException.fromJson(Map<String, dynamic> jsonSerialization) {
    return SpotException(message: jsonSerialization['message'] as String);
  }

  String message;

  /// Returns a shallow copy of this [SpotException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SpotException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SpotException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SpotException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'SpotException(message: $message)';
  }
}

class _SpotExceptionImpl extends SpotException {
  _SpotExceptionImpl({required String message}) : super._(message: message);

  /// Returns a shallow copy of this [SpotException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SpotException copyWith({String? message}) {
    return SpotException(message: message ?? this.message);
  }
}
