import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(-6.200000, 106.816666); // Default to Jakarta
  String _currentAddress = 'alamat tidak ditemukan';
  Marker? _marker;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Lokasi layanan tidak aktif, tampilkan pesan
      await Geolocator.openLocationSettings();
      return;
    }
    // Implementasi untuk mendapatkan lokasi saat ini
    // Misalnya menggunakan Geolocator atau plugin lainnya
    // Setelah mendapatkan lokasi, update _currentPosition dan _marker
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Izin lokasi ditolak, tampilkan pesan
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Izin lokasi ditolak')));
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentPosition = LatLng(position.latitude, position.longitude);
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );
    Placemark place = placemarks[0];

    setState(() {
      _marker = Marker(
        markerId: MarkerId('current_location'),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: 'Lokasi Saat Ini',
          snippet: '${place.street},${place.locality}',
        ),
      );
      _currentAddress =
          '${place.name}${place.street}, ${place.locality}, ${place.country}';
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 15.0),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google map + Geolocator + Geocoding')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 15.0,
            ),
            markers: _marker != null ? {_marker!} : {},
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.white,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(_currentAddress, style: TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Refresh Loaksi ',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
