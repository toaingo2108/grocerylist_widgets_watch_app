import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set AppGroup Id. This is needed for iOS Apps to talk to their WidgetExtensions
  await HomeWidget.setAppGroupId('group.jack.grocerylist.groceryList');
  // Register an Interactivity Callback. It is necessary that this method is static and public
  await HomeWidget.registerInteractivityCallback(interactiveCallback);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  // Set AppGroup Id. This is needed for iOS Apps to talk to their WidgetExtensions
  await HomeWidget.setAppGroupId('group.jack.grocerylist.groceryList');

  print(uri?.host);
  // We check the host of the uri to determine which action should be triggered.
  List<String>? messages = uri?.host.split("-");
  if (messages?[0] == 'increment') {
    await _increment(Uri.decodeFull(messages?[1] ?? ""));
  } else if (messages?[0] == 'toggle') {
    await _toggle(Uri.decodeFull(messages?[1] ?? ""));
  }
}

const _detailsListKey = 'list';
const _shopKey = 'shop';
const defaultDataStr = '''
{
  "My Shopping List": [
    {
      "category": "Vegetables",
      "items": [
        {
          "name": "Basil",
          "isChecked": false,
          "quantity": 0,
          "iconName": "basil",
          "image":"https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/basil.png?alt=media&token=520b78e9-3734-4f56-82ab-2c17cf418587"
        },
        {
          "name": "Tomatoes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "tomatoes",
          "image":"https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/tomatoes.png?alt=media&token=bac5839a-2e91-4272-8bd2-a10b9ad6b8a4"
        }
      ]
    },
    {
      "category": "Cereal & Breakfast Foods",
      "items": [
        {
          "name": "Cheerios",
          "isChecked": false,
          "quantity": 0,
          "iconName": "cheerios",
          "image": "https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/cheerios.png?alt=media&token=c68b7bb6-0039-492f-ab52-bf5e111c7692"
        },
        {
          "name": "Corn Flakes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "corn_flakes",
          "image": "https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/corn_flakes.png?alt=media&token=0e93c920-93ef-49ea-b38f-52cd81ec5f14"
        },
        {
          "name": "Cream Of Wheat",
          "isChecked": false,
          "quantity": 0,
          "iconName": "cream_of_wheat",
          "image": "https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/cream_of_wheat.png?alt=media&token=c884f837-1cb6-462f-8879-c805a8723835"
        }
      ]
    }
  ],
  "Walmart": [
    {
      "category": "Vegetables",
      "items": [
        {
          "name": "Basil",
          "isChecked": false,
          "quantity": 0,
          "iconName": "basil",
          "image":"https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/basil.png?alt=media&token=520b78e9-3734-4f56-82ab-2c17cf418587"
        },
        {
          "name": "Tomatoes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "tomatoes",
          "image":"https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/tomatoes.png?alt=media&token=bac5839a-2e91-4272-8bd2-a10b9ad6b8a4"
        }
      ]
    },
    {
      "category": "Cereal & Breakfast Foods",
      "items": [
        {
          "name": "Cheerios",
          "isChecked": false,
          "quantity": 0,
          "iconName": "cheerios",
          "image": "https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/cheerios.png?alt=media&token=c68b7bb6-0039-492f-ab52-bf5e111c7692"
        },
        {
          "name": "Corn Flakes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "corn_flakes",
          "image": "https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/corn_flakes.png?alt=media&token=0e93c920-93ef-49ea-b38f-52cd81ec5f14"
        },
        {
          "name": "Cream Of Wheat",
          "isChecked": false,
          "quantity": 0,
          "iconName": "cream_of_wheat",
          "image": "https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/cream_of_wheat.png?alt=media&token=c884f837-1cb6-462f-8879-c805a8723835"
        }
      ]
    }
  ],
  "Kroger": [
    {
      "category": "Vegetables",
      "items": [
        {
          "name": "Basil",
          "isChecked": false,
          "quantity": 0,
          "iconName": "basil",
          "image": "https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/basil.png?alt=media&token=520b78e9-3734-4f56-82ab-2c17cf418587"
        },
        {
          "name": "Tomatoes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "tomatoes",
          "image": "https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/tomatoes.png?alt=media&token=bac5839a-2e91-4272-8bd2-a10b9ad6b8a4"
        }
      ]
    },
    {
      "category": "Cereal & Breakfast Foods",
      "items": [
        {
          "name": "Cheerios",
          "isChecked": false,
          "quantity": 0,
          "iconName": "cheerios",
          "image": "https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/cheerios.png?alt=media&token=c68b7bb6-0039-492f-ab52-bf5e111c7692"
        },
        {
          "name": "Corn Flakes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "corn_flakes",
          "image": "https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/corn_flakes.png?alt=media&token=0e93c920-93ef-49ea-b38f-52cd81ec5f14"
        },
        {
          "name": "Cream Of Wheat",
          "isChecked": false,
          "quantity": 0,
          "iconName": "cream_of_wheat",
          "image": "https://firebasestorage.googleapis.com/v0/b/developmentdashboard-4777e.appspot.com/o/cream_of_wheat.png?alt=media&token=c884f837-1cb6-462f-8879-c805a8723835"
        }
      ]
    }
  ]
}
''';

