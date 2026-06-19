// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WarrantiesTable extends Warranties
    with TableInfo<$WarrantiesTable, WarrantyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WarrantiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warrantyDurationMonthsMeta =
      const VerificationMeta('warrantyDurationMonths');
  @override
  late final GeneratedColumn<int> warrantyDurationMonths = GeneratedColumn<int>(
    'warranty_duration_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiptImagePathMeta = const VerificationMeta(
    'receiptImagePath',
  );
  @override
  late final GeneratedColumn<String> receiptImagePath = GeneratedColumn<String>(
    'receipt_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productName,
    purchaseDate,
    warrantyDurationMonths,
    receiptImagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'warranties';
  @override
  VerificationContext validateIntegrity(
    Insertable<WarrantyEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('warranty_duration_months')) {
      context.handle(
        _warrantyDurationMonthsMeta,
        warrantyDurationMonths.isAcceptableOrUnknown(
          data['warranty_duration_months']!,
          _warrantyDurationMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_warrantyDurationMonthsMeta);
    }
    if (data.containsKey('receipt_image_path')) {
      context.handle(
        _receiptImagePathMeta,
        receiptImagePath.isAcceptableOrUnknown(
          data['receipt_image_path']!,
          _receiptImagePathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WarrantyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WarrantyEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      )!,
      warrantyDurationMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warranty_duration_months'],
      )!,
      receiptImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_image_path'],
      ),
    );
  }

  @override
  $WarrantiesTable createAlias(String alias) {
    return $WarrantiesTable(attachedDatabase, alias);
  }
}

