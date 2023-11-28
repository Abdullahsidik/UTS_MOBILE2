import 'package:abdullahsidik_uts/controller/button_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    bottomNavigationBarController controller = Get.put(bottomNavigationBarController());
    return Scaffold(
      
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child:  GNav(
          backgroundColor: Color.fromARGB(255, 253, 252, 252),
            color: Color.fromARGB(255, 218, 164, 18),
            activeColor: Colors.white,
            tabBackgroundColor: Color.fromARGB(255, 218, 164, 18),
            gap: 5,
            padding: EdgeInsets.all(16),
            onTabChange: (value) {
              print(value);
              controller.index.value = value; 
            },
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.search,
              text: 'search',
            ),
            GButton(
              icon: Icons.add,
              text: 'Add',
            ),
            GButton(
              icon: Icons.list,
              text: 'List',
            ),
            GButton(
              icon: Icons.account_box,
              text: 'about',
            ),
            
          ],
        ),
      ),
      body: Obx(() =>  controller.pages[controller.index.value],
      )
    );
  }
}
