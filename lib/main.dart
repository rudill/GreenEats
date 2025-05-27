// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
//import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:mongoappv2/Cart/Cart.dart';
import 'package:mongoappv2/Screens/MenuItemDetails.dart';
import 'package:mongoappv2/Notification/Notifications.dart';
import 'package:mongoappv2/Cart/cart_util.dart';
import 'package:mongoappv2/Components/orderStatus.dart';
import 'package:redux/redux.dart';
import 'Cart/CartsPage.dart';
import 'Components/RestaurantMenu.dart';
import 'Firebase/firebase_options.dart';
import 'MongoDB/mongodb.dart';
import 'widgetTree.dart';
//import 'package:provider/provider.dart';
import 'dart:async';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  List<MenuItem> initialCartItems = await loadCartItems();
  // ignore: unused_local_variable
  final orderStatus =
      Store<String>(orderStatusReducer, initialState: 'pending');
  final initialCartItemsMap = {'Restaurant Name': initialCartItems};
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(cartItems: initialCartItemsMap),
    middleware: [cartItemsMiddleware],
  );
  try {
    await MongoDatabase.connect();

    runApp(
      StoreProvider<String>(
        store: orderStatus,
        child: MaterialApp(
          home: MyApp(store: store, orderStatus: orderStatus),
          routes: {
            '/home': (context) => MyApp(
                  store: store,
                  orderStatus: orderStatus,
                ),

          },
        ),
      ),
    );
  } catch (e) {
    print('Error connecting to MongoDB: $e');
  }

  await Notifications.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required store, required Store<String> orderStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        // themeMode: ThemeMode.dark,
        // darkTheme: ThemeData(brightness: Brightness.dark),
        theme: ThemeData(
          primarySwatch: const MaterialColor(0xFF03D1AF, {
            50: Color(0xFFE0F7F3),
            100: Color(0xFFB3EAE0),
            200: Color(0xFF80DACB),
            300: Color(0xFF4DCBB6),
            400: Color(0xFF26C1A7),
            500: Color(0xFF03D1AF),
            600: Color(0xFF00BFA6),
            700: Color(0xFF00A99D),
            800: Color(0xFF009F94),
            900: Color(0xFF008A84),
          }),
        ),
        home: const WidgetTree(),
        routes: {
          'restaurantMenu': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map;
            return RestaurantMenu(restaurant: args['restaurant']);
          },
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    setupInteractedMessage(orderStatus);
  }

  StreamSubscription<RemoteMessage>? _streamSubscription;

  void setupInteractedMessage(Store<String> orderStatus) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleFirebaseMessage(message, orderStatus);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleFirebaseMessage(message, orderStatus);
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleFirebaseMessage(initialMessage, orderStatus);
    }

    String? token = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $token');
  }

  void handleFirebaseMessage(RemoteMessage message, Store<String> orderStatus) {
    if (message.data['status'] == 'received') {
      // ignore: avoid_print
      print('order accepted');
      Notifications.showNotification(
          title: 'Order accepted', body: 'Your order has been accepted');
      orderStatus.dispatch(UpdateOrderStatusAction('order accepted'));
    } else if (message.data['status'] == 'rejected') {
      Notifications.showNotification(
          title: 'Order rejected', body: 'Your order has been rejected');
    } else if (message.data['status'] == 'ready') {
      print('order ready');
      Notifications.showNotification(
          title: 'Order ready', body: 'Your order is ready');
      orderStatus.dispatch(UpdateOrderStatusAction('order ready'));
    } else {
      print('not received');
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  final List<Restaurant> restaurantList = [
    Restaurant(name: 'Hostel Canteen', collectionName: 'profile1'),
    Restaurant(name: 'Auditorium Canteen', collectionName: 'profile2'),
    Restaurant(name: 'Finagle', collectionName: 'profile3'),
    Restaurant(name: 'Ayu\'s cafe', collectionName: 'profile4'),
    Restaurant(name: 'So cafe', collectionName: 'profile5'),
    Restaurant(name: 'Hela bojun', collectionName: 'profile6'),
    Restaurant(name: 'Juice bar', collectionName: 'profile7'),
    // Restaurant(name: 'Restaurant 3'),
    // Restaurant(name: 'Restaurant 4'),
  ];

  // int _selectedIndex = 0;

  // static List<Widget> _widgetOptions = <Widget>[
  //   MyHomePage(title: 'Green Eats'),
  //   const CartPage(),
  // ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(0xFF00B860),
                        image: DecorationImage(
                          image: AssetImage('images/greeneats.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      child: Text(
                        'Green Eats',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: Text(
                        user?.email ?? 'user email',
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Home'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyHomePage(
                              title: 'Green Eats',
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.shopping_cart),
                      title: const Text('Cart'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout_sharp),
                title: const Text('Logout'),
                onTap: () {
                  signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WidgetTree(),
                    ),
                  );
                },
              ),
              const ListTile(
                title: Text(
                  'Copyright © 2024 - All right reserved by GreenEats Team',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: appTitle(),
          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.shopping_cart),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const CartPage(),
          //         ),
          //       );
          //     },
          //   ),
          //   IconButton(
          //     onPressed: signOut,
          //     icon: const Icon(Icons.logout_sharp),
          //   ),
          // ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                children: [
                  // _pages[_currentIndex],
                  ListView.builder(
                    itemCount: restaurantList.length - 4 + 1,
                    itemBuilder: (context, index) {
                      if (index < restaurantList.length - 4) {
                        return Card(
                          margin: const EdgeInsets.all(12),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.of(context).pushNamed(
                                'restaurantMenu',
                                arguments: {
                                  'restaurant': restaurantList[index],
                                },
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Hero(
                                  tag: restaurantList[index + 4].name,
                                  transitionOnUserGestures: true,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'images/${restaurantList[index].name}.jpg',
                                      //'https://picsum.photos/seed/${restaurantList[index].name}/500/300',
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 12, 16, 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        restaurantList[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ],
                                  ),
                                ),

                                // Add more widgets here for more information
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('The Edge',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap:
                                      true, // This allows the ListView to size itself based on its children
                                  physics:
                                      const NeverScrollableScrollPhysics(), // This disables scrolling within this ListView
                                  itemCount:
                                      4, // The number of restaurants in this section
                                  itemBuilder: (context, index) {
                                    // Calculate the index of the restaurant in the restaurantList
                                    int restaurantIndex =
                                        restaurantList.length - 4 + index;
                                    return Card(
                                      child: InkWell(
                                        onTap: () async {
                                          Navigator.of(context).pushNamed(
                                            'restaurantMenu',
                                            arguments: {
                                              'restaurant': restaurantList[
                                                  restaurantIndex],
                                            },
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                'images/${restaurantList[restaurantIndex].name}.jpg',
                                                width: double.infinity,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                restaurantList[restaurantIndex]
                                                    .name,
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //     ),
        //     // BottomNavigationBarItem(
        //     //   icon: Icon(Icons.business),
        //     //   label: 'Page 1',
        //     // ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.school),
        //       label: 'Carts',
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: Colors.amber[800],
        //   onTap: _onItemTapped,
        // ),
      ),
    );
  }

  Text appTitle() {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Green',
            style: TextStyle(
              color: Color(0xFF00B860),
              fontSize: 32,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w900,
              height: 0,
              letterSpacing: -2.24,
            ),
          ),
          TextSpan(
            text: 'Eats',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 32,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w900,
              height: 0,
              letterSpacing: -2.24,
            ),
          ),
        ],
      ),
    );
  }
}
