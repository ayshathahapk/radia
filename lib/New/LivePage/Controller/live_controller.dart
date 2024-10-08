import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radia/New/LivePage/Repository/live_repository_new.dart';

import '../../../Models/commodities_model.dart';
import '../../../Models/news_model.dart';
import '../../../Models/spot_rate_model.dart';
import '../../../Models/spread_document_model.dart';

final liveControllerProvider = Provider(
  (ref) => LiveController(liveRepository: ref.watch(liveRepositoryNewProvider)),
);
// final spreadDataProvider = FutureProvider<SpreadDocumentModel>(
//   (ref) {
//     return ref.watch(liveControllerProvider).getSpread();
//   },
// );
// final commoditiesStream = StreamProvider(
//   (ref) {
//     return ref.watch(liveControllerProvider).commodities();
//   },
// );
// final newsStream = StreamProvider(
//   (ref) {
//     return ref.watch(liveControllerProvider).getNews();
//   },
// );
final spotRateProvider = FutureProvider(
  (ref) {
    return ref.watch(liveControllerProvider).getSpotRate();
  },
);

class LiveController {
  final LiveRepositoryNew _liveRepositoryNew;
  LiveController({required LiveRepositoryNew liveRepository})
      : _liveRepositoryNew = liveRepository;

  // Future<SpreadDocumentModel> getSpread() async {
  //   return _liveRepositoryNew.getSpread();
  // }
  //
  // Stream<List<CommoditiesModel>> commodities() {
  //   return _liveRepositoryNew.commodities();
  // }
  //
  // Stream<NewsModel> getNews() {
  //   return _liveRepositoryNew.getNews();
  // }

  Future<SpotRateModel?> getSpotRate() async {
    SpotRateModel? spotRateModel;
    final res = await _liveRepositoryNew.getSpotRate();
    res.fold(
      (l) {
        print("###ERROR###");
        print(l.message);
      },
      (r) {
        spotRateModel = r;
      },
    );
    return spotRateModel;
  }
}
