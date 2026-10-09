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
import 'package:spot_client/src/protocol/protocol.dart' as _i9r0gd8y;
import '../events/event.dart' as _inam5zsn;

/// A user's spot at an event. One row per (event, user).
abstract class Attendance
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Attendance._({
    this.id,
    required this.eventId,
    this.event,
    required this.userId,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  factory Attendance({
    int? id,
    required int eventId,
    _inam5zsn.Event? event,
    required _isc.UuidValue userId,
    DateTime? joinedAt,
  }) = _AttendanceImpl;

  factory Attendance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attendance(
      id: jsonSerialization['id'] as int?,
      eventId: jsonSerialization['eventId'] as int,
      event: jsonSerialization['event'] == null
          ? null
          : _i9r0gd8y.Protocol().deserialize<_inam5zsn.Event>(
              jsonSerialization['event'],
            ),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int eventId;

  _inam5zsn.Event? event;

  /// The auth user id of the attendee.
  _isc.UuidValue userId;

  DateTime joinedAt;

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Attendance copyWith({
    int? id,
    int? eventId,
    _inam5zsn.Event? event,
    _isc.UuidValue? userId,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Attendance',
      if (id != null) 'id': id,
      'eventId': eventId,
      if (event != null) 'event': event?.toJson(),
      'userId': userId.toJson(),
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Attendance',
      if (id != null) 'id': id,
      'eventId': eventId,
      if (event != null) 'event': event?.toJsonForProtocol(),
      'userId': userId.toJson(),
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttendanceImpl extends Attendance {
  _AttendanceImpl({
    int? id,
    required int eventId,
    _inam5zsn.Event? event,
    required _isc.UuidValue userId,
    DateTime? joinedAt,
  }) : super._(
         id: id,
         eventId: eventId,
         event: event,
         userId: userId,
         joinedAt: joinedAt,
       );

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Attendance copyWith({
    Object? id = _Undefined,
    int? eventId,
    Object? event = _Undefined,
    _isc.UuidValue? userId,
    DateTime? joinedAt,
  }) {
    return Attendance(
      id: id is int? ? id : this.id,
      eventId: eventId ?? this.eventId,
      event: event is _inam5zsn.Event? ? event : this.event?.copyWith(),
      userId: userId ?? this.userId,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