/// Gets the currently stored Value
Future<String> get _detailsList async {
  final value = await HomeWidget.getWidgetData<String>(_detailsListKey,
      defaultValue: defaultDataStr);
  return value!;
}

Future<String> get _shop async {
  final value = await HomeWidget.getWidgetData<String>(_shopKey,
      defaultValue: "My Shopping List");
  return value!;
}

/// Retrieves the current stored value
/// Increments it by one
/// Saves that new value
/// @returns the new saved value
Future<String> _increment(String itemName) async {
  String newValue = "";
  try {
    final oldValue = await _detailsList;
    final shopValue = await _shop;
    Map<String, dynamic> shopList = json.decode(oldValue);
    List<dynamic> detailsList = shopList[shopValue];

    bool success = false;
    for (var element in detailsList) {
      for (var item in element["items"]) {
        if (item["name"].toLowerCase() == itemName.toLowerCase()) {
          item["quantity"] = item["quantity"] + 1;
          success = true;
          break;
        }
      }
    }

    if (!success) {
      detailsList.add({"category": itemName, "items": []});
    }

    newValue = json.encode(shopList);
    await _sendAndUpdateDetails(newValue);

    print(shopList);
    print('increase number');
  } catch (error) {
    print(error);
  }
  return newValue;
}

Future<String> _toggle(String itemName) async {
  String newValue = "";
  try {
    final oldValue = await _detailsList;
    final shopValue = await _shop;
    Map<String, dynamic> shopList = json.decode(oldValue);
    List<dynamic> detailsList = shopList[shopValue];
    for (var element in detailsList) {
      for (var item in element["items"]) {
        if (item["name"].toLowerCase() == itemName.toLowerCase()) {
          item["isChecked"] = !item["isChecked"];
        }
      }
    }

    newValue = json.encode(shopList);
    await _sendAndUpdateDetails(newValue);

    print(newValue);
    print('toggle');
  } catch (error) {
    print(error);
  }
  return newValue;
}

/// Clears the saved Counter Value
Future<void> _clear() async {
  await _sendAndUpdateDetails(defaultDataStr);
}

/// Stores [value] in the Widget Configuration
Future<void> _sendAndUpdateDetails([String? value]) async {
  await HomeWidget.saveWidgetData(_detailsListKey, value);
  // await _sendImageData();
  await HomeWidget.updateWidget(
    iOSName: 'GroceryListWidget',
    androidName: 'GroceryListWidgetProvider',
  );
}

Future<void> _sendAndUpdateShop([String? value]) async {
  await HomeWidget.saveWidgetData(_shopKey, value);
  await HomeWidget.updateWidget(
    iOSName: 'GroceryListWidget',
    androidName: 'GroceryListWidgetProvider',
  );
}

Future<void> sendInitialData() async {
  var value = await _detailsList;
  await HomeWidget.saveWidgetData(_detailsListKey, value);
  await _sendImageData();
  await HomeWidget.updateWidget(
    iOSName: 'GroceryListWidget',
    androidName: 'GroceryListWidgetProvider',
  );
}

