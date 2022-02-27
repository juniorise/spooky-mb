import 'package:spooky/core/storages/base_storages/base_storage.dart';
import 'package:spooky/core/storages/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/storages/storage_adapters/secure_storage_adapter.dart';

abstract class SecureStorage extends BaseStorage<String> {
  @override
  Future<BaseStorageAdapter<String>> get adapter async => SecureStorageAdapter();
}
