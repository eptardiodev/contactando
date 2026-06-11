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
import '../../features/contacts/domain/usecases/contact_usecases.dart' as _i96;
import '../../features/contacts/domain/usecases/get_contacts_usecase.dart'
    as _i1050;
import '../../features/contacts/presentation/bloc/contact_detail_bloc.dart'
    as _i432;
import '../../features/contacts/presentation/bloc/contacts_bloc.dart' as _i295;
import '../../features/profile/data/datasources/profile_remote_datasource.dart'
    as _i327;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/usecases/profile_usecases.dart' as _i591;
import '../../features/profile/presentation/bloc/profile_bloc.dart' as _i469;
import '../../features/relationship_type/data/datasources/relationship_type_remote_datasource.dart'
    as _i560;
import '../../features/relationship_type/data/repositories/relationship_type_repository_impl.dart'
    as _i970;
import '../../features/relationship_type/domain/repositories/relationship_type_repository.dart'
    as _i784;
import '../../features/relationship_type/domain/usecases/relationship_type_usecases.dart'
    as _i502;
import '../../features/relationship_type/presentation/bloc/relationship_type_bloc.dart'
    as _i1022;
import '../../features/settings/presentation/bloc/settings_cubit.dart' as _i819;
import '../../features/transactions/data/datasources/transaction_remote_datasource.dart'
    as _i634;
import '../../features/transactions/data/repositories/transaction_repository_impl.dart'
    as _i443;
import '../../features/transactions/domain/repositories/transaction_repository.dart'
    as _i421;
import '../../features/transactions/domain/usecases/transaction_usecases.dart'
    as _i843;
