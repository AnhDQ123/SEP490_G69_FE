import 'package:ffb_fe_flutter/app/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../controllers/shop_register_controller.dart';

class Step2 extends StatelessWidget {
  final ShopRegisterController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextConstant.titleH2(
            context,
            text: "Vui lòng đọc kỹ điều khoản và điều kiện",
          ),
          SizedBox(height: 12),
          FutureBuilder<String>(
            future: _copyPdfFromAssets(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return GestureDetector(
                  onTap: () => _openPdf(context, snapshot.data!),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: PDFView(filePath: snapshot.data!),
                  ),
                );
              } else {
                return Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Nút mở PDF để xem
              IconButton(
                icon: Icon(Icons.visibility, color: Colors.black),
                onPressed: () async {
                  final path = await _copyPdfFromAssets();
                  _openPdf(context, path);
                },
              ),
              // Nút tải xuống
              IconButton(
                icon: Icon(Icons.download, color: Colors.black),
                onPressed: () async {
                  final path = await _copyPdfFromAssets();
                  Get.snackbar(
                    "Thành công",
                    "File đã được tải về tại $path",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 12),
          Obx(() => CheckboxListTile(
            value: controller.isTermsAccepted.value,
            onChanged: (value) {
              controller.isTermsAccepted(value!);
            },
            title: TextConstant.subTile2 (
              context,
              text:
              "Tôi xác nhận rằng đã đọc tất cả các điều khoản và điều kiện nêu trên và đồng ý với Fast F&B để trở thành đối tác bán hàng của Fast F&B",
            ),
            controlAffinity: ListTileControlAffinity.leading,
          )),

          SizedBox(height: 8),
          TextConstant.subTile2(
            context,
            text:
            "• Bằng việc tiếp tục đăng ký, Đối tác đồng ý sẽ chịu toàn bộ trách nhiệm liên quan đến việc đăng bán **SẢN PHẨM BỊ CẤM** trên Fast F&B",
          ),
        ],
      ),
    );
  }

  Future<String> _copyPdfFromAssets() async {
    final ByteData bytes = await rootBundle.load('assets/terms_and_conditions.pdf');
    final file = File('${(await getTemporaryDirectory()).path}/terms_and_conditions.pdf');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file.path;
  }

  void _openPdf(BuildContext context, String path) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PdfViewPage(pdfPath: path)),
    );
  }
}

class PdfViewPage extends StatelessWidget {
  final String pdfPath;

  PdfViewPage({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Điều khoản và điều kiện")),
      body: PDFView(filePath: pdfPath),
    );
  }
}
