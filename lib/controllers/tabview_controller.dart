import 'package:get/get.dart';

class TabViewController extends GetxController {
  RxInt _selectedIndex = 0.obs;
  getIndex() => _selectedIndex.value;
  setIndex(index) => _selectedIndex.value = index;
}
