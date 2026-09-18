import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/data/service/carrier_service.dart';
import 'package:zachranobed/common/data/service/configuration_service.dart';
import 'package:zachranobed/common/data/service/entity_pairs_service.dart';
import 'package:zachranobed/common/data/service/paired_entity_service.dart';
import 'package:zachranobed/features/menu/data/repository/firebase_contacts_repository.dart';
import 'package:zachranobed/features/menu/domain/repository/contacts_repository.dart';
import 'package:zachranobed/features/menu/domain/usecase/get_contacts_use_case.dart';

class MenuDependencyContainer {
  const MenuDependencyContainer._();

  static void setup() {
    GetIt.I.registerFactory<ContactsRepository>(
      () => FirebaseContactsRepository(
        GetIt.I<PairedEntityService>(),
        GetIt.I<EntityPairService>(),
        GetIt.I<ConfigurationService>(),
        GetIt.I<CarrierService>(),
      ),
    );

    GetIt.I.registerFactory<GetContactsUseCase>(
      () => GetContactsUseCase(
        GetIt.I<ContactsRepository>(),
      ),
    );
  }
}
