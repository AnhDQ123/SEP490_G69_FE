  import 'dart:io';
import 'dart:math';
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
    var isLoading = false.obs;

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
        type.value = product.type ?? '';

        if (product.image.isNotEmpty && product.image.startsWith("http")) {
          avatar.value = null;
          avatarUrl.value = product.image; // lưu vào biến URL riêng
        }

        quantity.value = product.quantity;  // Cập nhật giá trị quantity
        quantityController.text = quantity.value.toString();  // Đồng bộ TextEditingController

        // Có thể cập nhật các lựa chọn (size và option) nếu cần
        sizes.assignAll(product.foodOptions.where((option) => option.typeId == 2)); // Lọc size
        options.assignAll(product.foodOptions.where((option) => option.typeId == 1)); // Lọc option
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

    Future<void> saveProduct() async {
      // Bật trạng thái loading
      isLoading.value = true;

      try {
        // Validate dữ liệu
        if (productName.value.isEmpty) {
          throw "Tên sản phẩm không được để trống!";
        }

        if (selectedCategory.value.isEmpty) {
          throw "Vui lòng chọn danh mục sản phẩm!";
        }

        if (type.value.isEmpty) {
          throw "Vui lòng chọn loại sản phẩm!";
        }

        if (sizes.isEmpty) {
          throw "Vui lòng thêm ít nhất một kích cỡ sản phẩm!";
        }

        // Kiểm tra avatar: Nếu avatar là file, ta gửi file, nếu là URL thì gửi URL
        String? avatarImagePath = avatarUrl.value;  // Nếu không có ảnh mới, dùng avatar cũ (URL)

        // Nếu có avatar mới, thay thế URL cũ bằng ảnh mới
        if (avatar.value != null) {
          avatarImagePath = null;  // Nếu có ảnh mới, sử dụng file (avatar.value)
        }

        // Gộp các options
        final allOptions = [
          ...sizes.map((size) => FoodOption(
            id: size.id,
            name: size.name,
            price: size.price,
            image: size.image,
            typeId: 2, // typeId 2 = kích cỡ
            productId: isEditing.value ? Get.arguments : 0,
          )),
          ...options.map((option) => FoodOption(
            id: option.id,
            name: option.name,
            price: option.price,
            image: option.image,
            typeId: 1, // typeId 1 = option
            productId: isEditing.value ? Get.arguments : 0,
          )),
        ];

        // Lọc ra các ảnh cần upload - chỉ lấy các ảnh là file, không phải URL
        final imageFiles = allOptions
            .where((option) => option.image != null && !option.image!.startsWith('http'))
            .map((option) => File(option.image!))  // Chuyển ảnh là file cục bộ thành File
            .toList();

        // Tạo đối tượng sản phẩm với avatar là file hoặc URL
        final product = ProductDiscount(
          id: isEditing.value ? Get.arguments : 0,
          name: productName.value,
          description: productDescription.value,
          manufacturer: manufacturer.value,
          supplier: supplier.value,
          quantity: quantity.value,
          category: selectedCategory.value,
          type: type.value,
          discount: [],
          foodOptions: allOptions,
          image: avatarImagePath ?? '', // Giữ lại URL ảnh cũ nếu không có ảnh mới
          rate: 0,
          shop: '',
          defaultPrice: allOptions.isNotEmpty
              ? allOptions.map((e) => e.price).reduce(min)
              : 0,
          status: 'ACTIVE',
        );

        print(product);

        bool success;
        if (isEditing.value) {
          success = await ProductService.updateProduct(
              product,
              avatar.value,  // Ảnh đại diện mới (nếu có)
              imageFiles,
              product.id
          );
        } else {
          success = await ProductService.addProduct(
            product,
            avatar.value,  // Ảnh đại diện mới (nếu có)
            imageFiles,    // Danh sách ảnh options mới
          );
        }

        if (success) {
          Get.snackbar(
            "Thành công",
            isEditing.value ? "Cập nhật sản phẩm thành công!" : "Thêm sản phẩm thành công!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.offNamed(Routes.SHOP_PRODUCT_LIST);
        } else {
          throw "Đã xảy ra lỗi khi lưu sản phẩm";
        }
      } catch (e) {
        Get.snackbar(
          "Lỗi",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        // Tắt trạng thái loading dù thành công hay thất bại
        isLoading.value = false;
      }
    }


  }
