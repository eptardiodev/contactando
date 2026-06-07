// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/sign_in_usecase.dart' as _i259;
import '../../features/auth/domain/usecases/sign_out_usecase.dart' as _i915;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/contacts/data/datasources/contact_remote_datasource.dart'
    as _i443;
import '../../features/contacts/data/repositories/contact_repository_impl.dart'
    as _i929;
import '../../features/contacts/domain/repositories/contact_repository.dart'
    as _i873;
import '../../features/contacts/domain/usecases/get_contacts_usecase.dart'
    as _i1050;
import '../../features/contacts/presentation/bloc/contacts_bloc.dart' as _i295;
import '../../features/settings/presentation/bloc/settings_cubit.dart' as _i819;
import '../router/app_router.dart' as _i81;
import 'modules/supabase_module.dart' as _i388;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    final supabaseModule = _$SupabaseModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i81.AppRouter>(() => _i81.AppRouter());
    gh.lazySingleton<_i454.SupabaseClient>(() => supabaseModule.supabaseClient);
    gh.factory<_i443.ContactRemoteDatasource>(
        () => _i443.SupabaseContactDatasource(gh<_i454.SupabaseClient>()));
    gh.factory<_i873.ContactRepository>(
        () => _i929.ContactRepositoryImpl(gh<_i443.ContactRemoteDatasource>()));
    gh.singleton<_i819.SettingsCubit>(
        () => _i819.SettingsCubit(gh<_i460.SharedPreferences>()));
    gh.factory<_i1050.GetContactsUseCase>(
        () => _i1050.GetContactsUseCase(gh<_i873.ContactRepository>()));
    gh.factory<_i295.ContactsBloc>(
        () => _i295.ContactsBloc(gh<_i1050.GetContactsUseCase>()));
    gh.lazySingleton<_i161.AuthRemoteDatasource>(
        () => _i161.AuthRemoteDatasourceImpl(
              gh<_i454.SupabaseClient>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.lazySingleton<_i787.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i161.AuthRemoteDatasource>()));
    gh.factory<_i259.SignInUseCase>(
        () => _i259.SignInUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i915.SignOutUseCase>(
        () => _i915.SignOutUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          signIn: gh<_i259.SignInUseCase>(),
          signOut: gh<_i915.SignOutUseCase>(),
          authRepository: gh<_i787.AuthRepository>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}

class _$SupabaseModule extends _i388.SupabaseModule {}
