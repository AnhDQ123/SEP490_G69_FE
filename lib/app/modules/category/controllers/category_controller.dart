import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/models/category.dart';

import '../../../service/category_service.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  var categories = <Category>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _categoryService.fetchCategories();
      categories.assignAll(result);
    } catch (e) {
      errorMessage(e.toString());
      print('Error loading categories: $e');
    } finally {
      isLoading(false);
    }
  }
}