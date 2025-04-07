import 'package:get/get.dart';

import '../modules/add_blog/bindings/add_blog_binding.dart';
import '../modules/add_blog/views/add_blog_view.dart';
import '../modules/blogdetail/bindings/blogdetail_binding.dart';
import '../modules/blogdetail/views/blogdetail_view.dart';
import '../modules/bloglist/bindings/bloglist_binding.dart';
import '../modules/bloglist/views/bloglist_view.dart';
import '../modules/image_viewer/bindings/image_viewer_binding.dart';
import '../modules/image_viewer/views/image_viewer_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.BLOGLIST,
      page: () => BloglistView(),
      binding: BloglistBinding(),
    ),
    GetPage(
      name: _Paths.ADDBLOG,
      page: () => BloglistView(),
      binding: BloglistBinding(),
    ),
    GetPage(
      name: _Paths.BLOGDETAIL,
      page: () => BlogdetailView(),
      binding: BlogdetailBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE_VIEWER,
      page: () => ImageViewerView(),
      binding: ImageViewerBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BLOG,
      page: () => const AddBlogView(),
      binding: AddBlogBinding(),
    ),
  ];
}
