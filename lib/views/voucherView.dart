import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/voucherModel.dart';
import 'package:gp_frontend/widgets/AppBar.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/voucherContainer.dart';

import '../Providers/voucherProvider.dart';

class voucherView extends StatefulWidget {
  static String id = "voucher";
  const voucherView({super.key});

  @override
  State<voucherView> createState() => _voucherViewState();
}

class _voucherViewState extends State<voucherView> {
  voucherProvider myVoucherProvider = voucherProvider();
  List<voucherModel> vouchers = [];
  getVouchers() async {
    await myVoucherProvider.getVouchers();
    vouchers = myVoucherProvider.vouchers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar("Add Voucher", leading:IconButton(onPressed: (){Navigator.pop(context);},
        icon: Icon(Icons.arrow_back_ios_new , color: Colors.white,)),),
      body: Padding(
        padding: EdgeInsets.all(10 * SizeConfig.verticalBlock),
        child: FutureBuilder(
            future: getVouchers(),
            builder: (context , snapshot){

              if (snapshot.connectionState != ConnectionState.done) {
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
              }else if(vouchers.isEmpty) {
                return Center(
                    child: Text(
                      "You have not posted anything yet.",
                      style: GoogleFonts.rubik(
                          fontSize: 20 * SizeConfig.textRatio,
                          color: Color(0x503C3C3C)),
                    ));
              }
              return ListView.builder(
                itemCount: vouchers.length,
                  itemBuilder: (context , index){
                  return Column(
                        children: [
                        voucherContainer(
                            code: vouchers[index].code ,
                            amount: vouchers[index].amount,
                            type: vouchers[index].type,
                        ),
                      SizedBox(height: 10 * SizeConfig.verticalBlock,)
                    ],
                  );
                }
    );

            },),
      ),
    );
  }
}
