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
import 'package:spot_server/src/generated/protocol.dart' as _iz0kuq56;
import '../events/event.dart' as _inam5zsn;

/// An event as seen by the signed-in user, with computed fields.
abstract class EventView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  EventView._({
    required this.event,
    this.distanceKm,
    int? attendeeCount,
    int? spotsLeft,
    bool? joinedByMe,
    bool? hostedByMe,
  }) : attendeeCount = attendeeCount ?? 0,
       spotsLeft = spotsLeft ?? 0,
       joinedByMe = joinedByMe ?? false,
       hostedByMe = hostedByMe ?? false;

  factory EventView({
    required _inam5zsn.Event event,
    double? distanceKm,
    int? attendeeCount,
    int? spotsLeft,
    bool? joinedByMe,
    bool? hostedByMe,
  }) = _EventViewImpl;

  factory EventView.fromJson(Map<String, dynamic> jsonSerialization) {
    return EventView(
      event: _iz0kuq56.Protocol().deserialize<_inam5zsn.Event>(
        jsonSerialization['event'],
      ),
      distanceKm: (jsonSerialization['distanceKm'] as num?)?.toDouble(),
      attendeeCount: jsonSerialization['attendeeCount'] as int?,
      spotsLeft: jsonSerialization['spotsLeft'] as int?,
      joinedByMe: jsonSerialization['joinedByMe'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['joinedByMe']),
      hostedByMe: jsonSerialization['hostedByMe'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['hostedByMe']),
    );
  }

  _inam5zsn.Event event;

  /// Distance from the point the user searched from, if one was given.
  double? distanceKm;

  int attendeeCount;

  int spotsLeft;

  bool joinedByMe;

  bool hostedByMe;

  /// Returns a shallow copy of this [EventView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EventView copyWith({
    _inam5zsn.Event? event,
    double? distanceKm,
    int? attendeeCount,
    int? spotsLeft,
    bool? joinedByMe,
    bool? hostedByMe,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EventView',
      'event': event.toJson(),
      if (distanceKm != null) 'distanceKm': distanceKm,
      'attendeeCount': attendeeCount,
      'spotsLeft': spotsLeft,
      'joinedByMe': joinedByMe,
      'hostedByMe': hostedByMe,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EventView',
      'event': event.toJsonForProtocol(),
      if (distanceKm != null) 'distanceKm': distanceKm,
      'attendeeCount': attendeeCount,
      'spotsLeft': spotsLeft,
      'joinedByMe': joinedByMe,
      'hostedByMe': hostedByMe,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EventViewImpl extends EventView {
  _EventViewImpl({
    required _inam5zsn.Event event,
    double? distanceKm,
    int? attendeeCount,
    int? spotsLeft,
    bool? joinedByMe,
    bool? hostedByMe,
  }) : super._(
         event: event,
         distanceKm: distanceKm,
         attendeeCount: attendeeCount,
         spotsLeft: spotsLeft,
         joinedByMe: joinedByMe,
         hostedByMe: hostedByMe,
       );

  /// Returns a shallow copy of this [EventView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EventView copyWith({
    _inam5zsn.Event? event,
    Object? distanceKm = _Undefined,
    int? attendeeCount,
    int? spotsLeft,
    bool? joinedByMe,
    bool? hostedByMe,
  }) {
    return EventView(
      event: event ?? this.event.copyWith(),
      distanceKm: distanceKm is double? ? distanceKm : this.distanceKm,
      attendeeCount: attendeeCount ?? this.attendeeCount,
      spotsLeft: spotsLeft ?? this.spotsLeft,
      joinedByMe: joinedByMe ?? this.joinedByMe,
      hostedByMe: hostedByMe ?? this.hostedByMe,
    );
  }
}
