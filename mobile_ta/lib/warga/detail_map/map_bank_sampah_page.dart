import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WargaMapBankSampahPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String namaBank;

  const WargaMapBankSampahPage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.namaBank,
  });

  @override
  State<WargaMapBankSampahPage> createState() => _WargaMapBankSampahPageState();
}

class _WargaMapBankSampahPageState extends State<WargaMapBankSampahPage> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 15,
    );

    final Marker marker = Marker(
      markerId: const MarkerId('bank_sampah'),
      position: LatLng(widget.latitude, widget.longitude),
      infoWindow: InfoWindow(title: widget.namaBank),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Map',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: {marker},
        onMapCreated: (controller) => _mapController = controller,
        zoomControlsEnabled: false,
        myLocationEnabled: false,
      ),
    );
  }
}
