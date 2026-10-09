/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:spot_client/src/protocol/events/attendee_info.dart'
    as _iwsfrmro;
import 'package:spot_client/src/protocol/events/event_view.dart' as _i3bbmftp;
import 'events/attendance.dart' as _iczw3yzu;
import 'events/attendee_info.dart' as _iqln0nk3;
import 'events/event.dart' as _iq09ghc5;
import 'events/event_category.dart' as _in056s28;
import 'events/event_status.dart' as _i4t7xmt2;
import 'events/event_view.dart' as _ic787h5w;
import 'events/my_events.dart' as _ijf0i36m;
import 'events/spot_exception.dart' as _io62tu0j;
export 'events/attendance.dart';
export 'events/attendee_info.dart';
export 'events/event.dart';
export 'events/event_category.dart';
export 'events/event_status.dart';
export 'events/event_view.dart';
export 'events/my_events.dart';
export 'events/spot_exception.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iczw3yzu.Attendance) {
      return _iczw3yzu.Attendance.fromJson(data) as T;
    }
    if (t == _iqln0nk3.AttendeeInfo) {
      return _iqln0nk3.AttendeeInfo.fromJson(data) as T;
    }
    if (t == _iq09ghc5.Event) {
      return _iq09ghc5.Event.fromJson(data) as T;
    }
    if (t == _in056s28.EventCategory) {
      return _in056s28.EventCategory.fromJson(data) as T;
    }
    if (t == _i4t7xmt2.EventStatus) {
      return _i4t7xmt2.EventStatus.fromJson(data) as T;
    }
    if (t == _ic787h5w.EventView) {
      return _ic787h5w.EventView.fromJson(data) as T;
    }
    if (t == _ijf0i36m.MyEvents) {
      return _ijf0i36m.MyEvents.fromJson(data) as T;
    }
    if (t == _io62tu0j.SpotException) {
      return _io62tu0j.SpotException.fromJson(data) as T;
    }
    if (t == _isc.getType<_iczw3yzu.Attendance?>()) {
      return (data != null ? _iczw3yzu.Attendance.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iqln0nk3.AttendeeInfo?>()) {
      return (data != null ? _iqln0nk3.AttendeeInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iq09ghc5.Event?>()) {
      return (data != null ? _iq09ghc5.Event.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_in056s28.EventCategory?>()) {
      return (data != null ? _in056s28.EventCategory.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4t7xmt2.EventStatus?>()) {
      return (data != null ? _i4t7xmt2.EventStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ic787h5w.EventView?>()) {
      return (data != null ? _ic787h5w.EventView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ijf0i36m.MyEvents?>()) {
      return (data != null ? _ijf0i36m.MyEvents.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_io62tu0j.SpotException?>()) {
      return (data != null ? _io62tu0j.SpotException.fromJson(data) : null)
          as T;
    }
    if (t == List<_ic787h5w.EventView>) {
      return (data as List)
              .map((e) => deserialize<_ic787h5w.EventView>(e))
              .toList()
          as T;
    }
    if (t == List<_i3bbmftp.EventView>) {
      return (data as List)
              .map((e) => deserialize<_i3bbmftp.EventView>(e))
              .toList()
          as T;
    }
    if (t == List<_iwsfrmro.AttendeeInfo>) {
      return (data as List)
              .map((e) => deserialize<_iwsfrmro.AttendeeInfo>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iczw3yzu.Attendance => 'Attendance',
      _iqln0nk3.AttendeeInfo => 'AttendeeInfo',
      _iq09ghc5.Event => 'Event',
      _in056s28.EventCategory => 'EventCategory',
      _i4t7xmt2.EventStatus => 'EventStatus',
      _ic787h5w.EventView => 'EventView',
      _ijf0i36m.MyEvents => 'MyEvents',
      _io62tu0j.SpotException => 'SpotException',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('spot.', '');
    }

    switch (data) {
      case _iczw3yzu.Attendance():
        return 'Attendance';
      case _iqln0nk3.AttendeeInfo():
        return 'AttendeeInfo';
      case _iq09ghc5.Event():
        return 'Event';
      case _in056s28.EventCategory():
        return 'EventCategory';
      case _i4t7xmt2.EventStatus():
        return 'EventStatus';
      case _ic787h5w.EventView():
        return 'EventView';
      case _ijf0i36m.MyEvents():
        return 'MyEvents';
      case _io62tu0j.SpotException():
        return 'SpotException';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Attendance') {
      return deserialize<_iczw3yzu.Attendance>(data['data']);
    }
    if (dataClassName == 'AttendeeInfo') {
      return deserialize<_iqln0nk3.AttendeeInfo>(data['data']);
    }
    if (dataClassName == 'Event') {
      return deserialize<_iq09ghc5.Event>(data['data']);
    }
    if (dataClassName == 'EventCategory') {
      return deserialize<_in056s28.EventCategory>(data['data']);
    }
    if (dataClassName == 'EventStatus') {
      return deserialize<_i4t7xmt2.EventStatus>(data['data']);
    }
    if (dataClassName == 'EventView') {
      return deserialize<_ic787h5w.EventView>(data['data']);
    }
    if (dataClassName == 'MyEvents') {
      return deserialize<_ijf0i36m.MyEvents>(data['data']);
    }
    if (dataClassName == 'SpotException') {
      return deserialize<_io62tu0j.SpotException>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('spot', this);
    _iacc.Protocol().registerHostProtocol('spot', this);
  }

  @override
  String getModuleName() => 'spot';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
