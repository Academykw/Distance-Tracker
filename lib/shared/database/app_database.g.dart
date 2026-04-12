// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalMetersMeta = const VerificationMeta(
    'totalMeters',
  );
  @override
  late final GeneratedColumn<double> totalMeters = GeneratedColumn<double>(
    'total_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _activityTypeMeta = const VerificationMeta(
    'activityType',
  );
  @override
  late final GeneratedColumn<String> activityType = GeneratedColumn<String>(
    'activity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startTime,
    endTime,
    totalMeters,
    activityType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('total_meters')) {
      context.handle(
        _totalMetersMeta,
        totalMeters.isAcceptableOrUnknown(
          data['total_meters']!,
          _totalMetersMeta,
        ),
      );
    }
    if (data.containsKey('activity_type')) {
      context.handle(
        _activityTypeMeta,
        activityType.isAcceptableOrUnknown(
          data['activity_type']!,
          _activityTypeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      totalMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_meters'],
      )!,
      activityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_type'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final String id;
  final String startTime;
  final String? endTime;
  final double totalMeters;
  final String activityType;
  const Session({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.totalMeters,
    required this.activityType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['start_time'] = Variable<String>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    map['total_meters'] = Variable<double>(totalMeters);
    map['activity_type'] = Variable<String>(activityType);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      totalMeters: Value(totalMeters),
      activityType: Value(activityType),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      totalMeters: serializer.fromJson<double>(json['totalMeters']),
      activityType: serializer.fromJson<String>(json['activityType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'totalMeters': serializer.toJson<double>(totalMeters),
      'activityType': serializer.toJson<String>(activityType),
    };
  }

  Session copyWith({
    String? id,
    String? startTime,
    Value<String?> endTime = const Value.absent(),
    double? totalMeters,
    String? activityType,
  }) => Session(
    id: id ?? this.id,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    totalMeters: totalMeters ?? this.totalMeters,
    activityType: activityType ?? this.activityType,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      totalMeters: data.totalMeters.present
          ? data.totalMeters.value
          : this.totalMeters,
      activityType: data.activityType.present
          ? data.activityType.value
          : this.activityType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('totalMeters: $totalMeters, ')
          ..write('activityType: $activityType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startTime, endTime, totalMeters, activityType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.totalMeters == this.totalMeters &&
          other.activityType == this.activityType);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String> startTime;
  final Value<String?> endTime;
  final Value<double> totalMeters;
  final Value<String> activityType;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.totalMeters = const Value.absent(),
    this.activityType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String startTime,
    this.endTime = const Value.absent(),
    this.totalMeters = const Value.absent(),
    this.activityType = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startTime = Value(startTime);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<double>? totalMeters,
    Expression<String>? activityType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (totalMeters != null) 'total_meters': totalMeters,
      if (activityType != null) 'activity_type': activityType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? startTime,
    Value<String?>? endTime,
    Value<double>? totalMeters,
    Value<String>? activityType,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalMeters: totalMeters ?? this.totalMeters,
      activityType: activityType ?? this.activityType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (totalMeters.present) {
      map['total_meters'] = Variable<double>(totalMeters.value);
    }
    if (activityType.present) {
      map['activity_type'] = Variable<String>(activityType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('totalMeters: $totalMeters, ')
          ..write('activityType: $activityType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WaypointsTable extends Waypoints
    with TableInfo<$WaypointsTable, Waypoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaypointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMsMeta = const VerificationMeta(
    'speedMs',
  );
  @override
  late final GeneratedColumn<double> speedMs = GeneratedColumn<double>(
    'speed_ms',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<String> timestamp = GeneratedColumn<String>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    sessionId,
    latitude,
    longitude,
    accuracy,
    speedMs,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'waypoints';
  @override
  VerificationContext validateIntegrity(
    Insertable<Waypoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    } else if (isInserting) {
      context.missing(_accuracyMeta);
    }
    if (data.containsKey('speed_ms')) {
      context.handle(
        _speedMsMeta,
        speedMs.isAcceptableOrUnknown(data['speed_ms']!, _speedMsMeta),
      );
    } else if (isInserting) {
      context.missing(_speedMsMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  Waypoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Waypoint(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      accuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy'],
      )!,
      speedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_ms'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $WaypointsTable createAlias(String alias) {
    return $WaypointsTable(attachedDatabase, alias);
  }
}

class Waypoint extends DataClass implements Insertable<Waypoint> {
  final int rowId;
  final String sessionId;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double speedMs;
  final String timestamp;
  const Waypoint({
    required this.rowId,
    required this.sessionId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.speedMs,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['session_id'] = Variable<String>(sessionId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['accuracy'] = Variable<double>(accuracy);
    map['speed_ms'] = Variable<double>(speedMs);
    map['timestamp'] = Variable<String>(timestamp);
    return map;
  }

  WaypointsCompanion toCompanion(bool nullToAbsent) {
    return WaypointsCompanion(
      rowId: Value(rowId),
      sessionId: Value(sessionId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      accuracy: Value(accuracy),
      speedMs: Value(speedMs),
      timestamp: Value(timestamp),
    );
  }

  factory Waypoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Waypoint(
      rowId: serializer.fromJson<int>(json['rowId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
      speedMs: serializer.fromJson<double>(json['speedMs']),
      timestamp: serializer.fromJson<String>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'sessionId': serializer.toJson<String>(sessionId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'accuracy': serializer.toJson<double>(accuracy),
      'speedMs': serializer.toJson<double>(speedMs),
      'timestamp': serializer.toJson<String>(timestamp),
    };
  }

  Waypoint copyWith({
    int? rowId,
    String? sessionId,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? speedMs,
    String? timestamp,
  }) => Waypoint(
    rowId: rowId ?? this.rowId,
    sessionId: sessionId ?? this.sessionId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    accuracy: accuracy ?? this.accuracy,
    speedMs: speedMs ?? this.speedMs,
    timestamp: timestamp ?? this.timestamp,
  );
  Waypoint copyWithCompanion(WaypointsCompanion data) {
    return Waypoint(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      speedMs: data.speedMs.present ? data.speedMs.value : this.speedMs,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Waypoint(')
          ..write('rowId: $rowId, ')
          ..write('sessionId: $sessionId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('speedMs: $speedMs, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    sessionId,
    latitude,
    longitude,
    accuracy,
    speedMs,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Waypoint &&
          other.rowId == this.rowId &&
          other.sessionId == this.sessionId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracy == this.accuracy &&
          other.speedMs == this.speedMs &&
          other.timestamp == this.timestamp);
}

class WaypointsCompanion extends UpdateCompanion<Waypoint> {
  final Value<int> rowId;
  final Value<String> sessionId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> accuracy;
  final Value<double> speedMs;
  final Value<String> timestamp;
  const WaypointsCompanion({
    this.rowId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.speedMs = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  WaypointsCompanion.insert({
    this.rowId = const Value.absent(),
    required String sessionId,
    required double latitude,
    required double longitude,
    required double accuracy,
    required double speedMs,
    required String timestamp,
  }) : sessionId = Value(sessionId),
       latitude = Value(latitude),
       longitude = Value(longitude),
       accuracy = Value(accuracy),
       speedMs = Value(speedMs),
       timestamp = Value(timestamp);
  static Insertable<Waypoint> custom({
    Expression<int>? rowId,
    Expression<String>? sessionId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracy,
    Expression<double>? speedMs,
    Expression<String>? timestamp,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (sessionId != null) 'session_id': sessionId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (speedMs != null) 'speed_ms': speedMs,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  WaypointsCompanion copyWith({
    Value<int>? rowId,
    Value<String>? sessionId,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? accuracy,
    Value<double>? speedMs,
    Value<String>? timestamp,
  }) {
    return WaypointsCompanion(
      rowId: rowId ?? this.rowId,
      sessionId: sessionId ?? this.sessionId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      speedMs: speedMs ?? this.speedMs,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (speedMs.present) {
      map['speed_ms'] = Variable<double>(speedMs.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<String>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaypointsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('sessionId: $sessionId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('speedMs: $speedMs, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $WaypointsTable waypoints = $WaypointsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [sessions, waypoints];
}

typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String id,
      required String startTime,
      Value<String?> endTime,
      Value<double> totalMeters,
      Value<String> activityType,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<String> startTime,
      Value<String?> endTime,
      Value<double> totalMeters,
      Value<String> activityType,
      Value<int> rowid,
    });

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalMeters => $composableBuilder(
    column: $table.totalMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalMeters => $composableBuilder(
    column: $table.totalMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get totalMeters => $composableBuilder(
    column: $table.totalMeters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => column,
  );
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
          Session,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<double> totalMeters = const Value.absent(),
                Value<String> activityType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                startTime: startTime,
                endTime: endTime,
                totalMeters: totalMeters,
                activityType: activityType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String startTime,
                Value<String?> endTime = const Value.absent(),
                Value<double> totalMeters = const Value.absent(),
                Value<String> activityType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                startTime: startTime,
                endTime: endTime,
                totalMeters: totalMeters,
                activityType: activityType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
      Session,
      PrefetchHooks Function()
    >;
typedef $$WaypointsTableCreateCompanionBuilder =
    WaypointsCompanion Function({
      Value<int> rowId,
      required String sessionId,
      required double latitude,
      required double longitude,
      required double accuracy,
      required double speedMs,
      required String timestamp,
    });
typedef $$WaypointsTableUpdateCompanionBuilder =
    WaypointsCompanion Function({
      Value<int> rowId,
      Value<String> sessionId,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> accuracy,
      Value<double> speedMs,
      Value<String> timestamp,
    });

class $$WaypointsTableFilterComposer
    extends Composer<_$AppDatabase, $WaypointsTable> {
  $$WaypointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedMs => $composableBuilder(
    column: $table.speedMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WaypointsTableOrderingComposer
    extends Composer<_$AppDatabase, $WaypointsTable> {
  $$WaypointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedMs => $composableBuilder(
    column: $table.speedMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WaypointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaypointsTable> {
  $$WaypointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get speedMs =>
      $composableBuilder(column: $table.speedMs, builder: (column) => column);

  GeneratedColumn<String> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$WaypointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaypointsTable,
          Waypoint,
          $$WaypointsTableFilterComposer,
          $$WaypointsTableOrderingComposer,
          $$WaypointsTableAnnotationComposer,
          $$WaypointsTableCreateCompanionBuilder,
          $$WaypointsTableUpdateCompanionBuilder,
          (Waypoint, BaseReferences<_$AppDatabase, $WaypointsTable, Waypoint>),
          Waypoint,
          PrefetchHooks Function()
        > {
  $$WaypointsTableTableManager(_$AppDatabase db, $WaypointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaypointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaypointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaypointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> accuracy = const Value.absent(),
                Value<double> speedMs = const Value.absent(),
                Value<String> timestamp = const Value.absent(),
              }) => WaypointsCompanion(
                rowId: rowId,
                sessionId: sessionId,
                latitude: latitude,
                longitude: longitude,
                accuracy: accuracy,
                speedMs: speedMs,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String sessionId,
                required double latitude,
                required double longitude,
                required double accuracy,
                required double speedMs,
                required String timestamp,
              }) => WaypointsCompanion.insert(
                rowId: rowId,
                sessionId: sessionId,
                latitude: latitude,
                longitude: longitude,
                accuracy: accuracy,
                speedMs: speedMs,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WaypointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaypointsTable,
      Waypoint,
      $$WaypointsTableFilterComposer,
      $$WaypointsTableOrderingComposer,
      $$WaypointsTableAnnotationComposer,
      $$WaypointsTableCreateCompanionBuilder,
      $$WaypointsTableUpdateCompanionBuilder,
      (Waypoint, BaseReferences<_$AppDatabase, $WaypointsTable, Waypoint>),
      Waypoint,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$WaypointsTableTableManager get waypoints =>
      $$WaypointsTableTableManager(_db, _db.waypoints);
}
