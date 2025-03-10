import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // (0 = Đồ ăn, 1 = Chợ tươi sống)
  var selectedFoodTab = 0.obs;

  // Current index của BottomNav (2 = "Trang chủ" mặc định)
  var bottomNavIndex = 2.obs;

  // Banner hiện tại
  final currentBannerIndex = 0.obs;

  // fake data category
  final List<Map<String, dynamic>> categories = [
    {'name': 'Giảm giá', 'image': 'assets/images/giam_gia.jpg'},
    {'name': 'Trà sữa', 'image': 'assets/images/tra_sua.jpg'},
    {'name': 'Đồ ăn nhanh', 'image': 'assets/images/do_an_nhanh.jpg'},
    {'name': 'Mỳ,bún,phở', 'image': 'assets/images/my_bun_pho.jpg'},
    {'name': 'Voucher', 'image': 'assets/images/voucher.jpg'},
    {'name': 'Các quán ăn', 'image': 'assets/images/quan_an.jpg'},
    {'name': 'Đồ chay', 'image': 'assets/images/do_chay.jpg'},
    {'name': 'Rau', 'image': 'assets/images/rau.jpg'},
    {'name': 'Cá', 'image': 'assets/images/ca.jpg'},
    {'name': 'Thịt & trứng', 'image': 'assets/images/thit_trung.jpg'},
    {'name': 'Khác', 'image': 'assets/images/khac.png'},
  ];

  // best seller day
  final List<Map<String, String>> bestSellerFoods = [
    {
      'name': 'Phở bò Nam Định',
      'rating': '8.3',
      'price': '50.000đ',
      'oldPrice': '60.000đ',
      'image': 'assets/images/pho_bo.jpg',
    },
    {
      'name': 'Bún bò Huế',
      'rating': '8.3',
      'price': '50.000đ',
      'oldPrice': '60.000đ',
      'image': 'assets/images/bun_bo_hue.jpg',
    },
    {
      'name': 'Bánh mỳ chảo',
      'rating': '8.3',
      'price': '50.000đ',
      'oldPrice': '60.000đ',
      'image': 'assets/images/banh_my_chao.jpg',
    },
  ];

  // recommend food
  final List<Map<String, String>> recommendedFoods = [
    {
      'name': 'Mì Quảng',
      'rating': '8.0',
      'price': '45.000đ',
      'oldPrice': '55.000đ',
      'image': 'assets/images/mi_quang.jpg',
    },
    {
      'name': 'Bánh xèo',
      'rating': '7.9',
      'price': '40.000đ',
      'oldPrice': '50.000đ',
      'image': 'assets/images/banh_xeo.jpg',
    },
    {
      'name': 'Bánh cuốn',
      'rating': '7.5',
      'price': '30.000đ',
      'oldPrice': '40.000đ',
      'image': 'assets/images/banh_cuon.jpg',
    },
    {
      'name': 'Gỏi cuốn',
      'rating': '8.1',
      'price': '35.000đ',
      'oldPrice': '45.000đ',
      'image': 'assets/images/goi_cuon.jpg',
    },
  ];

  // fake data do an list
  final List<Map<String, String>> doAnList = [
    {
      "name": "Cơm tấm",
      "image": "assets/images/com_tam.jpg",
      "sold": "50",
      "likes": "10",
      "price": "40.000đ",
      "oldPrice": "50.000đ",
      "sale": "-20%"
    },
    {
      "name": "Bánh canh",
      "image": "assets/images/banh_canh.jpg",
      "sold": "30",
      "likes": "8",
      "price": "35.000đ",
      "oldPrice": "45.000đ",
      "sale": "-22%"
    },
    {
      "name": "Cháo gà",
      "image": "assets/images/chao_ga.jpg",
      "sold": "20",
      "likes": "5",
      "price": "30.000đ",
      "oldPrice": "40.000đ",
      "sale": "-10%"
    },
    {
      "name": "Mì vịt tiềm",
      "image": "assets/images/mi_vit_tiem.jpg",
      "sold": "15",
      "likes": "3",
      "price": "45.000đ",
      "oldPrice": "55.000đ",
      "sale": "-15%"
    },
    {
      "name": "Lẩu bò",
      "image": "assets/images/lau_bo.jpg",
      "sold": "10",
      "likes": "2",
      "price": "50.000đ",
      "oldPrice": "60.000đ",
      "sale": "-5%"
    },
    {
      "name": "Bánh bèo",
      "image": "assets/images/banh_beo.jpg",
      "sold": "5",
      "likes": "1",
      "price": "40.000đ",
      "oldPrice": "50.000đ",
      "sale": "-5%"
    },
    {
      "name": "Bánh hỏi",
      "image": "assets/images/banh_hoi.jpg",
      "sold": "5",
      "likes": "1",
      "price": "40.000đ",
      "oldPrice": "50.000đ",
      "sale": "-5%"
    },
  ];

  // fake data for cho tuoi song
  final List<Map<String, String>> choTuoiSongList = [
    {
      "name": "Thịt heo",
      "image": "assets/images/thit_heo.jpg",
      "sold": "50",
      "likes": "10",
      "price": "40.000đ",
      "oldPrice": "50.000đ",
      "sale": "-20%"
    },
    {
      "name": "Thịt gà",
      "image": "assets/images/thit_ga.jpg",
      "sold": "30",
      "likes": "8",
      "price": "35.000đ",
      "oldPrice": "45.000đ",
      "sale": "-22%"
    },
    {
      "name": "Cá hồi",
      "image": "assets/images/ca_hoi.jpg",
      "sold": "20",
      "likes": "5",
      "price": "30.000đ",
      "oldPrice": "40.000đ",
      "sale": "-10%"
    },
    {
      "name": "Rau muống",
      "image": "assets/images/rau_muong.jpg",
      "sold": "15",
      "likes": "3",
      "price": "45.000đ",
      "oldPrice": "55.000đ",
      "sale": "-15%"
    },
    {
      "name": "Cà rốt",
      "image": "assets/images/ca_rot.jpg",
      "sold": "10",
      "likes": "2",
      "price": "50.000đ",
      "oldPrice": "60.000đ",
      "sale": "-5%"
    },
    {
      "name": "Hành tây",
      "image": "assets/images/hanh_tay.jpg",
      "sold": "5",
      "likes": "1",
      "price": "40.000đ",
      "oldPrice": "50.000đ",
      "sale": "-5%"
    },
    {
      "name": "Nấm kim châm",
      "image": "assets/images/nam_kim_cham.jpg",
      "sold": "5",
      "likes": "1",
      "price": "40.000đ",
      "oldPrice": "50.000đ",
      "sale": "-5%"
    },
  ];

  // Lấy danh sách hiển thị theo tab (0 = Đồ ăn, 1 = Chợ tươi sống)
  List<Map<String, String>> get currentList =>
      (selectedFoodTab.value == 0) ? doAnList : choTuoiSongList;

  void switchFoodTab(int tabIndex) {
    selectedFoodTab.value = tabIndex;
  }

  void switchBottomNav(int index) {
    bottomNavIndex.value = index;
  }
}
