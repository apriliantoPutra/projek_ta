import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF128d54)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Map',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Color(0xFF128d54),
            fontSize: 22,
          ),
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
