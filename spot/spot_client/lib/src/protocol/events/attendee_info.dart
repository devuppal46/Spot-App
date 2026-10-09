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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// An attendee as shown to the host.
abstract class AttendeeInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AttendeeInfo._({
    required this.userId,
    required this.name,
    required this.joinedAt,
  });

  factory AttendeeInfo({
    required _isc.UuidValue userId,
    required String name,
    required DateTime joinedAt,
  }) = _AttendeeInfoImpl;

  factory AttendeeInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AttendeeInfo(
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      name: jsonSerialization['name'] as String,
      joinedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['joinedAt'],
      ),
    );
  }

  _isc.UuidValue userId;

  String name;

  DateTime joinedAt;

  /// Returns a shallow copy of this [AttendeeInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AttendeeInfo copyWith({
    _isc.UuidValue? userId,
    String? name,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AttendeeInfo',
      'userId': userId.toJson(),
      'name': name,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AttendeeInfo',
      'userId': userId.toJson(),
      'name': name,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AttendeeInfoImpl extends AttendeeInfo {
  _AttendeeInfoImpl({
    required _isc.UuidValue userId,
    required String name,
    required DateTime joinedAt,
  }) : super._(
         userId: userId,
         name: name,
         joinedAt: joinedAt,
       );

  /// Returns a shallow copy of this [AttendeeInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AttendeeInfo copyWith({
    _isc.UuidValue? userId,
    String? name,
    DateTime? joinedAt,
  }) {
    return AttendeeInfo(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
