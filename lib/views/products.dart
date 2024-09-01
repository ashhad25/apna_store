// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:fake_store/Models/getCarts.dart';
import 'package:fake_store/Models/getFavourites.dart';
import 'package:fake_store/Models/getusers.dart';
import 'package:fake_store/cartProvider.dart';
import 'package:fake_store/database/db_helper.dart';
import 'package:fake_store/views/authentications/login.dart';
import 'package:fake_store/views/cartpage.dart';
import 'package:fake_store/views/favourite.dart';
import 'package:fake_store/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';

class Products extends StatefulWidget {
  String? user_name, user_email, user_password;
  int? user_id;
  Products(
      {super.key,
      required this.user_name,
      required this.user_email,
      required this.user_id,
      required this.user_password});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<String> productNames = [
    'Mango',
    'Apple',
    'Banana',
    'Cherry',
    'Pineapple',
    'Orange',
    'Watermelon',
    'Kiwi'
  ];
  List<String> productUnits = [
    'KG',
    'KG',
    'DOZEN',
    'KG',
    'KG',
    'KG',
    'KG',
    'KG'
  ];
  List<double> productPrices = [10, 5, 7, 8, 9, 6, 11, 4];
  List<String> productImages = [
    'assets/images/mango.png',
    'assets/images/apple.png',
    'assets/images/banana.png',
    'assets/images/cherry.png',
    'assets/images/pineapple.png',
    'assets/images/orange.png',
    'assets/images/watermelon.png',
    'assets/images/kiwi.png'
  ];

  DBHelper? dbHelper = DBHelper();
  bool isLoading = true; // Loading state

  String imagePath = '';

  Future<void> loadData() async {
    User? user = await dbHelper!.getUserByEmail(widget.user_email.toString());
    widget.user_email = user?.user_email.toString();
    widget.user_name = user?.user_name.toString();
    widget.user_id = user?.user_id;
    widget.user_password = user?.user_password;
    imagePath = user?.user_image ?? '';
    setState(() {
      isLoading = false; // Data loaded, set loading to false
    });
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => imagePath = imageTemp.path);

      print(widget.user_id);
      print(widget.user_email);
      print(widget.user_name);
      print(widget.user_password);

