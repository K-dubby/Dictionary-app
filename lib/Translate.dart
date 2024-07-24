import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:clipboard/clipboard.dart';

import 'db_helper.dart';
import 'mydata.dart';

class TranslatePage extends StatefulWidget {
  final Map item;

  TranslatePage({required this.item});

  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  late Map<String, dynamic> mutableItem; // Define this to copy the item

  Mydata d = Get.find<Mydata>();

  DBHelper dbHelper = DBHelper();

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    d = Get.find<Mydata>();
    dbHelper = DBHelper();
    mutableItem = Map.from(widget.item); // Create a mutable copy of the item
  }

//function to get favorite from table
  void fetchFavorites() async {
    d.favlist.value =
        await dbHelper.select("SELECT * FROM Items WHERE fav = 1");
  }

//function to add favorite to table
  void toggleFavorite() async {
    final newFavStatus = mutableItem['fav'] == 1 ? 0 : 1;
    await dbHelper.toggleFavorite(mutableItem['id'], newFavStatus);
    fetchFavorites();
    d.listdata.value = await dbHelper.select("SELECT * FROM Items");

    setState(() {
      mutableItem['fav'] = newFavStatus;
    });

    //to display messages when save to favorite
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newFavStatus == 1 ? 'Bookmark Saved' : 'Bookmark Removed',
          style: TextStyle(fontSize: 18),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

//funtion to speak
  void speakWord(String word) async {
    await flutterTts.setLanguage("km-KH");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1);
    flutterTts.setPitch(1);
    await flutterTts.speak(word);
  }

//function to share words
  void share(String text) {
    Share.share(text);
  }

//function to copy word to clipboard
  void copyToClipboard(BuildContext context, String text) {
    FlutterClipboard.copy(text).then((value) {
      final snackBar = SnackBar(
        content: Text('Copied to clipboard: $text'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

//function to stop speech when leave translate screen
  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Center(
          child: Text(
            'វចនានុក្រមខ្មែរ',
            style: TextStyle(
              fontFamily: 'KhmerOSMoul',
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.apps,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
        bottom: PreferredSize(
          child: Column(
            children: [
              Text(
                widget.item['word'],
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontFamily: 'KhmerOSBattambang',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Copy icon
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () =>
                          copyToClipboard(context, widget.item['word']),
                      icon: Icon(Icons.copy),
                      iconSize: 30,
                      color: Colors.white,
                    ),
                  ),

                  // Bookmark icon
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: toggleFavorite,
                      icon: Icon(
                        mutableItem['fav'] == 1
                            ? Icons.bookmark
                            : Icons.bookmark_border_outlined,
                        color: mutableItem['fav'] == 1
                            ? Colors.pink
                            : Colors.white,
                      ),
                      iconSize: 30,
                    ),
                  ),

                  // Speak icon
                  Container(
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => speakWord(widget.item['word']),
                      icon: Icon(Icons.volume_up),
                      iconSize: 30,
                      color: Colors.white,
                    ),
                  ),

                  // Share icon
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => share(
                          'Check out this word: ${widget.item['word']}'), // Update onPressed
                      icon: Icon(Icons.share),
                      iconSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          preferredSize: Size.fromHeight(180),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('និយមន័យ',
                            style: TextStyle(
                                fontSize: 25, fontFamily: "KhmerOSMoul")),
                        IconButton(
                          onPressed: () => speakWord(widget.item['definition']),
                          icon: Icon(Icons.volume_up),
                          iconSize: 35,
                          color: Colors.grey.shade800,
                        ),
                      ]),
                  SizedBox(height: 3),
                  Divider(
                    indent: 5,
                    endIndent: 5,
                    thickness: 2,
                  ),
                  SizedBox(height: 15),
                  HtmlWidget(
                    widget.item['definition'],
                    textStyle: TextStyle(
                      fontSize: 25,
                      fontFamily: 'KhmerOSBattambang',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
