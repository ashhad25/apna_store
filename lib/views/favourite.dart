import 'package:fake_store/Models/getCarts.dart';
import 'package:fake_store/Models/getFavourites.dart';
import 'package:fake_store/cartProvider.dart';
import 'package:fake_store/database/db_helper.dart';
import 'package:fake_store/views/cartpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  int? userId;
  FavouritePage({super.key, required this.userId});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF364960),
        centerTitle: true,
        title: Text('Favourites'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Badge(
                  label:
                      Consumer<CartProvider>(builder: (context, value, child) {
                    return Text(
                      value.getCounter(widget.userId!).toString(),
                    );
                  }),
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  child: Icon(Icons.shopping_bag_outlined)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartPage(
                              userId: widget.userId,
                            )));
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: dbHelper!.getFavoriteList(widget.userId!),
              builder: (context, AsyncSnapshot<List<Favourite>> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 30, left: 50),
                          child: Column(
                            children: [
                              Image(
                                  image: AssetImage(
                                      'assets/images/empty-favourite.png')),
                              SizedBox(height: 20),
                              Text(
                                'Your favourite list is empty ☺️',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Explore products and add your \n favourite items',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Card(
                                    child: Row(
                                      children: [
                                        Image(
                                            width: 100,
                                            height: 100,
                                            image: AssetImage(snapshot
                                                .data![index].product_image
                                                .toString())),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        snapshot.data![index]
                                                            .product_name
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        '${snapshot.data![index].product_unit.toString()} \$${snapshot.data![index].product_price!.round()}',
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        print(snapshot
                                                                .data![index]
                                                                .product_id! +
                                                            'on favorite page');
                                                        await dbHelper!
                                                            .deletFavProduct(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .product_name!);
                                                        cart.removeFavouriteCounter(
                                                            widget.userId!);

                                                        setState(() {
                                                          cart.setFavourite(
                                                              widget.userId!,
                                                              int.parse(snapshot
                                                                  .data![index]
                                                                  .product_id!),
                                                              false);
                                                        });

                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10,
                                                                        left:
                                                                            20),
                                                                closeIconColor:
                                                                    Colors.red,
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFF364960),
                                                                showCloseIcon:
                                                                    true,
                                                                content: Text(
                                                                  'Removed from favorite items',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                )));
                                                      },
                                                      icon: Icon(
                                                        size: 30,
                                                        Icons.delete,
                                                        color:
                                                            Color(0xFF364960),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              WidgetStateProperty
                                                                  .all(const Color(
                                                                      0xFF364960)),
                                                        ),
                                                        onPressed: () async {
                                                          bool
                                                              favouriteProductExistsInCart =
                                                              await dbHelper!
                                                                  .checkIfFavouriteProductExists(
                                                                      index
                                                                          .toString());

                                                          if (favouriteProductExistsInCart) {
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                const SnackBar(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            10,
                                                                        left:
                                                                            20),
                                                                    closeIconColor:
                                                                        Colors
                                                                            .white,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    showCloseIcon:
                                                                        true,
                                                                    content:
                                                                        Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .warning,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                          'Item already exists in the cart',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ],
                                                                    )));
                                                          } else {
                                                            dbHelper!
                                                                .insert(Cart(
                                                                    user_id: widget
                                                                        .userId,
                                                                    product_id: index
                                                                        .toString(),
                                                                    product_price: snapshot
                                                                        .data![
                                                                            index]
                                                                        .product_price,
                                                                    product_total_price: snapshot
                                                                        .data![
                                                                            index]
                                                                        .product_price,
                                                                    product_quantity:
                                                                        1,
                                                                    product_name: snapshot
                                                                        .data![
                                                                            index]
                                                                        .product_name,
                                                                    product_unit: snapshot
                                                                        .data![
                                                                            index]
                                                                        .product_unit,
                                                                    product_image: snapshot
                                                                        .data![
                                                                            index]
                                                                        .product_image))
                                                                .then((value) {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  const SnackBar(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              20),
                                                                      closeIconColor: Colors
                                                                          .white,
                                                                      backgroundColor:
                                                                          Color(
                                                                              0xFF364960),
                                                                      showCloseIcon:
                                                                          true,
                                                                      content:
                                                                          Text(
                                                                        'Added to the cart',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )));
                                                              cart.addTotalPrice(
                                                                  widget
                                                                      .userId!,
                                                                  double.parse(snapshot
                                                                      .data![
                                                                          index]
                                                                      .product_price
                                                                      .toString()));
                                                              cart.addCounter(
                                                                  widget
                                                                      .userId!);
                                                            }).onError((error,
                                                                    stackTrace) {
                                                              print(error
                                                                  .toString());
                                                            });
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Add to Cart'),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFF364960),
                  ));
                }
              }),
        ],
      ),
    );
  }
}