      // Update the user image in the database
      await dbHelper!.updateUser(User(
        user_id: widget.user_id,
        user_name: widget.user_name,
        user_email: widget.user_email,
        user_password: widget.user_password,
        user_image: imagePath,
      ));
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show a loading indicator while data is being loaded
      return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF364960),
            title: Text(
              'Products',
              style: GoogleFonts.inter(fontSize: 25),
            ),
            automaticallyImplyLeading: false,
          ),
          body: ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Card(
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150,
                                  height: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: 100,
                                  height: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ));
    }

    final cart = Provider.of<CartProvider>(context);
    return PopScope(
      canPop: false,
      // onPopInvoked: (didPop) {
      //   if (didPop) {
      //     return;
      //   }
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => SplashScreen()));
      // },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF364960),
          title: Text(
            'Products',
            style: GoogleFonts.poppins(fontSize: 25),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavouritePage(
                                  userId: widget.user_id,
                                )));
                  },
                  icon: Badge(
                      label: Consumer<CartProvider>(
                          builder: (context, value, child) {
                        return Text(
                          value.getFavouriteCounter(widget.user_id!).toString(),
                        );
                      }),
                      offset: Offset(10, -4),
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      child: const Icon(Icons.favorite_outline)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: Badge(
                        label: Consumer<CartProvider>(
                            builder: (context, value, child) {
                          return Text(
                            value.getCounter(widget.user_id!).toString(),
                          );
                        }),
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        child: const Icon(Icons.shopping_bag_outlined)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartPage(
                                    userId: widget.user_id,
                                  )));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: ListView.builder(
          itemCount: productNames.length,
          itemBuilder: (context, index) {
            return _buildProductCard(index, cart);
          },
        ),
      ),
    );
  }

  // Drawer UI with user info
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF364960),
      width: 250,
      child: ListView(
        children: [
          DrawerHeader(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40,
              backgroundImage:
                  imagePath.isNotEmpty ? FileImage(File(imagePath)) : null,
              child: imagePath.isEmpty
                  ? IconButton(
                      onPressed: pickImage,
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 30,
                        color: Color(0xFF364960),
                      ),
                    )
                  : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Text(
                  widget.user_name!,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                title: Text(
                  widget.user_email!,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.remove('isLogin');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('User logged out successfully.'),
                      backgroundColor: Colors.green,
                    ));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent),
                  ),
                  child: Text('Logout'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Product card widget
  Widget _buildProductCard(int index, CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        child: Row(
          children: [
            Image(
              width: 100,
              height: 100,
              image: AssetImage(productImages[index]),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productNames[index],
                              style: const TextStyle(fontSize: 18)),
                          Text(
                              '${productUnits[index]} \$${productPrices[index].round()}',
                              style: const TextStyle(fontSize: 15)),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          print(index);
                          cart.toggleFavourite(widget.user_id!, index);
                          if (cart.getIsFavourite(widget.user_id!)[index]) {
                            await dbHelper!
                                .insertFavorite(Favourite(
                              user_id: widget.user_id,
                              product_id: index.toString(),
                              product_price: productPrices[index],
                              product_name: productNames[index],
                              product_unit: productUnits[index],
                              product_image: productImages[index],
                            ))
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      padding:
                                          EdgeInsets.only(bottom: 10, left: 20),
                                      closeIconColor: Colors.white,
                                      backgroundColor: Color(0xFF364960),
                                      showCloseIcon: true,
                                      content: Text(
                                        'Added to the favorite items',
                                        style: TextStyle(color: Colors.white),
                                      )));
                            }).onError((error, stackTrace) {
                              print(error);
                            });
                            cart.addFavouriteCounter(widget.user_id!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                padding: EdgeInsets.only(bottom: 10, left: 20),
                                closeIconColor: Colors.red,
                                backgroundColor: Color(0xFF364960),
                                showCloseIcon: true,
                                content: Text(
                                  'Removed from favorite items',
                                  style: TextStyle(color: Colors.red),
                                )));
                            await dbHelper!
                                .deletFavProduct(productNames[index]);
                            cart.removeFavouriteCounter(widget.user_id!);
                          }
                        },
                        icon: Icon(
                          cart.getIsFavourite(widget.user_id!)[index]
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Color(0xFF364960),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF364960)),
                        ),
                        onPressed: () async {
                          bool productExists =
                              await dbHelper!.checkIfProductExists(
                            widget.user_id!,
                            productNames[index],
                          );
                          if (productExists) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Item already exists in the cart'),
                                backgroundColor: Colors.red,
                                showCloseIcon: true,
                                closeIconColor: Colors.white,
                              ),
                            );
                          } else {
                            await dbHelper!.insert(Cart(
                              user_id: widget.user_id!,
                              product_id:
                                  index.toString(), // Unique for each product
                              product_price: productPrices[index],
                              product_total_price: productPrices[index],
                              product_quantity: 1,
                              product_name: productNames[index],
                              product_unit: productUnits[index],
                              product_image: productImages[index],
                            ));

                            cart.addTotalPrice(widget.user_id!,
                                double.parse(productPrices[index].toString()));
                            cart.addCounter(widget.user_id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    padding:
                                        EdgeInsets.only(bottom: 10, left: 20),
                                    closeIconColor: Colors.white,
                                    backgroundColor: Color(0xFF364960),
                                    showCloseIcon: true,
                                    content: Text(
                                      'Added to the cart',
                                      style: TextStyle(color: Colors.white),
                                    )));
                          }
                        },
                        child: const Text('Add to Cart'),
                      ),
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
