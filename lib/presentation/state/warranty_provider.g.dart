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

@ProviderFor(driveSyncDataSource)
final driveSyncDataSourceProvider = DriveSyncDataSourceProvider._();

final class DriveSyncDataSourceProvider
    extends
        $FunctionalProvider<
          DriveSyncDataSource,
          DriveSyncDataSource,
          DriveSyncDataSource
        >
    with $Provider<DriveSyncDataSource> {
  DriveSyncDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'driveSyncDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$driveSyncDataSourceHash();

  @$internal
  @override
  $ProviderElement<DriveSyncDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DriveSyncDataSource create(Ref ref) {
    return driveSyncDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriveSyncDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DriveSyncDataSource>(value),
    );
  }
}

String _$driveSyncDataSourceHash() =>
    r'f687d0c884492f3ce87dea8e29f611383e412f56';

@ProviderFor(notificationService)
final notificationServiceProvider = NotificationServiceProvider._();

final class NotificationServiceProvider
    extends
        $FunctionalProvider<
          NotificationService,
          NotificationService,
          NotificationService
        >
    with $Provider<NotificationService> {
  NotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationService create(Ref ref) {
    return notificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationService>(value),
    );
  }
}

String _$notificationServiceHash() =>
    r'cda5ea9d196dce85bee56839a4a0f035021752e3';

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
    r'eeaf9e64bbb269a4b07bd187c0f8b2939edeb45a';

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

String _$warrantyListHash() => r'3347ea07eaf71e0ac8495ae62cc7e85107c8531c';

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

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'286abcff51dc844febe02639bb2e883ccab22cfd';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredWarranties)
final filteredWarrantiesProvider = FilteredWarrantiesProvider._();

final class FilteredWarrantiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WarrantyItem>>,
          List<WarrantyItem>,
          FutureOr<List<WarrantyItem>>
        >
    with
        $FutureModifier<List<WarrantyItem>>,
        $FutureProvider<List<WarrantyItem>> {
  FilteredWarrantiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredWarrantiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredWarrantiesHash();

  @$internal
  @override
  $FutureProviderElement<List<WarrantyItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WarrantyItem>> create(Ref ref) {
    return filteredWarranties(ref);
  }
}

String _$filteredWarrantiesHash() =>
    r'935847d7f5d763900fe7842500ca1036e14fbd9a';

@ProviderFor(DocumentScanning)
final documentScanningProvider = DocumentScanningProvider._();

final class DocumentScanningProvider
    extends $NotifierProvider<DocumentScanning, bool> {
  DocumentScanningProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentScanningProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentScanningHash();

  @$internal
  @override
  DocumentScanning create() => DocumentScanning();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$documentScanningHash() => r'5d68eae5e16946157002092293d52d5af2226a6b';

abstract class _$DocumentScanning extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
