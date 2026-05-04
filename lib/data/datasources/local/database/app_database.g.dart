// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WarrantyDao? _warrantyDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `warranties` (`id` TEXT NOT NULL, `productName` TEXT NOT NULL, `purchaseDate` INTEGER NOT NULL, `warrantyDurationMonths` INTEGER NOT NULL, `receiptImagePath` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WarrantyDao get warrantyDao {
    return _warrantyDaoInstance ??= _$WarrantyDao(database, changeListener);
  }
}

class _$WarrantyDao extends WarrantyDao {
  _$WarrantyDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _warrantyItemModelInsertionAdapter = InsertionAdapter(
            database,
            'warranties',
            (WarrantyItemModel item) => <String, Object?>{
                  'id': item.id,
                  'productName': item.productName,
                  'purchaseDate': _dateTimeConverter.encode(item.purchaseDate),
                  'warrantyDurationMonths': item.warrantyDurationMonths,
                  'receiptImagePath': item.receiptImagePath
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WarrantyItemModel> _warrantyItemModelInsertionAdapter;

  @override
  Future<List<WarrantyItemModel>> findAllWarranties() async {
    return _queryAdapter.queryList('SELECT * FROM warranties',
        mapper: (Map<String, Object?> row) => WarrantyItemModel(
            id: row['id'] as String,
            productName: row['productName'] as String,
            purchaseDate: _dateTimeConverter.decode(row['purchaseDate'] as int),
            warrantyDurationMonths: row['warrantyDurationMonths'] as int,
            receiptImagePath: row['receiptImagePath'] as String?));
  }

  @override
  Stream<WarrantyItemModel?> findWarrantyById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM warranties WHERE id = ?1',
        mapper: (Map<String, Object?> row) => WarrantyItemModel(
            id: row['id'] as String,
            productName: row['productName'] as String,
            purchaseDate: _dateTimeConverter.decode(row['purchaseDate'] as int),
            warrantyDurationMonths: row['warrantyDurationMonths'] as int,
            receiptImagePath: row['receiptImagePath'] as String?),
        arguments: [id],
        queryableName: 'warranties',
        isView: false);
  }

  @override
  Future<void> deleteWarrantyById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM warranties WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertWarranty(WarrantyItemModel warranty) async {
    await _warrantyItemModelInsertionAdapter.insert(
        warranty, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
