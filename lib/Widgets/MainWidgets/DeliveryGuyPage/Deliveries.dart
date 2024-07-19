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
      appBar: CustomAppBar().logOutAppBar('Kargolar', () {
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
                            children: [
                              Container(
                                height: screenWidth * 0.8,
                                width: screenWidth,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Variables.generalGreen,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/deliverer.jpg',
                                    ),
                                    opacity: 0.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      'Hoşgeldiniz',
                                      style: GoogleFonts.openSans(
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.w500,
                                        color: Variables.textBlack,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: List.generate(
                                  deliveryState.data!.length,
                                  (index) => Padding(
                                    padding: EdgeInsets.only(
                                      top: screenWidth * 0.02,
                                      bottom: screenWidth * 0.02,
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        Navigator.pushNamed(
                                                context, '/MapTrackingPage',
                                                arguments:
                                                    deliveryState.data![index])
                                            .whenComplete(
                                          () {
                                            ref
                                                .read(deliveryProvider.notifier)
                                                .allDeliveries();
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: screenWidth * 0.24,
                                        width: screenWidth * 0.9,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Variables.whiteBG,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Variables.textGrey
                                                  .withOpacity(0.2),
                                              blurRadius: 1,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: screenWidth * 0.24,
                                              width: screenWidth * 0.15,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 1,
                                                    height: screenWidth * 0.07,
                                                    color: deliveryState
                                                                .data![index]
                                                            ['isdelivered']
                                                        ? Variables.generalGreen
                                                        : Variables.lightRed,
                                                  ),
                                                  SizedBox(
                                                    height: screenWidth * 0.1,
                                                    child: Icon(
                                                      Icons.local_shipping,
                                                      color: deliveryState
                                                                  .data![index]
                                                              ['isdelivered']
                                                          ? Variables
                                                              .generalGreen
                                                          : Variables.lightRed,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    height: screenWidth * 0.07,
                                                    color: deliveryState
                                                                .data![index]
                                                            ['isdelivered']
                                                        ? Variables.generalGreen
                                                        : Variables.lightRed,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    screenWidth * 0.02),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      deliveryState.data![index]
                                                          ['address'],
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color:
                                                            Variables.textBlack,
                                                        fontSize:
                                                            screenWidth * 0.04,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${deliveryState.data![index]['items'].length} parça',
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color:
                                                            Variables.textGrey,
                                                        fontSize:
                                                            screenWidth * 0.04,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
