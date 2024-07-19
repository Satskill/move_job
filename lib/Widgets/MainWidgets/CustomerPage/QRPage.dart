import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_job/Widgets/CustomWidgets/CustomAppBar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRPage extends ConsumerStatefulWidget {
  final data;
  const QRPage({required this.data, super.key});

  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends ConsumerState<QRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrState = ref.watch(qrProvider);
    final qrNotifier = ref.read(qrProvider.notifier);

    return Scaffold(
      appBar: CustomAppBar().authAppBar('QR Oku'),
      extendBodyBehindAppBar: true,
      body: qrState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : QRView(
              key: qrKey,
              onQRViewCreated: (controller) =>
                  _onQRViewCreated(controller, qrNotifier),
            ),
    );
  }

  void _onQRViewCreated(QRViewController controller, QRNotifier qrNotifier) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      final String reservationId =
          jsonDecode(scanData.code.toString())['rezervasyon_id'].toString();
      await qrNotifier.acceptQR(context, reservationId);
    });
  }
}

class QRState {
  final bool isLoading;
  final Barcode? result;

  QRState({this.isLoading = false, this.result});

  QRState copyWith({bool? isLoading, Barcode? result}) {
    return QRState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
    );
  }
}

class QRNotifier extends StateNotifier<QRState> {
  QRNotifier() : super(QRState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setResult(Barcode? result) {
    state = state.copyWith(result: result);
  }

  Future<void> acceptQR(BuildContext context, String reservationId) async {
    setLoading(true);
    //await Database().acceptQR(context, reservationId);
    setLoading(false);
  }
}

final qrProvider = StateNotifierProvider<QRNotifier, QRState>((ref) {
  return QRNotifier();
});
