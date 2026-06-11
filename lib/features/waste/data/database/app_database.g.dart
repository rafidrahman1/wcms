// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WasteItemsTable extends WasteItems
    with TableInfo<$WasteItemsTable, WasteItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WasteItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    memberId,
    weight,
    type,
    imagePath,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'waste_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WasteItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WasteItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WasteItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WasteItemsTable createAlias(String alias) {
    return $WasteItemsTable(attachedDatabase, alias);
  }
}

class WasteItemRow extends DataClass implements Insertable<WasteItemRow> {
  final int id;
  final String memberId;
  final double weight;
  final String type;
  final String imagePath;
  final DateTime createdAt;
  const WasteItemRow({
    required this.id,
    required this.memberId,
    required this.weight,
    required this.type,
    required this.imagePath,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['member_id'] = Variable<String>(memberId);
    map['weight'] = Variable<double>(weight);
    map['type'] = Variable<String>(type);
    map['image_path'] = Variable<String>(imagePath);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WasteItemsCompanion toCompanion(bool nullToAbsent) {
    return WasteItemsCompanion(
      id: Value(id),
      memberId: Value(memberId),
      weight: Value(weight),
      type: Value(type),
      imagePath: Value(imagePath),
      createdAt: Value(createdAt),
    );
  }

  factory WasteItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WasteItemRow(
      id: serializer.fromJson<int>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      weight: serializer.fromJson<double>(json['weight']),
      type: serializer.fromJson<String>(json['type']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'memberId': serializer.toJson<String>(memberId),
      'weight': serializer.toJson<double>(weight),
      'type': serializer.toJson<String>(type),
      'imagePath': serializer.toJson<String>(imagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WasteItemRow copyWith({
    int? id,
    String? memberId,
    double? weight,
    String? type,
    String? imagePath,
    DateTime? createdAt,
  }) => WasteItemRow(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    weight: weight ?? this.weight,
    type: type ?? this.type,
    imagePath: imagePath ?? this.imagePath,
    createdAt: createdAt ?? this.createdAt,
  );
  WasteItemRow copyWithCompanion(WasteItemsCompanion data) {
    return WasteItemRow(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      weight: data.weight.present ? data.weight.value : this.weight,
      type: data.type.present ? data.type.value : this.type,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WasteItemRow(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('weight: $weight, ')
          ..write('type: $type, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, memberId, weight, type, imagePath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WasteItemRow &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.weight == this.weight &&
          other.type == this.type &&
          other.imagePath == this.imagePath &&
          other.createdAt == this.createdAt);
}

class WasteItemsCompanion extends UpdateCompanion<WasteItemRow> {
  final Value<int> id;
  final Value<String> memberId;
  final Value<double> weight;
  final Value<String> type;
  final Value<String> imagePath;
  final Value<DateTime> createdAt;
  const WasteItemsCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.weight = const Value.absent(),
    this.type = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WasteItemsCompanion.insert({
    this.id = const Value.absent(),
    required String memberId,
    required double weight,
    required String type,
    required String imagePath,
    required DateTime createdAt,
  }) : memberId = Value(memberId),
       weight = Value(weight),
       type = Value(type),
       imagePath = Value(imagePath),
       createdAt = Value(createdAt);
  static Insertable<WasteItemRow> custom({
    Expression<int>? id,
    Expression<String>? memberId,
    Expression<double>? weight,
    Expression<String>? type,
    Expression<String>? imagePath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (weight != null) 'weight': weight,
      if (type != null) 'type': type,
      if (imagePath != null) 'image_path': imagePath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WasteItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? memberId,
    Value<double>? weight,
    Value<String>? type,
    Value<String>? imagePath,
    Value<DateTime>? createdAt,
  }) {
    return WasteItemsCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      weight: weight ?? this.weight,
      type: type ?? this.type,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WasteItemsCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('weight: $weight, ')
          ..write('type: $type, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WasteItemsTable wasteItems = $WasteItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [wasteItems];
}

typedef $$WasteItemsTableCreateCompanionBuilder =
    WasteItemsCompanion Function({
      Value<int> id,
      required String memberId,
      required double weight,
      required String type,
      required String imagePath,
      required DateTime createdAt,
    });
typedef $$WasteItemsTableUpdateCompanionBuilder =
    WasteItemsCompanion Function({
      Value<int> id,
      Value<String> memberId,
      Value<double> weight,
      Value<String> type,
      Value<String> imagePath,
      Value<DateTime> createdAt,
    });

class $$WasteItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WasteItemsTable> {
  $$WasteItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WasteItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WasteItemsTable> {
  $$WasteItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WasteItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WasteItemsTable> {
  $$WasteItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WasteItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WasteItemsTable,
          WasteItemRow,
          $$WasteItemsTableFilterComposer,
          $$WasteItemsTableOrderingComposer,
          $$WasteItemsTableAnnotationComposer,
          $$WasteItemsTableCreateCompanionBuilder,
          $$WasteItemsTableUpdateCompanionBuilder,
          (
            WasteItemRow,
            BaseReferences<_$AppDatabase, $WasteItemsTable, WasteItemRow>,
          ),
          WasteItemRow,
          PrefetchHooks Function()
        > {
  $$WasteItemsTableTableManager(_$AppDatabase db, $WasteItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WasteItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WasteItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WasteItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WasteItemsCompanion(
                id: id,
                memberId: memberId,
                weight: weight,
                type: type,
                imagePath: imagePath,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String memberId,
                required double weight,
                required String type,
                required String imagePath,
                required DateTime createdAt,
              }) => WasteItemsCompanion.insert(
                id: id,
                memberId: memberId,
                weight: weight,
                type: type,
                imagePath: imagePath,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WasteItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WasteItemsTable,
      WasteItemRow,
      $$WasteItemsTableFilterComposer,
      $$WasteItemsTableOrderingComposer,
      $$WasteItemsTableAnnotationComposer,
      $$WasteItemsTableCreateCompanionBuilder,
      $$WasteItemsTableUpdateCompanionBuilder,
      (
        WasteItemRow,
        BaseReferences<_$AppDatabase, $WasteItemsTable, WasteItemRow>,
      ),
      WasteItemRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WasteItemsTableTableManager get wasteItems =>
      $$WasteItemsTableTableManager(_db, _db.wasteItems);
}
