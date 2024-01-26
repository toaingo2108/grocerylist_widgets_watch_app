import 'dart:convert';

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

  // We check the host of the uri to determine which action should be triggered.
  List<String>? messages = uri?.host.split("-");
  if (messages?[0] == 'increment') {
    await _increment(messages?[1] ?? "");
  } else if (uri?.host == 'toggle') {
    await _clear();
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
          "iconName": "basil"
        },
        {
          "name": "Tomatoes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "tomatoes"
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
          "iconName": "cheerios"
        },
        {
          "name": "Corn Flakes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "corn_flakes"
        },
        {
          "name": "Cream Of Wheat",
          "isChecked": false,
          "quantity": 0,
          "iconName": "cream_of_wheat"
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
          "iconName": "basil"
        },
        {
          "name": "Tomatoes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "tomatoes"
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
          "iconName": "cheerios"
        },
        {
          "name": "Corn Flakes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "corn_flakes"
        },
        {
          "name": "Cream Of Wheat",
          "isChecked": false,
          "quantity": 0,
          "iconName": "cream_of_wheat"
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
          "iconName": "basil"
        },
        {
          "name": "Tomatoes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "tomatoes"
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
          "iconName": "cheerios"
        },
        {
          "name": "Corn Flakes",
          "isChecked": false,
          "quantity": 0,
          "iconName": "corn_flakes"
        },
        {
          "name": "Cream Of Wheat",
          "isChecked": false,
          "quantity": 0,
          "iconName": "cream_of_wheat"
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
    for (var element in detailsList) {
      if (element["name"] == itemName) {
        element["quantity"] = element["quantity"] + 1;
      }
    }

    newValue = json.encode(shopList);
    await _sendAndUpdateDetails(newValue);
    print('increase number');
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
          '/shopping_details': (context) => ShoppingDetailsPage(),
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

  getShoppingList() async {
    try {
      var data = await _detailsList;
      Map<String, dynamic> shopDataList = json.decode(data);

      for (var shop in shopList) {
        var count = 0;
        var items = shopDataList[shop["title"]]["items"];
        for (var item in items) {
          if (item["isChecked"]) {
            count += (item["quantity"] as int);
          }
        }
        shop["count"] = count;
      }
    } catch (error) {
      print(error);
    }
  }

  Widget getShoppingListWidget() {
    List<Widget> array = [];
    for (var shop in shopList) {
      array.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: InkWell(
            onTap: () {},
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Placeholder());
  }
}
