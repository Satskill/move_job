import 'dart:async';
//import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:move_job/Data/LocationProvider.dart';
import 'package:move_job/Data/RouteProvider.dart';
import 'package:move_job/Data/Variables.dart';
import 'package:move_job/Widgets/CustomWidgets/CustomAppBar.dart';
import 'package:move_job/Widgets/CustomWidgets/CustomButtons.dart';
import 'package:move_job/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OpenMapState {
  final bool isOpen;

  OpenMapState({required this.isOpen});
}

class OpenMapNotifier extends StateNotifier<OpenMapState> {
  OpenMapNotifier() : super(OpenMapState(isOpen: false));

  void updateMap(bool isOpen) {
    state = OpenMapState(isOpen: isOpen);
  }
}

// Provider
var openMapProvider =
    StateNotifierProvider<OpenMapNotifier, OpenMapState>((ref) {
  return OpenMapNotifier();
});

class MapTrackingPage extends ConsumerStatefulWidget {
  final data;

  MapTrackingPage({required this.data, super.key});

  @override
  _MapTrackingPageState createState() => _MapTrackingPageState();
}

class _MapTrackingPageState extends ConsumerState<MapTrackingPage> {
  late final MapController mapController;
  Timer? _timer;

  bool arrived = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  void dispose() {
    mapController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void checkIfArrived() {
    final currentPosition = ref.read(locationProvider);

    final destination = LatLng(
      double.parse(widget.data['lat'].toString()),
      double.parse(widget.data['lng'].toString()),
    );

    final distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      destination.latitude,
      destination.longitude,
    );

    if (distance < 10) {
      arrived = true;
      ref.read(openMapProvider.notifier).updateMap(false);
    }
  }

  void startForegroundTask() {
    FlutterForegroundTask.startService(
      notificationTitle: 'Harita Takip',
      notificationText: 'Konumunuz anlık güncelleniyor',
      //callback: updateTaskCallback,
    );
  }

  /*static void updateTaskCallback() {
    FlutterForegroundTask.setTaskHandler(UpdateTaskHandler());
  }*/

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(locationProvider);
    final routeAsyncValue = ref.watch(
      routeProvider(
        LatLng(
          double.parse(widget.data['lat'].toString()),
          double.parse(widget.data['lng'].toString()),
        ),
      ),
    );
    var openMap = ref.watch(openMapProvider);

    return Scaffold(
      appBar: CustomAppBar().goBackAppBar('Kargo Detay', () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenWidth * 0.02,
                      bottom: screenWidth * 0.02,
                    ),
                    child: Container(
                      height: screenWidth * 0.9,
                      width: screenWidth * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: Variables.lightRed.withOpacity(0.5),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: currentPosition,
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: const ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: currentPosition,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.red,
                                    size: 40.0,
                                  ),
                                ),
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: LatLng(
                                    double.parse(widget.data['lat'].toString()),
                                    double.parse(widget.data['lng'].toString()),
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.green,
                                    size: 40.0,
                                  ),
                                ),
                              ],
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: routeAsyncValue.maybeWhen(
                                    data: (route) => route,
                                    orElse: () => [],
                                  ),
                                  strokeWidth: 4.0,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenWidth * 0.025,
                    bottom: screenWidth * 0.025,
                  ),
                  child: Column(
                    children: [
                      texts('Adı', widget.data['name']),
                      texts('Soyadı', widget.data['surname']),
                      texts('Adres', widget.data['address']),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenWidth * 0.05,
                                bottom: screenWidth * 0.025,
                              ),
                              child: Text(
                                'Kargolar',
                                style: GoogleFonts.openSans(
                                  color: Variables.textBlack,
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Column(
                              children: List.generate(
                                widget.data['items'].length,
                                (index) => Padding(
                                  padding: EdgeInsets.only(
                                      top: screenWidth * 0.025,
                                      bottom: screenWidth * 0.025),
                                  child: Container(
                                    width: screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 1,
                                        color:
                                            Variables.lightRed.withOpacity(0.1),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        texts(
                                            'Ürün Adı',
                                            widget.data['items'][index]
                                                ['name']),
                                        texts(
                                            'Açıklaması',
                                            widget.data['items'][index]
                                                ['description']),
                                        texts(
                                            'Adet',
                                            widget.data['items'][index]['count']
                                                .toString()),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: screenWidth * 0.85),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: screenWidth * 0.95,
                  child: Row(
                    mainAxisAlignment: arrived
                        ? MainAxisAlignment.center
                        : openMap.isOpen
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      openMap.isOpen || arrived
                          ? CustomButtons().general(
                              'Teslim Et',
                              () {
                                showGeneralDialog(
                                  context: context,
                                  barrierLabel: '',
                                  barrierDismissible: true,
                                  barrierColor: Colors.black,
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          child: QrImageView(
                                            data: userState.user!['id']
                                                .toString(),
                                            version: QrVersions.auto,
                                            size: screenWidth * 0.6,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              screenWidth * 0.4,
                              const Color.fromARGB(255, 197, 34, 56)
                                  .withOpacity(0.7),
                            )
                          : Container(),
                      arrived
                          ? Container()
                          : CustomButtons().general(
                              openMap.isOpen ? 'Bitir' : 'Başla',
                              () {
                                if (openMap.isOpen) {
                                  _timer?.cancel();
                                } else {
                                  startForegroundTask();

                                  _timer = Timer.periodic(
                                      const Duration(seconds: 5), (timer) {
                                    checkIfArrived();
                                  });
                                }

                                ref
                                    .read(openMapProvider.notifier)
                                    .updateMap(!openMap.isOpen);
                              },
                              screenWidth * 0.4,
                              const Color.fromARGB(255, 197, 34, 56)
                                  .withOpacity(0.7),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  texts(String head, String text) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        height: screenWidth * 0.16,
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: screenWidth * 0.25,
              child: Text(
                head,
                style: GoogleFonts.openSans(
                  color: Variables.textGrey,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.5,
              child: Text(
                text,
                style: GoogleFonts.openSans(
                  color: Variables.textBlack,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*class UpdateTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    // Background task start
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // Background task event
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // Background task destroy
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {
    // TODO: implement onRepeatEvent
  }
}*/
