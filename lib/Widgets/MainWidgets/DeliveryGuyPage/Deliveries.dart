import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_job/Data/DeliveryState.dart';
import 'package:move_job/Data/UserState.dart';
import 'package:move_job/Data/Variables.dart';
import 'package:move_job/Widgets/CustomWidgets/CustomAppBar.dart';
import 'package:move_job/main.dart';

class Deliveries extends ConsumerStatefulWidget {
  @override
  _DeliveriesState createState() => _DeliveriesState();
}

class _DeliveriesState extends ConsumerState<Deliveries> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deliveryProvider.notifier).allDeliveries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deliveryState = ref.watch(deliveryProvider);

    return Scaffold(
      appBar: CustomAppBar().logOutAppBar('Kargolarım', () {
        ref.read(userProvider.notifier).logout();
      }),
      body: Center(
        child: deliveryState.isLoading
            ? const CircularProgressIndicator()
            : deliveryState.error != null
                ? Text(
                    deliveryState.error.toString(),
                    style: GoogleFonts.openSans(),
                  )
                : deliveryState.data != null
                    ? SizedBox(
                        height: screenHeight,
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              deliveryState.data!.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(
                                  top: screenWidth * 0.02,
                                  bottom: screenWidth * 0.02,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/MapTrackingPage',
                                        arguments: deliveryState.data![index]);
                                  },
                                  child: Container(
                                    height: screenWidth * 0.2,
                                    width: screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Variables.whiteBG,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Variables.textGrey
                                              .withOpacity(0.5),
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: screenWidth * 0.15,
                                          width: screenWidth * 0.15,
                                          child: Icon(
                                            Icons.local_shipping,
                                            color: deliveryState.data![index]
                                                    ['isdelivered']
                                                ? Variables.generalGreen
                                                : Variables.lightRed,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              screenWidth * 0.02),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                deliveryState.data![index]
                                                        ['isdelivered']
                                                    ? 'Teslim Edildi'
                                                    : 'Teslim Edilmedi',
                                                style: GoogleFonts.openSans(
                                                  color: Variables.textBlack,
                                                  fontSize: screenWidth * 0.04,
                                                ),
                                              ),
                                              Text(
                                                '${deliveryState.data![index]['items'].length} parça',
                                                style: GoogleFonts.openSans(
                                                  color: Variables.textGrey,
                                                  fontSize: screenWidth * 0.04,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        'Veri Bulunamadı',
                        style: GoogleFonts.openSans(),
                      ),
      ),
    );
  }
}
