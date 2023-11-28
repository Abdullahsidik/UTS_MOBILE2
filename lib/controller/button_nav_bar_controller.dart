import 'package:abdullahsidik_uts/screen/aboutPage.dart';
import 'package:abdullahsidik_uts/screen/addPage.dart';
import 'package:abdullahsidik_uts/screen/homePage.dart';
import 'package:abdullahsidik_uts/screen/listPage.dart';
import 'package:abdullahsidik_uts/screen/searchhotel.dart';

import 'package:get/get.dart';

class bottomNavigationBarController extends GetxController{
RxInt index = 0.obs;

var pages = [
   HomePage(),
   SearchHotel(),
   AddPage(),
   ListPage(),
   AboutPage()
];

}