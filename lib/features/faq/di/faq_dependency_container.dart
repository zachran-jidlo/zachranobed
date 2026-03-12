import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/faq/data/repository/firebase_faq_repository.dart';
import 'package:zachranobed/features/faq/data/service/faq_service.dart';
import 'package:zachranobed/features/faq/domain/repository/faq_repository.dart';
import 'package:zachranobed/features/faq/domain/usecase/observe_faq_items_use_case.dart';

class FaqDependencyContainer {
  const FaqDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton(FaqService());

    GetIt.I.registerFactory<FaqRepository>(
      () => FirebaseFaqRepository(
        GetIt.I<FaqService>(),
      ),
    );

    GetIt.I.registerFactory<ObserveFaqItemsUseCase>(
      () => ObserveFaqItemsUseCase(
        GetIt.I<FaqRepository>(),
      ),
    );
  }
}
