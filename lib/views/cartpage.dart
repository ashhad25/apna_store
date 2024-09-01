// ignore_for_file: prefer_const_constructors

import 'package:fake_store/Models/getCarts.dart';
import 'package:fake_store/Models/getFavourites.dart';
import 'package:fake_store/cartProvider.dart';
import 'package:fake_store/database/db_helper.dart';
import 'package:fake_store/views/favourite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CartPage extends StatefulWidget {
  int? userId;
  CartPage({super.key, required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF364960),
        centerTitle: true,
        title: Text('Cart'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavouritePage(
                              userId: widget.userId,
                            )));
              },
              icon: Badge(
                  label:
                      Consumer<CartProvider>(builder: (context, value, child) {
                    return Text(
                      value.getFavouriteCounter(widget.userId!).toString(),
                    );
                  }),
                  offset: Offset(10, -4),
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  child: const Icon(Icons.favorite_outline)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: dbHelper!.getCartList(widget.userId!),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.length == 0
                    ? const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Column(
                            children: [
                              Image(
                                  image: AssetImage(
                                      'assets/images/empty-cart.png')),
                              SizedBox(height: 20),
                              Text(
                                'Your cart is empty ☺️',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Explore products and shop your \n favourite items',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
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
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () async {
                                                        print(snapshot
                                                                .data![index]
                                                                .product_id! +
                                                            'on cart page');
                                                        cart.toggleFavourite(
                                                            widget.userId!,
                                                            int.parse(snapshot
                                                                .data![index]
                                                                .product_id!));
                                                        if (cart.getIsFavourite(
                                                                widget.userId!)[
                                                            int.parse(snapshot
                                                                .data![index]
                                                                .product_id!)]) {
                                                          await dbHelper!
                                                              .insertFavorite(
                                                                  Favourite(
                                                            user_id:
                                                                widget.userId,
                                                            product_id: snapshot
                                                                .data![index]
                                                                .product_id!,
                                                            product_price: snapshot
                                                                .data![index]
                                                                .product_price,
                                                            product_name: snapshot
                                                                .data![index]
                                                                .product_name,
                                                            product_unit: snapshot
                                                                .data![index]
                                                                .product_unit,
                                                            product_image: snapshot
                                                                .data![index]
                                                                .product_image,
                                                          ))
                                                              .then((value) {
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            10,
                                                                        left:
                                                                            20),
                                                                    closeIconColor:
                                                                        Colors
                                                                            .white,
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xFF364960),
                                                                    showCloseIcon:
                                                                        true,
                                                                    content:
                                                                        Text(
                                                                      'Added to the favorite items',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )));
                                                          }).onError((error,
                                                                  stackTrace) {
                                                            print(error);
                                                          });
                                                          cart.addFavouriteCounter(
                                                              widget.userId!);
                                                        } else {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              20),
                                                                  closeIconColor:
                                                                      Colors
                                                                          .red,
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
                                                          await dbHelper!
                                                              .deletFavProduct(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .product_name!);
                                                          cart.removeFavouriteCounter(
                                                              widget.userId!);
                                                        }
                                                      },
                                                      icon: Icon(
                                                        cart.getIsFavourite(
                                                                widget
                                                                    .userId!)[int
                                                                .parse(snapshot
                                                                    .data![
                                                                        index]
                                                                    .product_id!)]
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        color:
                                                            Color(0xFF364960),
                                                        size: 30,
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          dbHelper!
                                                              .deletProduct(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .id!);
                                                          cart.removeCounter(
                                                              widget.userId!);
                                                          cart.removeTotalPrice(
                                                              widget.userId!,
                                                              snapshot
                                                                  .data![index]
                                                                  .product_total_price!);
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              20),
                                                                  closeIconColor:
                                                                      Colors
                                                                          .red,
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xFF364960),
                                                                  showCloseIcon:
                                                                      true,
                                                                  content: Text(
                                                                    'Removed Item Successfully',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  )));
                                                        },
                                                        icon: Icon(Icons.delete,
                                                            color: Color(
                                                                0xFF364960))),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        color:
                                                            Color(0xFF364960),
                                                        onPressed: () {
                                                          int quantity = snapshot
                                                              .data![index]
                                                              .product_quantity!;
                                                          double price = snapshot
                                                              .data![index]
                                                              .product_price!;
                                                          quantity++;
                                                          double newPrice =
                                                              price * quantity;

                                                          print(newPrice);
                                                          print(snapshot
                                                              .data![index].id);

                                                          dbHelper!
                                                              .updateQuantity(
                                                            Cart(
                                                              id: snapshot
                                                                  .data![index]
                                                                  .id,
                                                              user_id:
                                                                  widget.userId,
                                                              product_id: snapshot
                                                                  .data![index]
                                                                  .product_id,
                                                              product_price:
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .product_price,
                                                              product_total_price:
                                                                  newPrice,
                                                              product_quantity:
                                                                  quantity,
                                                              product_name: snapshot
                                                                  .data![index]
                                                                  .product_name,
                                                              product_unit: snapshot
                                                                  .data![index]
                                                                  .product_unit,
                                                              product_image:
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .product_image,
                                                            ),
                                                          )
                                                              .then((value) {
                                                            newPrice = 0;
                                                            quantity = 0;
                                                            cart.addTotalPrice(
                                                                widget.userId!,
                                                                price);
                                                            setState(() {});
                                                          }).onError((error,
                                                                  stackTrace) {
                                                            print(error);
                                                          });
                                                        },
                                                        icon: Icon(Icons.add)),
                                                    Text(snapshot.data![index]
                                                        .product_quantity
                                                        .toString()),
                                                    IconButton(
                                                        color:
                                                            Color(0xFF364960),
                                                        onPressed: () {
                                                          int quantity = snapshot
                                                              .data![index]
                                                              .product_quantity!;
                                                          double price = snapshot
                                                              .data![index]
                                                              .product_price!;
                                                          quantity--;
                                                          double newPrice =
                                                              price * quantity;

                                                          if (quantity > 0) {
                                                            dbHelper!
                                                                .updateQuantity(
                                                              Cart(
                                                                id: snapshot
                                                                    .data![
                                                                        index]
                                                                    .id,
                                                                user_id: widget
                                                                    .userId,
                                                                product_id: snapshot
                                                                    .data![
                                                                        index]
                                                                    .product_id,
                                                                product_price:
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .product_price,
                                                                product_total_price:
                                                                    newPrice,
                                                                product_quantity:
                                                                    quantity,
                                                                product_name: snapshot
                                                                    .data![
                                                                        index]
                                                                    .product_name,
                                                                product_unit: snapshot
                                                                    .data![
                                                                        index]
                                                                    .product_unit,
                                                                product_image:
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .product_image,
                                                              ),
                                                            )
                                                                .then((value) {
                                                              newPrice = 0;
                                                              quantity = 0;
                                                              cart.removeTotalPrice(
                                                                  widget
                                                                      .userId!,
                                                                  price);
                                                              setState(() {});
                                                            }).onError((error,
                                                                    stackTrace) {
                                                              print(error);
                                                            });
                                                          }
                                                        },
                                                        icon:
                                                            Icon(Icons.remove)),
                                                  ],
                                                )
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
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF364960),
                ),
              );
            },
          ),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice(widget.userId!).toStringAsFixed(2) ==
                      "0.00"
                  ? false
                  : true,
              child: Column(
                children: [
                  ResuableWidget(
                      title: 'Sub Total',
                      value: r'$' +
                          value
                              .getTotalPrice(widget.userId!)
                              .toStringAsFixed(2)),
                  // ResuableWidget(title: 'Discount 5%', value: r'$' + '20'),
                  // ResuableWidget(
                  //     title: 'Total',
                  //     value: r'$' + value.getTotalPrice().toStringAsFixed(2))
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}

class ResuableWidget extends StatelessWidget {
  final String title, value;
  const ResuableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}
