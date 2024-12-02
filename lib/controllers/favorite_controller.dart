import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../data/model/base_data.dart';
import '../services/hive_service.dart';

class FavoriteController extends GetxController {
  final RxList<BaseData> _favorites = <BaseData>[].obs; // Reactive list

  List<BaseData> get favorites => _favorites;

  var hiveBoxHelper = HiveBoxHelper();

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  void _loadFavorites() async {
    // final box = await Hive.openBox<BaseData>('favorites');
    final box = await hiveBoxHelper.openBox<BaseData>('favorites');
    _favorites.assignAll(box.values.toList());
  }

  // Toggle favorite status for a task
  void toggleFavorite(BaseData data) async {
    // final box = await Hive.openBox<BaseData>('favorites');
    final box = await hiveBoxHelper.openBox<BaseData>('favorites');
    if (isFavorite(data)) {
      _favorites.removeWhere((item) => item.id == data.id);
      await box.delete(data.id);
    } else {
      _favorites.add(data);
      await box.put(data.id, data);
    }
  }

  // void toggleFavorite(BaseData data) async {
  //   final box = await Hive.openBox<BaseData>('favorites');
  //   if (_favorites.contains(data)) {
  //     _favorites.remove(data);
  //     await box.delete(data.id);
  //   } else {
  //     _favorites.add(data);
  //     await box.put(data.id, data);
  //   }
  // }

  bool isFavorite(BaseData data) {
    return _favorites.any((item) => item.id == data.id);
  }

  // Reactive count of favorite tasks
  int get favoriteCount => _favorites.length;
}