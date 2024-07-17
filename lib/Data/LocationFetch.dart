import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // Handle location update (e.g., send to server or save locally)
    return Future.value(true);
  });
}
