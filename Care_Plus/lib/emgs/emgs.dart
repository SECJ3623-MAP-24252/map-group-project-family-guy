// lib/screens/emergency_location_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EmergencyLocationPage extends StatefulWidget {
  const EmergencyLocationPage({Key? key}) : super(key: key);

  @override
  _EmergencyLocationPageState createState() => _EmergencyLocationPageState();
}

class _EmergencyLocationPageState extends State<EmergencyLocationPage> {
  Position? _position;
  String _status = 'Locating…';
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever ||
        perm == LocationPermission.denied) {
      setState(() {
        _status = 'Location permission denied';
      });
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _position = pos;
        _status =
            'Located: ${pos.latitude.toStringAsFixed(6)}, ${pos.longitude.toStringAsFixed(6)}';
        _markers.add(
          Marker(
            markerId: const MarkerId('emergency'),
            position: LatLng(pos.latitude, pos.longitude),
          ),
        );
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)),
      );
    } catch (e) {
      setState(() {
        _status = 'Error getting location';
      });
    }
  }

  Future<void> _shareEmergency() async {
    if (_position == null) return;
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
    await FirebaseFirestore.instance.collection('emergencies').add({
      'userId': uid,
      'timestamp': FieldValue.serverTimestamp(),
      'latitude': _position!.latitude,
      'longitude': _position!.longitude,
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Emergency location shared!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1FDF2),
        title: const Text('Emergency Location'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _position == null
                    ? Center(child: Text(_status))
                    : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          _position!.latitude,
                          _position!.longitude,
                        ),
                        zoom: 16,
                      ),
                      markers: _markers,
                      onMapCreated: (ctrl) => _mapController = ctrl,
                    ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                Text(_status, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('Share Emergency Location'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: _position == null ? null : _shareEmergency,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
