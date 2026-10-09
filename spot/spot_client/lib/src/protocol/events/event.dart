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
import '../events/event_category.dart' as _i2sr3i4w;
import '../events/event_status.dart' as _i9wy1wkl;

/// An in-person event hosted by a user somewhere in Delhi.
abstract class Event
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Event._({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startsAt,
    required this.lat,
    required this.lng,
    required this.locationName,
    required this.capacity,
    required this.hostId,
    required this.hostName,
    _i9wy1wkl.EventStatus? status,
    DateTime? createdAt,
  }) : status = status ?? _i9wy1wkl.EventStatus.open,
       createdAt = createdAt ?? DateTime.now();

  factory Event({
    int? id,
    required String title,
    required String description,
    required _i2sr3i4w.EventCategory category,
    required DateTime startsAt,
    required double lat,
    required double lng,
    required String locationName,
    required int capacity,
    required _isc.UuidValue hostId,
    required String hostName,
    _i9wy1wkl.EventStatus? status,
    DateTime? createdAt,
  }) = _EventImpl;

  factory Event.fromJson(Map<String, dynamic> jsonSerialization) {
    return Event(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: _i2sr3i4w.EventCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      startsAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startsAt'],
      ),
      lat: (jsonSerialization['lat'] as num).toDouble(),
      lng: (jsonSerialization['lng'] as num).toDouble(),
      locationName: jsonSerialization['locationName'] as String,
      capacity: jsonSerialization['capacity'] as int,
      hostId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['hostId']),
      hostName: jsonSerialization['hostName'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _i9wy1wkl.EventStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String description;

  _i2sr3i4w.EventCategory category;

  /// When the event starts (UTC).
  DateTime startsAt;

  double lat;

  double lng;

  /// Human readable place, e.g. "Hauz Khas Social, Hauz Khas Village".
  String locationName;

  /// Maximum number of attendees, not counting the host.
  int capacity;

  /// The auth user id of the host.
  _isc.UuidValue hostId;

  /// Display name of the host, captured when the event is created.
  String hostName;

  _i9wy1wkl.EventStatus status;

  DateTime createdAt;

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Event copyWith({
    int? id,
    String? title,
    String? description,
    _i2sr3i4w.EventCategory? category,
    DateTime? startsAt,
    double? lat,
    double? lng,
    String? locationName,
    int? capacity,
    _isc.UuidValue? hostId,
    String? hostName,
    _i9wy1wkl.EventStatus? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Event',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category': category.toJson(),
      'startsAt': startsAt.toJson(),
      'lat': lat,
      'lng': lng,
      'locationName': locationName,
      'capacity': capacity,
      'hostId': hostId.toJson(),
      'hostName': hostName,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Event',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category': category.toJson(),
      'startsAt': startsAt.toJson(),
      'lat': lat,
      'lng': lng,
      'locationName': locationName,
      'capacity': capacity,
      'hostId': hostId.toJson(),
      'hostName': hostName,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EventImpl extends Event {
  _EventImpl({
    int? id,
    required String title,
    required String description,
    required _i2sr3i4w.EventCategory category,
    required DateTime startsAt,
    required double lat,
    required double lng,
    required String locationName,
    required int capacity,
    required _isc.UuidValue hostId,
    required String hostName,
    _i9wy1wkl.EventStatus? status,
    DateTime? createdAt,
  }) : super._(
         id: id,
         title: title,
         description: description,
         category: category,
         startsAt: startsAt,
         lat: lat,
         lng: lng,
         locationName: locationName,
         capacity: capacity,
         hostId: hostId,
         hostName: hostName,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Event copyWith({
    Object? id = _Undefined,
    String? title,
    String? description,
    _i2sr3i4w.EventCategory? category,
    DateTime? startsAt,
    double? lat,
    double? lng,
    String? locationName,
    int? capacity,
    _isc.UuidValue? hostId,
    String? hostName,
    _i9wy1wkl.EventStatus? status,
    DateTime? createdAt,
  }) {
    return Event(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startsAt: startsAt ?? this.startsAt,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      locationName: locationName ?? this.locationName,
      capacity: capacity ?? this.capacity,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
