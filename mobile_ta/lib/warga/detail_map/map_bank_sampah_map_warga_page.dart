import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class WargaMapBankSampahMapWargaPage extends StatefulWidget {
  final double latitudeWarga;
  final double longitudeWarga;
  final double latitudeBankSampah;
  final double longitudeBankSampah;

  const WargaMapBankSampahMapWargaPage({
    super.key,
    required this.latitudeWarga,
    required this.longitudeWarga,
    required this.latitudeBankSampah,
    required this.longitudeBankSampah,
  });

  @override
  State<WargaMapBankSampahMapWargaPage> createState() =>
      _WargaMapBankSampahMapWargaPageState();
}

class _WargaMapBankSampahMapWargaPageState
    extends State<WargaMapBankSampahMapWargaPage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('warga'),
        position: LatLng(widget.latitudeWarga, widget.longitudeWarga),
        infoWindow: const InfoWindow(title: "Lokasi Warga"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId('bank_sampah'),
        position: LatLng(widget.latitudeBankSampah, widget.longitudeBankSampah),
        infoWindow: const InfoWindow(title: "Lokasi Bank Sampah"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    };
  }

  LatLngBounds _getBounds() {
    final latitudes = [widget.latitudeWarga, widget.latitudeBankSampah];
    final longitudes = [widget.longitudeWarga, widget.longitudeBankSampah];

    final northeast = LatLng(latitudes.reduce(max), longitudes.reduce(max));

    final southwest = LatLng(latitudes.reduce(min), longitudes.reduce(min));

    return LatLngBounds(northeast: northeast, southwest: southwest);
  }

  @override
  Widget build(BuildContext context) {
    final midLat = (widget.latitudeWarga + widget.latitudeBankSampah) / 2;
    final midLng = (widget.longitudeWarga + widget.longitudeBankSampah) / 2;

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
        initialCameraPosition: CameraPosition(
          target: LatLng(midLat, midLng),
          zoom: 12,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _mapController.animateCamera(
              CameraUpdate.newLatLngBounds(_getBounds(), 50),
            );
          });
        },
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
