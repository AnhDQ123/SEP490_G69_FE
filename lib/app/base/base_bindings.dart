import 'package:get/get_instance/src/bindings_interface.dart';

abstract class BaseBindings extends Bindings {
  @override
  void dependencies() {
    injectService();
  }

  void injectService();
}