import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:to_do_list/inject.config.dart';

// @module
// abstract class InjectTableModule {
//   @lazySingleton
//   NoteBloc get notebloc;
// }

final getIt = GetIt.instance;
@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true,
)
void configureDependencies() {
  getIt.init();
}