import '../../features/transactions/presentation/bloc/transactions_bloc.dart'
    as _i439;
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
    gh.lazySingleton<_i454.SupabaseClient>(() => supabaseModule.supabaseClient);
    gh.lazySingleton<_i81.AppRouter>(() => _i81.AppRouter());
    gh.lazySingleton<_i327.ProfileRemoteDatasource>(
        () => _i327.SupabaseProfileDatasource(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i560.RelationshipTypeRemoteDatasource>(() =>
        _i560.SupabaseRelationshipTypeDatasource(gh<_i454.SupabaseClient>()));
    gh.factory<_i634.TransactionRemoteDatasource>(
        () => _i634.SupabaseTransactionDatasource(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i894.ProfileRepository>(
        () => _i334.ProfileRepositoryImpl(gh<_i327.ProfileRemoteDatasource>()));
    gh.factory<_i443.ContactRemoteDatasource>(
        () => _i443.SupabaseContactDatasource(gh<_i454.SupabaseClient>()));
    gh.factory<_i873.ContactRepository>(
        () => _i929.ContactRepositoryImpl(gh<_i443.ContactRemoteDatasource>()));
    gh.lazySingleton<_i784.RelationshipTypeRepository>(() =>
        _i970.RelationshipTypeRepositoryImpl(
            gh<_i560.RelationshipTypeRemoteDatasource>()));
    gh.factory<_i591.GetProfileUseCase>(
        () => _i591.GetProfileUseCase(gh<_i894.ProfileRepository>()));
    gh.factory<_i591.UpdateProfileUseCase>(
        () => _i591.UpdateProfileUseCase(gh<_i894.ProfileRepository>()));
    gh.factory<_i469.ProfileBloc>(() => _i469.ProfileBloc(
          getProfile: gh<_i591.GetProfileUseCase>(),
          updateProfile: gh<_i591.UpdateProfileUseCase>(),
        ));
    gh.singleton<_i819.SettingsCubit>(
        () => _i819.SettingsCubit(gh<_i460.SharedPreferences>()));
    gh.factory<_i421.TransactionRepository>(() =>
        _i443.TransactionRepositoryImpl(
            gh<_i634.TransactionRemoteDatasource>()));
    gh.factory<_i96.GetContactsUseCase>(
        () => _i96.GetContactsUseCase(gh<_i873.ContactRepository>()));
    gh.factory<_i96.GetContactByIdUseCase>(
        () => _i96.GetContactByIdUseCase(gh<_i873.ContactRepository>()));
    gh.factory<_i96.SearchContactsUseCase>(
        () => _i96.SearchContactsUseCase(gh<_i873.ContactRepository>()));
    gh.factory<_i96.CreateContactUseCase>(
        () => _i96.CreateContactUseCase(gh<_i873.ContactRepository>()));
    gh.factory<_i96.UpdateContactUseCase>(
        () => _i96.UpdateContactUseCase(gh<_i873.ContactRepository>()));
    gh.factory<_i96.DeleteContactUseCase>(
        () => _i96.DeleteContactUseCase(gh<_i873.ContactRepository>()));
    gh.factory<_i96.GetUniqueCountriesUseCase>(
        () => _i96.GetUniqueCountriesUseCase(gh<_i873.ContactRepository>()));
    gh.factory<_i1050.GetContactsUseCase>(
        () => _i1050.GetContactsUseCase(gh<_i873.ContactRepository>()));
    gh.factory<_i295.ContactsBloc>(() => _i295.ContactsBloc(
          getContacts: gh<_i96.GetContactsUseCase>(),
          searchContacts: gh<_i96.SearchContactsUseCase>(),
          createContact: gh<_i96.CreateContactUseCase>(),
          updateContact: gh<_i96.UpdateContactUseCase>(),
          deleteContact: gh<_i96.DeleteContactUseCase>(),
          getUniqueCountries: gh<_i96.GetUniqueCountriesUseCase>(),
        ));
    gh.lazySingleton<_i161.AuthRemoteDatasource>(
        () => _i161.AuthRemoteDatasourceImpl(
              gh<_i454.SupabaseClient>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.factory<_i502.GetAllRelationshipTypesUseCase>(() =>
        _i502.GetAllRelationshipTypesUseCase(
            gh<_i784.RelationshipTypeRepository>()));
    gh.factory<_i502.GetRelationshipTypeByIdUseCase>(() =>
        _i502.GetRelationshipTypeByIdUseCase(
            gh<_i784.RelationshipTypeRepository>()));
    gh.lazySingleton<_i1022.RelationshipTypeBloc>(() =>
        _i1022.RelationshipTypeBloc(
            getAll: gh<_i502.GetAllRelationshipTypesUseCase>()));
    gh.factory<_i843.GetTransactionsByUserUseCase>(() =>
        _i843.GetTransactionsByUserUseCase(gh<_i421.TransactionRepository>()));
    gh.factory<_i843.GetTransactionByIdUseCase>(() =>
        _i843.GetTransactionByIdUseCase(gh<_i421.TransactionRepository>()));
    gh.factory<_i843.CreateTransactionUseCase>(() =>
        _i843.CreateTransactionUseCase(gh<_i421.TransactionRepository>()));
    gh.factory<_i843.UpdateTransactionUseCase>(() =>
        _i843.UpdateTransactionUseCase(gh<_i421.TransactionRepository>()));
    gh.factory<_i843.DeleteTransactionUseCase>(() =>
        _i843.DeleteTransactionUseCase(gh<_i421.TransactionRepository>()));
    gh.factory<_i432.ContactDetailBloc>(() => _i432.ContactDetailBloc(
          updateContact: gh<_i96.UpdateContactUseCase>(),
          deleteContact: gh<_i96.DeleteContactUseCase>(),
        ));
    gh.factory<_i439.TransactionsBloc>(() => _i439.TransactionsBloc(
          getTransactionsByUser: gh<_i843.GetTransactionsByUserUseCase>(),
          createTransaction: gh<_i843.CreateTransactionUseCase>(),
          updateTransaction: gh<_i843.UpdateTransactionUseCase>(),
          deleteTransaction: gh<_i843.DeleteTransactionUseCase>(),
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