Future<void> _sendImageData() async {
  await HomeWidget.renderFlutterWidget(
    Image.asset(
      "assets/images/basil.png",
      width: 20,
      height: 20,
      fit: BoxFit.contain,
    ),
    key: 'basil',
    logicalSize: const Size(20, 20),
  );
  await HomeWidget.renderFlutterWidget(
    Image.asset(
      "assets/images/tomatoes.png",
      width: 111,
      height: 80,
    ),
    key: 'tomatoes',
    logicalSize: const Size(111, 80),
  );
  await HomeWidget.renderFlutterWidget(
    Image.asset(
      "assets/images/cheerios.png",
      width: 54,
      height: 88,
    ),
    key: 'cheerios',
    logicalSize: const Size(54, 88),
  );
  await HomeWidget.renderFlutterWidget(
    Image.asset(
      "assets/images/corn_flakes.png",
      width: 108,
      height: 80,
    ),
    key: 'corn_flakes',
    logicalSize: const Size(108, 80),
  );
  await HomeWidget.renderFlutterWidget(
    Image.asset(
      "assets/images/cream_of_wheat.png",
      width: 116,
      height: 66,
    ),
    key: 'cream_of_wheat',
    logicalSize: const Size(116, 66),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Grocery List',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff24252a)),
          useMaterial3: true,
        ),
        initialRoute: '/shopping_list',
        routes: {
          '/shopping_list': (context) => const ListPage(),
          '/shopping_details': (context) => const ShoppingDetailsPage(),
        });
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var shopList = [
    {
      "title": "My Shopping List",
      "count": 0,
      "initial": "ML",
      "color": Colors.yellow
    },
    {"title": "Walmart", "count": 0, "initial": "W", "color": Colors.red},
    {"title": "Kroger", "count": 0, "initial": "K", "color": Colors.blue},
  ];
  @override
  void initState() {
    super.initState();

    getShoppingList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      Navigator.pushNamed(context, "/shopping_details").whenComplete(() {
        getShoppingList();
        sendInitialData();
      });
    }
  }

  getShoppingList() async {
    await sendInitialData();
    try {
      var data = await _detailsList;
      Map<String, dynamic> shopDataList = json.decode(data);

      for (var shop in shopList) {
        var count = 0;
        var detailsList = shopDataList[shop["title"]];
        for (var element in detailsList) {
          for (var item in element["items"]) {
            if (item["isChecked"]) {
              count += (item["quantity"] as int);
            }
          }
        }
        shop["count"] = count;
      }

      setState(() {});
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  goToDetails() {
    Navigator.pushNamed(context, "/shopping_details").whenComplete(() {
      getShoppingList();
      sendInitialData();
    });
  }

  Widget getShoppingListWidget() {
    List<Widget> array = [];
    for (var shop in shopList) {
      array.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: InkWell(
            onTap: () async {
              await _sendAndUpdateShop("${shop["title"]}");
              goToDetails();
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (shop["color"] ?? Colors.yellow) as Color,
                child: Text(
                  "${shop["initial"]}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                "${shop["title"]}",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              trailing: Text(
                "${shop["count"]}",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )));
    }
    return Column(children: array);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff24252a),
      appBar: AppBar(
        title: const Text(
          "Grocery List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff24252a),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: getShoppingListWidget(),
      ),
    );
  }
}

class ShoppingDetailsPage extends StatefulWidget {
  const ShoppingDetailsPage({super.key});

  @override
  State<ShoppingDetailsPage> createState() => _ShoppingDetailsPageState();
}

class _ShoppingDetailsPageState extends State<ShoppingDetailsPage> {
  List<dynamic> detailsList = [];
  String shop = "";

  @override
  void initState() {
    super.initState();

    getShoppingDetails();
  }

  getShoppingDetails() async {
    try {
      var data = await _detailsList;
      shop = await _shop;
      Map<String, dynamic> shopDataList = json.decode(data);

      detailsList = shopDataList[shop];

      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  onToggleItem(item) async {
    print("toggle");
    await _toggle("$item");

    await getShoppingDetails();
  }

  onIncreaseItem(item) async {
    await _increment("$item");

    await getShoppingDetails();
  }

  getShoppingDetailsWidget() {
    List<Widget> array = [];

    for (var details in detailsList) {
      array.add(CategorySection(
        categoryData: details,
        onToggleItem: onToggleItem,
        onIncreaseItem: onIncreaseItem,
      ));
    }
    return ListView(children: array);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff24252a),
      appBar: AppBar(
        title: Text(
          shop,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff24252a),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: getShoppingDetailsWidget(),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final dynamic categoryData;
  final Function onToggleItem;
  final Function onIncreaseItem;

  const CategorySection({
    super.key,
    required this.categoryData,
    required this.onToggleItem,
    required this.onIncreaseItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "${categoryData["category"]}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.amber,
              ),
            ),
          ),
          ...(categoryData["items"] as List<dynamic>).map((item) => InkWell(
                onTap: () {
                  onIncreaseItem(item["name"]);
                },
                child: ListTile(
                  title: Row(
                    children: [
                      Image.asset(
                        "assets/images/${item["iconName"]}.png",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        "${item["name"]}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${item["quantity"]}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  leading: Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    side: MaterialStateBorderSide.resolveWith(
                      (states) =>
                          const BorderSide(width: 1.0, color: Colors.white),
                    ),
                    value: item["isChecked"],
                    activeColor: Colors.transparent,
                    onChanged: (bool? newValue) {
                      onToggleItem(item["name"]);
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
