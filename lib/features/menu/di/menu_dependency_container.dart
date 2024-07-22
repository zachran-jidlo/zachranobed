import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/menu/data/repository/firebase_contacts_repository.dart';
import 'package:zachranobed/features/menu/domain/repository/contacts_repository.dart';
import 'package:zachranobed/features/menu/domain/usecase/get_contacts_use_case.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/entity_service.dart';

class MenuDependencyContainer {
  const MenuDependencyContainer._();

  static void setup() {
    GetIt.I.registerFactory<ContactsRepository>(
      () => FirebaseContactsRepository(
        GetIt.I<EntityService>(),
        GetIt.I<EntityPairService>(),
      ),
    );

    GetIt.I.registerFactory<GetContactsUseCase>(
      () => GetContactsUseCase(
        GetIt.I<ContactsRepository>(),
      ),
    );
  }
}
