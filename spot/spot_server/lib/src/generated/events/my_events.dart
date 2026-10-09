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
import '../events/event_view.dart' as _inqcqig8;

/// The signed-in user's events, for the My Events screen.
abstract class MyEvents
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MyEvents._({
    required this.hosting,
    required this.joined,
  });

  factory MyEvents({
    required List<_inqcqig8.EventView> hosting,
    required List<_inqcqig8.EventView> joined,
  }) = _MyEventsImpl;

  factory MyEvents.fromJson(Map<String, dynamic> jsonSerialization) {
    return MyEvents(
      hosting: _iz0kuq56.Protocol().deserialize<List<_inqcqig8.EventView>>(
        jsonSerialization['hosting'],
      ),
      joined: _iz0kuq56.Protocol().deserialize<List<_inqcqig8.EventView>>(
        jsonSerialization['joined'],
      ),
    );
  }

  List<_inqcqig8.EventView> hosting;

  List<_inqcqig8.EventView> joined;

  /// Returns a shallow copy of this [MyEvents]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MyEvents copyWith({
    List<_inqcqig8.EventView>? hosting,
    List<_inqcqig8.EventView>? joined,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MyEvents',
      'hosting': hosting.toJson(valueToJson: (v) => v.toJson()),
      'joined': joined.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MyEvents',
      'hosting': hosting.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'joined': joined.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _MyEventsImpl extends MyEvents {
  _MyEventsImpl({
    required List<_inqcqig8.EventView> hosting,
    required List<_inqcqig8.EventView> joined,
  }) : super._(
         hosting: hosting,
         joined: joined,
       );

  /// Returns a shallow copy of this [MyEvents]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MyEvents copyWith({
    List<_inqcqig8.EventView>? hosting,
    List<_inqcqig8.EventView>? joined,
  }) {
    return MyEvents(
      hosting: hosting ?? this.hosting.map((e0) => e0.copyWith()).toList(),
      joined: joined ?? this.joined.map((e0) => e0.copyWith()).toList(),
    );
  }
}
