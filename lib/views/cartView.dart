import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/voucherModel.dart';
import 'package:gp_frontend/Providers/cartProvider.dart';
import 'package:gp_frontend/Providers/voucherProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/views/checkOut.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/cartAppBar.dart';
import 'package:gp_frontend/widgets/cartDiscount.dart';
import 'package:gp_frontend/widgets/messages.dart';
import 'package:provider/provider.dart';
import '../SqfliteCodes/cart.dart';
import '../widgets/cartContainer.dart';
import '../widgets/cartPriceSummary.dart';
import '../widgets/customizeButton.dart';
import 'ProfileView.dart';

class cartScreen extends StatefulWidget {
  static String id = "cartScreen";
  const cartScreen({super.key});

  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  Token myToken = Token();
  Cart cart = Cart();
  TextEditingController voucher = TextEditingController();
  String? _selectedOption;
  // voucherProvider myVoucherProvider = voucherProvider();
  // voucherModel voucherM = voucherModel(code: "", amount: 0, type: "", id: "");
  voucherProvider? _voucherProvider;


  final List<String> _options = [
    'Choose',
    'Voucher',
    'Gift Cards',
    'Loyalty Points',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _voucherProvider ??= Provider.of<voucherProvider>(context, listen: false); // Safe access
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final cartProv = context.read<cartProvider>();
      fetchCartProducts(cartProv);
    });

    _selectedOption = "Choose";
  }

  @override
  void dispose() {
    _voucherProvider?.resetVoucher(notify: false);
    super.dispose();
  }



  Future<void> fetchCartProducts(cartProvider myCart) async {
    // cart.recreateProductsTable();

    await myCart.getCartProduct();
    print("cart Product Length");
    print(myCart.cartProducts.length);
  }

  double getTotalPrice(cartProvider myCart) {
    double price = 0;
    for (var product in myCart.cartProducts) {
      price += product.price * product.Quantity! ?? 0;
    }
    return price;
  }

  void insertProductData(String id, String finalId) async {
    Cart myCart = Cart();
    await myCart.addProduct(id, finalId);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight:
            185 * SizeConfig.verticalBlock, // Set the height of the AppBar
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A), // Start color
                Color(0xFF5095B0), // End color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), // Rounded bottom-left corner
              bottomRight: Radius.circular(20), // Rounded bottom-right corner
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 45 * SizeConfig.verticalBlock,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: SizeConfig.textRatio * 15,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Cart',
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 20 * SizeConfig.textRatio,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Profile.id);
                      },
                      icon: Icon(
                        Icons.account_circle_outlined,
                        size: 24 * SizeConfig.textRatio,
                        color: Colors.white,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  CartBar(icon: Icons.shopping_cart_outlined,label: "View Cart",step: "Step 1",),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 35.0 * SizeConfig.verticalBlock),
                    child: Container(
                      width: 50 * SizeConfig.horizontalBlock,
                      height: 4 * SizeConfig.verticalBlock,
                      color: const Color(0x50E9E9E9),
                    ),
                  ),
                  CartBar(icon: Icons.list,label: "Check Out",step: "Step 2",disabled: true,),

                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 35.0 * SizeConfig.verticalBlock),
                    child: Container(
                      width: 50 * SizeConfig.horizontalBlock,
                      height: 4 * SizeConfig.verticalBlock,
                      color: const Color(0x50E9E9E9),
                    ),
                  ),
                  CartBar(icon: Icons.checklist,label: "Order review",step: "step 3",disabled: true,),

                ],
              )
            ],
          ),
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), // Rounded bottom-left corner
            bottomRight: Radius.circular(20), // Rounded bottom-right corner
          ),
        ),
      ),
      body: Consumer<cartProvider>(
        builder: (context, myCart, child) {
          if(myCart.isLoading){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                      "Loading...",
                      style: GoogleFonts.rubik(
                          fontSize: 20 * SizeConfig.textRatio,
                          color: Color(0x503C3C3C)),
                    )),
              ],
            );
          }
          else if (myCart.cartProducts.isEmpty) {
            return Center(child: Text("your Cart is Empty"));
          }
          double totalPrice = getTotalPrice(myCart);
          return Consumer<voucherProvider>(
            builder: (context, voucherProv , child) {
              return ListView(
                children: [
                  SizedBox(
                    height: voucherProv.voucher.amount == 0
                        ? 400 * SizeConfig.verticalBlock
                        : 300 * SizeConfig.verticalBlock,
                    child: ListView.builder(
                      itemCount: myCart.cartProducts.length,
                      itemBuilder:
                          (context, index) {
                        if (myCart.cartProducts[index].Quantity == null) {
                          myCart.cartProducts[index].Quantity = 0;
                        }
                        final product = myCart.cartProducts[index];
                        if (product.Quantity == null) product.Quantity = 0;
                        return CartItem(
                          product: product,
                          onIncrease: () {
                            setState(() {
                              product.Quantity = (product.Quantity ?? 0) + 1;
                              insertProductData(product.id, product.finalId ?? "");
                            });
                          },
                          onDecrease: () {
                            setState(() {
                              if (product.Quantity! > 1) {
                                product.Quantity = (product.Quantity ?? 0) - 1;
                                myCart.deleteCartProduct(product.finalId ?? "");
                              } else {
                                cart.deleteAllProduct(product.finalId ?? "");
                                fetchCartProducts(myCart);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5 * SizeConfig.verticalBlock,
                  ),
                  VoucherInput(
                    controller: voucher,
                    selectedOption: _selectedOption,
                    options: _options,
                    onChanged: (newValue)async {
                      setState(() => _selectedOption = newValue);
                      if(_selectedOption == "Voucher"){
                        await voucherProv.getVoucher(voucher.text);

                      }else{
                        voucherProv.resetVoucher();
                      }
                    },
                    onTextChanged: (newValue)async{
                       if (voucher.text.isNotEmpty && _selectedOption == "Voucher") {
                        await voucherProv.getVoucher(voucher.text);
                        if(voucherProv.voucher.amount == 0){
                          showCustomPopup(context, "voucher",
                              "${voucher.text} Wrong Or Does Not Exist!", []);
                        }
                      }if (voucher.text.isEmpty){
                         voucherProv.resetVoucher();
                       }
                    },
                  ),

                  SizedBox(
                    height: 20 * SizeConfig.verticalBlock,
                  ),
                  PriceSummary(
                    type: voucherProv.voucher.type,
                    discountPercentage: voucherProv.voucher.amount,
                    totalPrice: totalPrice,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0 * SizeConfig.verticalBlock),
                    child: customizeButton(
                      buttonColor: SizeConfig.iconColor,
                      buttonName: "Check Out",
                      fontColor: Colors.white,
                      width: 370 * SizeConfig.horizontalBlock,
                      height: 50 * SizeConfig.verticalBlock,
                      onClickButton: () {
                        Navigator.pushNamed(
                          context,
                          checkOut.id,
                          arguments: {
                            'voucher': voucher.text,
                            'price': totalPrice,
                            'percentage': voucherProv.voucher.amount,
                            'products':myCart.cartProducts,
                            'type':voucherProv.voucher.type
                          },
                        );
                      },
                    ),
                  )
                ],
              );
            }
          );
        },
      ),
    );
  }
}
