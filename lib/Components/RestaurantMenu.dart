import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Screens/MenuItemDetails.dart';
//import 'main.dart';
import '../MongoDB/mongodb.dart';
import '../Models/userData.dart';

// void main() {
//   runApp(MyApp(store: ,));
// }

class Restaurant {
  final String name;
  final String collectionName;

  Restaurant({required this.name, required this.collectionName});
}

class RestaurantMenu extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantMenu({required this.restaurant});

  @override
  _RestaurantMenuState createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  List<UserData> userList = [];
  int restaurantIndex = 0;

  final List<Color> backgroundColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.brown,
  ];

  Color getBackgroundColor(String restaurantName) {
    switch (restaurantName) {
      case 'Hostel Canteen':
        return const Color(0xFFFF6666);
      case 'Auditorium Canteen':
        return const Color(0xFF186F65);
      case 'Finagle':
        return Colors.red;
      case 'Ayu\'s cafe':
        return const Color(0xFF5F0F40);
      case 'So cafe':
        return Colors.orange;
      case 'Hela bojun':
        return const Color(0xFF1A5D1A);

      case 'Juice bar':
        return const Color(0xFF1B1A17);
      default:
        return Colors.grey;
    }
  }

  Text getDescription(String restaurantName) {
    switch (restaurantName) {
      case 'Hostel Canteen':
        return const Text(
          'Explore fresh, local flavors in a cozy setting. Memorable dining made simple',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic // Adjust font size as needed
              // Add other styling as needed
              ),
        );
      case 'Auditorium Canteen':
        return const Text(
          'Fresh, local, unforgettable. Culinary excellence in a cozy setting',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic
              // Adjust font size as needed
              // Add other styling as needed
              ),
        );
      case 'Finagle':
        return const Text(
          'Finagle: Culinary excellence, fresh flavors, inviting ambiance. Memorable dining, every visit',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic // Adjust font size as needed
              // Add other styling as needed
              ),
        );
      case 'Ayu\'s cafe':
        return const Text(
          'Step into comfort at our eatery. Fresh, local flavors define our menu, creating memorable dining moments',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic // Adjust font size as needed
              // Add other styling as needed
              ),
        );
      case 'So cafe':
        return const Text(
          'Discover culinary joy at our spot. Fresh, local ingredients, unforgettable moments. Your go-to for delightful dining experiences',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic // Adjust font size as needed
              // Add other styling as needed
              ),
        );
      case 'Hela bojun':
        return const Text(
          'Savor the essence of Sri Lankan flavors at our eatery. Locally sourced, authentically crafted dishes promise a journey through culinary traditions.',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic // Adjust font size as needed
              // Add other styling as needed
              ),
        );
      case 'Juice bar':
        return const Text(
          'Cafeteria 4 description',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic // Adjust font size as needed
              // Add other styling as needed
              ),
        );
      default:
        return const Text(
          'No description',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic // Adjust font size as needed
              // Add other styling as needed
              ),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<UserData> data =
        await MongoDatabase.getUserData(widget.restaurant.collectionName);
    setState(() {
      userList = data;
    });
  }

  Future<void> _refreshData() async {
    await fetchData();
  }

  Future<Uint8List?> fetchImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image. Error: ${response.statusCode}');
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.restaurant.name),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: Column(children: [
          Stack(
            children: [
              Container(
                width: 393,
                height: 230,
                decoration: ShapeDecoration(
                  color: getBackgroundColor(widget.restaurant.name),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 40.0, // Adjust this value as needed
                left: 20.0, // Adjust this value as needed
                child: Container(
                  width: 150.0, // Adjust this value as needed
                  child: getDescription(widget.restaurant.name),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 20, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          widget.restaurant.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: 'Unbounded',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(
                          width: 48), // This is to balance the back button
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -50.0,
                right: -50.0,
                child: Image.asset(
                  'images/${widget.restaurant.name}pic.png',
                  //'images/burger.png',
                  width: 240,
                  height: 300,
                ),
              ),
            ],
          ),
          // Container(
          //   width: 393,
          //   height: 10,
          //   decoration: const ShapeDecoration(
          //     color: Color.fromARGB(255, 3, 209, 175),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.only(
          //         bottomLeft: Radius.circular(28),
          //         bottomRight: Radius.circular(28),
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: foodMenu(),
          ),
        ]),
      ),
    );
  }

  RefreshIndicator foodMenu() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: userList.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
              ),
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuItemDetails(
                          menuItem: userList[index],
                          restaurantName: widget.restaurant.name,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(width: 1, color: const Color(0xFFC5C5C5)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 174, 174, 174),
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: FutureBuilder(
                              future: fetchImage(userList[index].imgUrl),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError ||
                                    snapshot.data == null) {
                                  return const Icon(Icons.error);
                                } else {
                                  return Center(
                                    child: Container(
                                      width: 145,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: MemoryImage(snapshot.data!),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          //Text(userList[index].name),
                          Text(
                            (userList[index].name),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic),
                          ),
                          //Text(userList[index].description),
                          Text(
                            'LKR ${userList[index].price}.00',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 27, 28, 27),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Image.asset(
                'images/loader.gif',
                height: 300.0, // You can adjust as needed.
                width: 300.0, // You can adjust as needed.
              ),
            ),
    );
  }
}
