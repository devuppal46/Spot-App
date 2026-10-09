/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:spot_server/src/generated/protocol.dart' as _iz0kuq56;
import '../events/event.dart' as _inam5zsn;

/// A user's spot at an event. One row per (event, user).
abstract class Attendance
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _is.UuidValue userId,
    DateTime? joinedAt,
  }) = _AttendanceImpl;

  factory Attendance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attendance(
      id: jsonSerialization['id'] as int?,
      eventId: jsonSerialization['eventId'] as int,
      event: jsonSerialization['event'] == null
          ? null
          : _iz0kuq56.Protocol().deserialize<_inam5zsn.Event>(
              jsonSerialization['event'],
            ),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  static final t = AttendanceTable();

  static const db = AttendanceRepository._();

  @override
  int? id;

  int eventId;

  _inam5zsn.Event? event;

  /// The auth user id of the attendee.
  _is.UuidValue userId;

  DateTime joinedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Attendance copyWith({
    int? id,
    int? eventId,
    _inam5zsn.Event? event,
    _is.UuidValue? userId,
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

  static AttendanceInclude include({_inam5zsn.EventInclude? event}) {
    return AttendanceInclude._(event: event);
  }

  static AttendanceIncludeList includeList({
    _is.WhereExpressionBuilder<AttendanceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AttendanceTable>? orderBy,
    _is.OrderByListBuilder<AttendanceTable>? orderByList,
    AttendanceInclude? include,
  }) {
    return AttendanceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttendanceImpl extends Attendance {
  _AttendanceImpl({
    int? id,
    required int eventId,
    _inam5zsn.Event? event,
    required _is.UuidValue userId,
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
  @_is.useResult
  @override
  Attendance copyWith({
    Object? id = _Undefined,
    int? eventId,
    Object? event = _Undefined,
    _is.UuidValue? userId,
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

class AttendanceUpdateTable extends _is.UpdateTable<AttendanceTable> {
  AttendanceUpdateTable(super.table);

  _is.ColumnValue<int, int> eventId(int value) => _is.ColumnValue(
    table.eventId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> joinedAt(DateTime value) =>
      _is.ColumnValue(
        table.joinedAt,
        value,
      );
}

class AttendanceTable extends _is.Table<int?> {
  AttendanceTable({super.tableRelation}) : super(tableName: 'attendance') {
    updateTable = AttendanceUpdateTable(this);
    eventId = _is.ColumnInt(
      'eventId',
      this,
    );
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    joinedAt = _is.ColumnDateTime(
      'joinedAt',
      this,
      hasDefault: true,
    );
  }

  late final AttendanceUpdateTable updateTable;

  late final _is.ColumnInt eventId;

  _inam5zsn.EventTable? _event;

  /// The auth user id of the attendee.
  late final _is.ColumnUuid userId;

  late final _is.ColumnDateTime joinedAt;

  _inam5zsn.EventTable get event {
    if (_event != null) return _event!;
    _event = _is.createRelationTable(
      relationFieldName: 'event',
      field: Attendance.t.eventId,
      foreignField: _inam5zsn.Event.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _inam5zsn.EventTable(tableRelation: foreignTableRelation),
    );
    return _event!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    eventId,
    userId,
    joinedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'event') {
      return event;
    }
    return null;
  }
}

class AttendanceInclude extends _is.IncludeObject {
  AttendanceInclude._({_inam5zsn.EventInclude? event}) {
    _event = event;
  }

  _inam5zsn.EventInclude? _event;

  @override
  Map<String, _is.Include?> get includes => {'event': _event};

  @override
  _is.Table<int?> get table => Attendance.t;
}

class AttendanceIncludeList extends _is.IncludeList {
  AttendanceIncludeList._({
    _is.WhereExpressionBuilder<AttendanceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Attendance.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Attendance.t;
}

class AttendanceRepository {
  const AttendanceRepository._();

  final attachRow = const AttendanceAttachRowRepository._();

  /// Returns a list of [Attendance]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Attendance>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AttendanceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AttendanceTable>? orderBy,
    _is.OrderByListBuilder<AttendanceTable>? orderByList,
    _is.Transaction? transaction,
    AttendanceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Attendance>(
      where: where?.call(Attendance.t),
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Attendance] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Attendance?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AttendanceTable>? where,
    int? offset,
    _is.OrderByBuilder<AttendanceTable>? orderBy,
    _is.OrderByListBuilder<AttendanceTable>? orderByList,
    _is.Transaction? transaction,
    AttendanceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Attendance>(
      where: where?.call(Attendance.t),
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Attendance] by its [id] or null if no such row exists.
  Future<Attendance?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    AttendanceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Attendance>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Attendance]s in the list and returns the inserted rows.
  ///
  /// The returned [Attendance]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Attendance>> insert(
    _is.DatabaseSession session,
    List<Attendance> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Attendance>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Attendance] and returns the inserted row.
  ///
  /// The returned [Attendance] will have its `id` field set.
  Future<Attendance> insertRow(
    _is.DatabaseSession session,
    Attendance row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Attendance>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Attendance]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Attendance]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Attendance>> upsert(
    _is.DatabaseSession session,
    List<Attendance> rows, {
    required _is.ColumnSelections<AttendanceTable> conflictColumns,
    _is.ColumnSelections<AttendanceTable>? updateColumns,
    _is.WhereExpressionBuilder<AttendanceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Attendance>(
      rows,
      conflictColumns: conflictColumns(Attendance.t),
      updateColumns: updateColumns?.call(Attendance.t),
      updateWhere: updateWhere?.call(Attendance.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Attendance] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Attendance] will have its `id` field set.
  Future<Attendance?> upsertRow(
    _is.DatabaseSession session,
    Attendance row, {
    required _is.ColumnSelections<AttendanceTable> conflictColumns,
    _is.ColumnSelections<AttendanceTable>? updateColumns,
    _is.WhereExpressionBuilder<AttendanceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Attendance>(
      row,
      conflictColumns: conflictColumns(Attendance.t),
      updateColumns: updateColumns?.call(Attendance.t),
      updateWhere: updateWhere?.call(Attendance.t),
      transaction: transaction,
    );
  }

  /// Updates all [Attendance]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Attendance>> update(
    _is.DatabaseSession session,
    List<Attendance> rows, {
    _is.ColumnSelections<AttendanceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Attendance>(
      rows,
      columns: columns?.call(Attendance.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Attendance]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Attendance> updateRow(
    _is.DatabaseSession session,
    Attendance row, {
    _is.ColumnSelections<AttendanceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Attendance>(
      row,
      columns: columns?.call(Attendance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Attendance] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Attendance?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AttendanceUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Attendance>(
      id,
      columnValues: columnValues(Attendance.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Attendance]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Attendance>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AttendanceUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AttendanceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AttendanceTable>? orderBy,
    _is.OrderByListBuilder<AttendanceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Attendance>(
      columnValues: columnValues(Attendance.t.updateTable),
      where: where(Attendance.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Attendance]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Attendance>> delete(
    _is.DatabaseSession session,
    List<Attendance> rows, {
    _is.OrderByBuilder<AttendanceTable>? orderBy,
    _is.OrderByListBuilder<AttendanceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Attendance>(
      rows,
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Attendance].
  Future<Attendance> deleteRow(
    _is.DatabaseSession session,
    Attendance row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Attendance>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Attendance>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AttendanceTable> where,
    _is.OrderByBuilder<AttendanceTable>? orderBy,
    _is.OrderByListBuilder<AttendanceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Attendance>(
      where: where(Attendance.t),
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AttendanceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Attendance>(
      where: where?.call(Attendance.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Attendance] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AttendanceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Attendance>(
      where: where(Attendance.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AttendanceAttachRowRepository {
  const AttendanceAttachRowRepository._();

  /// Creates a relation between the given [Attendance] and [Event]
  /// by setting the [Attendance]'s foreign key `eventId` to refer to the [Event].
  Future<void> event(
    _is.DatabaseSession session,
    Attendance attendance,
    _inam5zsn.Event event, {
    _is.Transaction? transaction,
  }) async {
    if (attendance.id == null) {
      throw ArgumentError.notNull('attendance.id');
    }
    if (event.id == null) {
      throw ArgumentError.notNull('event.id');
    }

    var $attendance = attendance.copyWith(eventId: event.id);
    await session.db.updateRow<Attendance>(
      $attendance,
      columns: [Attendance.t.eventId],
      transaction: transaction,
    );
  }
}
