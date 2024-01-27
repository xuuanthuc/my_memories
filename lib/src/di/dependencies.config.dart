// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:my_memories/src/screens/newsfeed/bloc/newsfeed_cubit.dart'
    as _i4;
import 'package:my_memories/src/screens/root/bloc/bottom_sheet_cubit.dart'
    as _i3;
import 'package:my_memories/src/screens/root/bloc/root_cubit.dart' as _i5;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt $initDependencies({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.BottomSheetCubit>(() => _i3.BottomSheetCubit());
    gh.factory<_i4.NewsfeedCubit>(() => _i4.NewsfeedCubit());
    gh.factory<_i5.RootCubit>(() => _i5.RootCubit());
    return this;
  }
}
