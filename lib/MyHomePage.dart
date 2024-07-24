import 'package:dictionary_app/Translate.dart';
import 'package:dictionary_app/db_helper.dart';
import 'package:dictionary_app/mydata.dart';
import 'package:dictionary_app/theme/ThemeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selected = 0;
  final controller = PageController();
  late Mydata d;
  late DBHelper dbHelper;
  late ThemeController themeController;

  @override
  void initState() {
    super.initState();
    d = Get.find<Mydata>();
    themeController = Get.find<ThemeController>();
    dbHelper = DBHelper();
    fetchData("");
  }

  //function to get the data where value from database
  void fetchData(String value) async {
    DBHelper helper = DBHelper();
    d.listdata.value =
        await helper.select("SELECT * FROM Items WHERE word LIKE '%$value%'");
  }

  //function to get data from fav table field
  void fetchFavorites() async {
    d.favlist.value =
        await dbHelper.select("SELECT * FROM Items WHERE fav = 1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: Icon(
          Icons.type_specimen_sharp,
          color: Colors.white,
          size: 32,
        ),
        title: Text(
          'វចនានុក្រមខ្មែរ',
          style: TextStyle(
            fontFamily: 'KhmerOSMoul',
            fontSize: 22,
            color: Colors.white,
          ),
        ),

        //Container light mode dark mode
        actions: [
          Obx(() => Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            themeController.isDark.value
                                ? Icons.brightness_2
                                : Icons.wb_sunny,
                            color: themeController.isDark.value
                                ? Colors.yellow
                                : Colors.grey.shade600,
                          ),
                          onPressed: () {
                            themeController.changeTheme();
                          },
                        ),
                        SizedBox(width: 4),
                        Text(
                          themeController.isDark.value ? 'Light' : 'Dark',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],

        bottom: PreferredSize(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            // decoration: BoxDecoration(
            // ),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              padding: EdgeInsets.only(left: 10, top: 2, bottom: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                onChanged: (value) {
                  fetchData(value);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for Words',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: Icon(
                    CupertinoIcons.mic,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(100),
        ),
      ),
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            selected = index;
            if (index == 1) {
              fetchFavorites();
            }
          });
        },
        children: [
          homeContent(), // Display the home content page
          favoriteContent(),
          Center(child: Text('History')),
          Center(child: Text('Scanner')),
        ],
      ),
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.blink,
          iconStyle: IconStyle.Default,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.house_outlined, size: 40),
            selectedIcon: const Icon(Icons.home_outlined, size: 40),
            selectedColor: Colors.pink,
            unSelectedColor: Colors.grey,
            title: const Text('Home'),
            badgeColor: Colors.purple,
            badgePadding: const EdgeInsets.only(left: 4, right: 4),
          ),
          BottomBarItem(
            icon: const Icon(Icons.bookmark_outline_rounded, size: 40),
            selectedIcon: const Icon(Icons.bookmark_rounded, size: 40),
            selectedColor: Colors.pink,
            title: const Text('Saved'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.history_rounded, size: 40),
            selectedIcon:
                const Icon(Icons.history_toggle_off_rounded, size: 40),
            selectedColor: Colors.pink,
            title: const Text('History'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.camera_enhance_outlined, size: 40),
            selectedIcon: const Icon(Icons.camera_enhance_outlined, size: 40),
            selectedColor: Colors.pink,
            title: const Text('Scanner'),
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: selected,
        notchStyle: NotchStyle.circle,
        onTap: (index) {
          if (index == selected) return;
          controller.jumpToPage(index);
          setState(() {
            selected = index;
            if (index == 1) {
              fetchFavorites();
            }
          });
        },
      ),
    );
  }

  Widget homeContent() {
    return Obx(() {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: d.listdata.length,
        itemBuilder: (context, index) {
          var item = d.listdata[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TranslatePage(item: item),
                ),
              );
            },
            child: contentContainer(item),
          );
        },
      );
    });
  }

  Widget favoriteContent() {
    return Obx(() {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: d.favlist.length,
        itemBuilder: (context, index) {
          var item = d.favlist[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TranslatePage(item: item),
                ),
              );
            },
            child: contentContainer(item),
          );
        },
      );
    });
  }

  Container contentContainer(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // color: Theme.of(context).colorScheme.background,
            color: Colors.grey.shade600,
            blurRadius: 7,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: ListTile(
        leading: Icon(
          Icons.star,
          color: Colors.pink,
          size: 32,
        ),
        title: Text(
          item['word'],
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'KhmerOSBattambang'),
        ),
        trailing: IconButton(
          onPressed: () async {
            final newFavStatus = item['fav'] == 1 ? 0 : 1;
            await dbHelper.toggleFavorite(item['id'], newFavStatus);
            fetchData(""); // Refresh the list after toggling favorite
            fetchFavorites();
          },
          icon: Icon(
            item['fav'] == 1 ? Icons.bookmark : Icons.bookmark_border_outlined,
            size: 32,
            color: item['fav'] == 1 ? Colors.orange : Colors.grey.shade800,
          ),
        ),
      ),
    );
  }
}
