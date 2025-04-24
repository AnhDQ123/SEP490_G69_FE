import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../service/search_service.dart';
import '../../filter/controllers/filter_controller.dart';

class SearchScreenView extends StatefulWidget {
  const SearchScreenView({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreenView> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool showAllResults = false;

  void _onSearch(String query) async {
    if (query.isNotEmpty) {
      try {
        final results = await SearchService().searchProducts(query);
        print("Results from API: $results");
        setState(() {
          searchResults = results;
          showAllResults = false;
        });
      } catch (e) {
        print('Error occurred while searching: $e');
      }
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedResults = showAllResults ? searchResults : searchResults.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm sản phẩm'),
        backgroundColor: Color.fromRGBO(212, 163, 115, 1),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Thanh tìm kiếm
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm sản phẩm...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,  // Màu chữ khi nhập
                      ),
                      onChanged: _onSearch,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Khoảng cách giữa thanh tìm kiếm và kết quả

            // Hiển thị kết quả tìm kiếm nếu có
            Expanded(
              child: ListView.builder(
                itemCount: displayedResults.length + (searchResults.length > 5 ? 1 : 0),  // Thêm 1 item cho nút "Xem thêm"
                itemBuilder: (context, index) {
                  if (index < displayedResults.length) {
                    return ListTile(
                        title: Text(
                          displayedResults[index]['name'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          String productName = displayedResults[index]['name'];
                          Get.toNamed('/filter', arguments: {'searchKeyword': productName});
                        }


                    );

                  } else {
                    // Hiển thị nút "Xem thêm" nếu có nhiều hơn 5 sản phẩm
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              showAllResults = true;  // Hiển thị toàn bộ kết quả khi nhấn "Xem thêm"
                            });
                          },
                          child: const Text(
                            'Xem thêm',
                            style: TextStyle(fontSize: 10,color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
