import 'package:get/get.dart';

import '../modules/add_blog/bindings/add_blog_binding.dart';
import '../modules/add_blog/views/add_blog_view.dart';
import '../modules/blog_detail/bindings/blog_detail_binding.dart';
import '../modules/blog_detail/views/blog_detail_view.dart';
import '../modules/bloglist/bindings/bloglist_binding.dart';
import '../modules/bloglist/views/bloglist_view.dart';

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
      name: _Paths.ADD_BLOG,
      page: () => const AddBlogView(),
      binding: AddBlogBinding(),
    ),
    GetPage(
      name: _Paths.BLOG_DETAIL,
      page: () => const BlogDetailView(),
      binding: BlogDetailBinding(),
    ),
  ];
}
