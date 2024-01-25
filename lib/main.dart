import 'package:flutter/material.dart';
import 'package:grocery_list/list.dart';
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
  if (uri?.host == 'increment') {
    await _increment();
  } else if (uri?.host == 'toggle') {
    await _clear();
  } else if (uri?.host == 'next_page') {
    await _nextPage();
  } else if (uri?.host == 'prev_page') {
    await _prevPage();
  }
}

const _countKey = 'counter';
const _pageKey = 'page';

/// Gets the currently stored Value
Future<int> get _value async {
  final value = await HomeWidget.getWidgetData<int>(_countKey, defaultValue: 0);
  return value!;
}

Future<int> get _page async {
  final value = await HomeWidget.getWidgetData<int>(_pageKey, defaultValue: 0);
  return value!;
}

/// Retrieves the current stored value
/// Increments it by one
/// Saves that new value
/// @returns the new saved value
Future<int> _increment() async {
  final oldValue = await _value;
  final newValue = oldValue + 1;
  await _sendAndUpdate(newValue);
  print('increase number');
  return newValue;
}

Future<int> _nextPage() async {
  await _sendAndUpdatePage(1);
  return 1;
}

Future<int> _prevPage() async {
  await _sendAndUpdatePage(0);
  return 0;
}

/// Clears the saved Counter Value
Future<void> _clear() async {
  await _sendAndUpdate(null);
}

/// Stores [value] in the Widget Configuration
Future<void> _sendAndUpdate([int? value]) async {
  await HomeWidget.saveWidgetData(_countKey, value);
  await HomeWidget.renderFlutterWidget(
    ListWidget(count: value ?? 0),
    key: 'dash_counter',
    logicalSize: const Size(100, 100),
  );
  await HomeWidget.updateWidget(
    iOSName: 'GroceryListWidget',
    androidName: 'GroceryListWidgetProvider',
  );
}

Future<void> _sendAndUpdatePage([int? value]) async {
  await HomeWidget.saveWidgetData(_pageKey, value);
  var signValue = await _value;
  await HomeWidget.renderFlutterWidget(
    ListWidget(count: signValue ?? 0),
    key: 'dash_counter',
    logicalSize: const Size(100, 100),
  );
  await HomeWidget.updateWidget(
    iOSName: 'GroceryListWidget',
    androidName: 'GroceryListWidgetProvider',
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Grocery List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _incrementCounter() async {
    await _increment();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            FutureBuilder<int>(
              future: _value,
              builder: (_, snapshot) => Column(
                children: [
                  Text(
                    (snapshot.data ?? 0).toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  ListWidget(count: snapshot.data ?? 0)
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
