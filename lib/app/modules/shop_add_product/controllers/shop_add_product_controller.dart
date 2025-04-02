import 'dart:io';
import 'package:ffb_fe_flutter/app/modules/shop_menu/controllers/shop_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/food_option.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/product_discount.dart';
import '../../../routes/app_pages.dart';
import '../../../service/category_service.dart';
import '../../../service/product_service.dart';

  class ShopAddProductController extends GetxController {
    var isEditing = false.obs;

    // Trường dữ liệu sản phẩm
    var avatar = Rxn<File>();
    final avatarUrl = RxnString(); // thêm dòng này để lưu ảnh từ server (dạng URL)

  var productName = "".obs;
  var productDescription = "".obs;
  var manufacturer = "".obs;
  var supplier = "".obs;
  var type = "".obs;


    var quantity = 0.obs;
    var quantityController = TextEditingController();

    // Danh mục và lựa chọn sản phẩm
    var categories = <Category>[].obs;
    var selectedCategory = "".obs;
    Future<void> loadCategories() async {
      try {
        final categoryService = CategoryService();
        final fetchedCategories = await categoryService.fetchCategories();
        categories.assignAll(fetchedCategories);
      } catch (e) {
        Get.snackbar("Lỗi", "Không thể tải danh mục: $e");
      }
    }

    var sizes = <FoodOption>[].obs;
    var options = <FoodOption>[].obs;

    final ImagePicker picker = ImagePicker();

    @override
    void onInit() {
      super.onInit();


      loadCategories();
      // Lấy productId từ arguments khi màn hình AddProduct được mở
      final int productId = Get.arguments ?? 0;

      if (productId != 0) {
        isEditing.value = true;
        loadProductDetail(productId);
      }
    }

    void loadProductDetail(int productId) async {
      final product = await ProductService.fetchProductDetail(productId);
      if (product != null) {
        // Nếu sản phẩm tồn tại, cập nhật các trường dữ liệu
        productName.value = product.name;
        productDescription.value = product.description;
        selectedCategory.value = product.category;
        manufacturer.value = product.manufacturer;
        supplier.value = product.supplier;

        if (product.image.isNotEmpty && product.image.startsWith("http")) {
          avatar.value = null;
          avatarUrl.value = product.image; // lưu vào biến URL riêng
        }


        // Cập nhật số lượng sản phẩm từ dữ liệu API
        quantity.value = product.quantity;  // Cập nhật giá trị quantity
        quantityController.text = quantity.value.toString();  // Đồng bộ TextEditingController

        // Có thể cập nhật các lựa chọn (size và option) nếu cần
        sizes.assignAll(product.foodOptions.where((option) => option.typeId == 2)); // Lọc size
        options.assignAll(product.foodOptions.where((option) => option.typeId == 1)); // Lọc option
        print("Product: $product");
      } else {
        // Xử lý nếu không tải được chi tiết sản phẩm
        Get.snackbar("Lỗi", "Không thể tải chi tiết sản phẩm.");
      }
    }

    // Ảnh
    Future<void> pickImageFromGallery(Rxn<File> imageController) async {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageController.value = File(pickedFile.path);
      }
    }
    Future<void> pickImageFromCamera(Rxn<File> imageController) async {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        imageController.value = File(pickedFile.path);
      }
    }
    void removeImage(Rxn<File> imageController) {
      imageController.value = null;
    }


    //Thêm sửa xóa size, option
    void addSizeOption(FoodOption option) => sizes.add(option);
    void editSizeOption(FoodOption updatedOption) {
      final index = sizes.indexWhere((option) => option.id == updatedOption.id);
      if (index != -1) {
        sizes[index] = updatedOption;
        sizes.refresh();
      }
    }
    void removeSizeOption(int id) => sizes.removeWhere((size) => size.id == id);

    void addFoodOption(FoodOption option) => options.add(option);
    void editFoodOption(FoodOption updatedOption) {
      final index = options.indexWhere((option) => option.id == updatedOption.id);
      if (index != -1) {
        options[index] = updatedOption;
        options.refresh();
      }
    }
    void removeFoodOption(int id) => options.removeWhere((option) => option.id == id);

    // Tăng giảm số lượng
    void increaseQuantity() {
      if (quantity.value < 9999) quantity.value++;
      quantityController.text = quantity.value.toString();
    }
    void decreaseQuantity() {
      if (quantity.value > 0) quantity.value--;
      quantityController.text = quantity.value.toString();
    }

    // Cập nhật số lượng sản phẩm
    void updateQuantity(String value) {
      if (value.isNotEmpty) {
        final newQuantity = int.tryParse(value);
        if (newQuantity != null && newQuantity >= 0 && newQuantity <= 9999) {
          quantity.value = newQuantity;
          quantityController.text = quantity.value.toString();
        }
      }
    }

    // Lưu hoặc cập nhật sản phẩm
    Future<void> saveProduct() async {
      if (productName.value.isEmpty) {
        Get.snackbar("Lỗi", "Tên sản phẩm không được để trống!");
        return;
      }

      if (sizes.isEmpty) {
        Get.snackbar("Lỗi", "Vui lòng thêm ít nhất một kích cỡ sản phẩm!");
        return;
      }

      // Gộp các options
      final allOptions = [
        ...sizes.map((size) => FoodOption(
          id: size.id,
          name: size.name,
          price: size.price,
          image: size.image,
          typeId: 2,
          productId: 0,
        )),
        ...options.map((option) => FoodOption(
          id: option.id,
          name: option.name,
          price: option.price,
          image: option.image,
          typeId: 1,
          productId: 0,
        )),
      ];

      // ✅ Chuyển các ảnh foodOptions sang File nếu không phải URL
      final imageFiles = allOptions
          .where((option) => option.image != null && !option.image!.startsWith('http'))
          .map((option) => File(option.image!))
          .toList();

    final newProduct = ProductDiscount(
      id: 0,
      name: productName.value,
      description: productDescription.value,
      manufacturer: manufacturer.value,
      supplier: supplier.value,
      quantity: quantity.value,
      type: type.value,
      category: selectedCategory.value,
      discount: [],
      foodOptions: allOptions,
      image: '',
      rate: 0,
      shop: '',
      defaultPrice: 0,
      status: '',
    );

    final success = await ProductService.createProduct(
      newProduct,
      avatar.value,      // avatar là Rxn<File> — null nếu không chọn
      imageFiles,        // chỉ gửi ảnh mới thêm (File), không gửi URL
        Get.find<ShopController>().shopId,
    );

      if (success) {
        Get.snackbar("Thành công", "Sản phẩm đã được thêm!");
        Get.offNamed(Routes.SHOP_PRODUCT_LIST);
      } else {
        Get.snackbar("Lỗi", "Không thể lưu sản phẩm.");
      }
    }

  }
