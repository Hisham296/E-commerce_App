import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/products/data/datasources/product_details_data_source.dart';
import '../../features/products/data/repositories/product_details_repository.dart';
import '../../features/products/presentation/cubit/product_details_cubit.dart';
import '../../features/auth/data/datasource/loginservice.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../network/api_endpoints.dart';
import '../network/dio_client.dart';
import '../network/token_storage.dart';

/// Global service locator instance.
final getIt = GetIt.instance;

/// Registers the network stack and feature services.
///
/// Call once from `main()` after `WidgetsFlutterBinding.ensureInitialized()`.
Future<void> configureDependencies() async {
  // --- Core / infrastructure ---------------------------------------------

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Persistent local token cache (survives app restarts).
  getIt.registerLazySingleton<TokenStorage>(
    () => SharedPrefsTokenStorage(getIt<SharedPreferences>()),
  );

  // Base Dio, shared so interceptors/options are configured in one place.
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        sendTimeout: ApiEndpoints.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    ),
  );

  // DioClient owns auth-header injection, token refresh and ApiException mapping.
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(dio: getIt<Dio>(), tokenStorage: getIt<TokenStorage>()),
  );

  // --- Feature: Product Details --------------------------------------------

  getIt.registerLazySingleton<ProductDetailsDataSource>(
    () => ProductDetailsDataSource(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<ProductDetailsRepository>(
    () =>
        ProductDetailsRepository(dataSource: getIt<ProductDetailsDataSource>()),
  );

  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(repository: getIt<ProductDetailsRepository>()),
  );

  // --- Feature: Auth ------------------------------------------------------

  getIt.registerLazySingleton<LoginService>(
    () => LoginService(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      loginService: getIt<LoginService>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );
}
