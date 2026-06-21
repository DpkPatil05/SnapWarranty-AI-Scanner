// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warranty_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(database)
final databaseProvider = DatabaseProvider._();

final class DatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  DatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$databaseHash() => r'd66464688f3f3beae31aa517238455b4413086f1';

@ProviderFor(geminiDataSource)
final geminiDataSourceProvider = GeminiDataSourceProvider._();

final class GeminiDataSourceProvider
    extends
        $FunctionalProvider<
          GeminiRemoteDataSource,
          GeminiRemoteDataSource,
          GeminiRemoteDataSource
        >
    with $Provider<GeminiRemoteDataSource> {
  GeminiDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiDataSourceHash();

  @$internal
  @override
  $ProviderElement<GeminiRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GeminiRemoteDataSource create(Ref ref) {
    return geminiDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeminiRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeminiRemoteDataSource>(value),
    );
  }
}

String _$geminiDataSourceHash() => r'cb7f2cae3d3b97a9152581787115533a527ca097';

@ProviderFor(warrantyDao)
final warrantyDaoProvider = WarrantyDaoProvider._();

final class WarrantyDaoProvider
    extends $FunctionalProvider<WarrantyDao, WarrantyDao, WarrantyDao>
    with $Provider<WarrantyDao> {
  WarrantyDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'warrantyDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$warrantyDaoHash();

  @$internal
  @override
  $ProviderElement<WarrantyDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WarrantyDao create(Ref ref) {
    return warrantyDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WarrantyDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WarrantyDao>(value),
    );
  }
}

String _$warrantyDaoHash() => r'a3387d89a854962940f7bf44e330a071ac083112';

@ProviderFor(warrantyRepository)
final warrantyRepositoryProvider = WarrantyRepositoryProvider._();

final class WarrantyRepositoryProvider
    extends
        $FunctionalProvider<
          WarrantyRepository,
          WarrantyRepository,
          WarrantyRepository
        >
    with $Provider<WarrantyRepository> {
  WarrantyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'warrantyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$warrantyRepositoryHash();

  @$internal
  @override
  $ProviderElement<WarrantyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WarrantyRepository create(Ref ref) {
    return warrantyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WarrantyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WarrantyRepository>(value),
    );
  }
}

String _$warrantyRepositoryHash() =>
    r'45d18b8efc0f8d3caea4aa86a5c4ee27f1b70e2e';

@ProviderFor(WarrantyList)
final warrantyListProvider = WarrantyListProvider._();

final class WarrantyListProvider
    extends $AsyncNotifierProvider<WarrantyList, List<WarrantyItem>> {
  WarrantyListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'warrantyListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$warrantyListHash();

  @$internal
  @override
  WarrantyList create() => WarrantyList();
}

String _$warrantyListHash() => r'6dd42ebd0bc1a6fc06c7802899ee74f885c09eb7';

abstract class _$WarrantyList extends $AsyncNotifier<List<WarrantyItem>> {
  FutureOr<List<WarrantyItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<WarrantyItem>>, List<WarrantyItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WarrantyItem>>, List<WarrantyItem>>,
              AsyncValue<List<WarrantyItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