class WarrantyEntry extends DataClass implements Insertable<WarrantyEntry> {
  final String id;
  final String productName;
  final DateTime purchaseDate;
  final int warrantyDurationMonths;
  final String? receiptImagePath;
  const WarrantyEntry({
    required this.id,
    required this.productName,
    required this.purchaseDate,
    required this.warrantyDurationMonths,
    this.receiptImagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_name'] = Variable<String>(productName);
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['warranty_duration_months'] = Variable<int>(warrantyDurationMonths);
    if (!nullToAbsent || receiptImagePath != null) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath);
    }
    return map;
  }

  WarrantiesCompanion toCompanion(bool nullToAbsent) {
    return WarrantiesCompanion(
      id: Value(id),
      productName: Value(productName),
      purchaseDate: Value(purchaseDate),
      warrantyDurationMonths: Value(warrantyDurationMonths),
      receiptImagePath: receiptImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptImagePath),
    );
  }

  factory WarrantyEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WarrantyEntry(
      id: serializer.fromJson<String>(json['id']),
      productName: serializer.fromJson<String>(json['productName']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      warrantyDurationMonths: serializer.fromJson<int>(
        json['warrantyDurationMonths'],
      ),
      receiptImagePath: serializer.fromJson<String?>(json['receiptImagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productName': serializer.toJson<String>(productName),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'warrantyDurationMonths': serializer.toJson<int>(warrantyDurationMonths),
      'receiptImagePath': serializer.toJson<String?>(receiptImagePath),
    };
  }

  WarrantyEntry copyWith({
    String? id,
    String? productName,
    DateTime? purchaseDate,
    int? warrantyDurationMonths,
    Value<String?> receiptImagePath = const Value.absent(),
  }) => WarrantyEntry(
    id: id ?? this.id,
    productName: productName ?? this.productName,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    warrantyDurationMonths:
        warrantyDurationMonths ?? this.warrantyDurationMonths,
    receiptImagePath: receiptImagePath.present
        ? receiptImagePath.value
        : this.receiptImagePath,
  );
  WarrantyEntry copyWithCompanion(WarrantiesCompanion data) {
    return WarrantyEntry(
      id: data.id.present ? data.id.value : this.id,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      warrantyDurationMonths: data.warrantyDurationMonths.present
          ? data.warrantyDurationMonths.value
          : this.warrantyDurationMonths,
      receiptImagePath: data.receiptImagePath.present
          ? data.receiptImagePath.value
          : this.receiptImagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WarrantyEntry(')
          ..write('id: $id, ')
          ..write('productName: $productName, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('warrantyDurationMonths: $warrantyDurationMonths, ')
          ..write('receiptImagePath: $receiptImagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productName,
    purchaseDate,
    warrantyDurationMonths,
    receiptImagePath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WarrantyEntry &&
          other.id == this.id &&
          other.productName == this.productName &&
          other.purchaseDate == this.purchaseDate &&
          other.warrantyDurationMonths == this.warrantyDurationMonths &&
          other.receiptImagePath == this.receiptImagePath);
}

class WarrantiesCompanion extends UpdateCompanion<WarrantyEntry> {
  final Value<String> id;
  final Value<String> productName;
  final Value<DateTime> purchaseDate;
  final Value<int> warrantyDurationMonths;
  final Value<String?> receiptImagePath;
  final Value<int> rowid;
  const WarrantiesCompanion({
    this.id = const Value.absent(),
    this.productName = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.warrantyDurationMonths = const Value.absent(),
    this.receiptImagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WarrantiesCompanion.insert({
    required String id,
    required String productName,
    required DateTime purchaseDate,
    required int warrantyDurationMonths,
    this.receiptImagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productName = Value(productName),
       purchaseDate = Value(purchaseDate),
       warrantyDurationMonths = Value(warrantyDurationMonths);
  static Insertable<WarrantyEntry> custom({
    Expression<String>? id,
    Expression<String>? productName,
    Expression<DateTime>? purchaseDate,
    Expression<int>? warrantyDurationMonths,
    Expression<String>? receiptImagePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productName != null) 'product_name': productName,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (warrantyDurationMonths != null)
        'warranty_duration_months': warrantyDurationMonths,
      if (receiptImagePath != null) 'receipt_image_path': receiptImagePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WarrantiesCompanion copyWith({
    Value<String>? id,
    Value<String>? productName,
    Value<DateTime>? purchaseDate,
    Value<int>? warrantyDurationMonths,
    Value<String?>? receiptImagePath,
    Value<int>? rowid,
  }) {
    return WarrantiesCompanion(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      warrantyDurationMonths:
          warrantyDurationMonths ?? this.warrantyDurationMonths,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (warrantyDurationMonths.present) {
      map['warranty_duration_months'] = Variable<int>(
        warrantyDurationMonths.value,
      );
    }
    if (receiptImagePath.present) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WarrantiesCompanion(')
          ..write('id: $id, ')
          ..write('productName: $productName, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('warrantyDurationMonths: $warrantyDurationMonths, ')
          ..write('receiptImagePath: $receiptImagePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WarrantiesTable warranties = $WarrantiesTable(this);
  late final WarrantyDao warrantyDao = WarrantyDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [warranties];
}

typedef $$WarrantiesTableCreateCompanionBuilder =
    WarrantiesCompanion Function({
      required String id,
      required String productName,
      required DateTime purchaseDate,
      required int warrantyDurationMonths,
      Value<String?> receiptImagePath,
      Value<int> rowid,
    });
typedef $$WarrantiesTableUpdateCompanionBuilder =
    WarrantiesCompanion Function({
      Value<String> id,
      Value<String> productName,
      Value<DateTime> purchaseDate,
      Value<int> warrantyDurationMonths,
      Value<String?> receiptImagePath,
      Value<int> rowid,
    });

class $$WarrantiesTableFilterComposer
    extends Composer<_$AppDatabase, $WarrantiesTable> {
  $$WarrantiesTableFilterComposer({
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

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warrantyDurationMonths => $composableBuilder(
    column: $table.warrantyDurationMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WarrantiesTableOrderingComposer
    extends Composer<_$AppDatabase, $WarrantiesTable> {
  $$WarrantiesTableOrderingComposer({
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

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warrantyDurationMonths => $composableBuilder(
    column: $table.warrantyDurationMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WarrantiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WarrantiesTable> {
  $$WarrantiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get warrantyDurationMonths => $composableBuilder(
    column: $table.warrantyDurationMonths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => column,
  );
}

class $$WarrantiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WarrantiesTable,
          WarrantyEntry,
          $$WarrantiesTableFilterComposer,
          $$WarrantiesTableOrderingComposer,
          $$WarrantiesTableAnnotationComposer,
          $$WarrantiesTableCreateCompanionBuilder,
          $$WarrantiesTableUpdateCompanionBuilder,
          (
            WarrantyEntry,
            BaseReferences<_$AppDatabase, $WarrantiesTable, WarrantyEntry>,
          ),
          WarrantyEntry,
          PrefetchHooks Function()
        > {
  $$WarrantiesTableTableManager(_$AppDatabase db, $WarrantiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WarrantiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WarrantiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WarrantiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<DateTime> purchaseDate = const Value.absent(),
                Value<int> warrantyDurationMonths = const Value.absent(),
                Value<String?> receiptImagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WarrantiesCompanion(
                id: id,
                productName: productName,
                purchaseDate: purchaseDate,
                warrantyDurationMonths: warrantyDurationMonths,
                receiptImagePath: receiptImagePath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productName,
                required DateTime purchaseDate,
                required int warrantyDurationMonths,
                Value<String?> receiptImagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WarrantiesCompanion.insert(
                id: id,
                productName: productName,
                purchaseDate: purchaseDate,
                warrantyDurationMonths: warrantyDurationMonths,
                receiptImagePath: receiptImagePath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WarrantiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WarrantiesTable,
      WarrantyEntry,
      $$WarrantiesTableFilterComposer,
      $$WarrantiesTableOrderingComposer,
      $$WarrantiesTableAnnotationComposer,
      $$WarrantiesTableCreateCompanionBuilder,
      $$WarrantiesTableUpdateCompanionBuilder,
      (
        WarrantyEntry,
        BaseReferences<_$AppDatabase, $WarrantiesTable, WarrantyEntry>,
      ),
      WarrantyEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WarrantiesTableTableManager get warranties =>
      $$WarrantiesTableTableManager(_db, _db.warranties);
}
