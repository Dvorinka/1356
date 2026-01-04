import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class OsmLocationPickerResult {
  final double latitude;
  final double longitude;
  final String address;

  OsmLocationPickerResult({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class OsmLocationPickerScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const OsmLocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<OsmLocationPickerScreen> createState() => _OsmLocationPickerScreenState();
}

class _OsmLocationPickerScreenState extends State<OsmLocationPickerScreen> {
  double _selectedLatitude = 0.0;
  double _selectedLongitude = 0.0;
  bool _isLoading = true;
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      if (widget.initialLatitude != null && widget.initialLongitude != null) {
        _selectedLatitude = widget.initialLatitude!;
        _selectedLongitude = widget.initialLongitude!;
      } else {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _selectedLatitude = position.latitude;
        _selectedLongitude = position.longitude;
      }
      
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _selectedLatitude = position.latitude;
        _selectedLongitude = position.longitude;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }

  void _confirmLocation() {
    Navigator.pop(
      context,
      OsmLocationPickerResult(
        latitude: _selectedLatitude,
        longitude: _selectedLongitude,
        address: _addressController.text.isEmpty 
            ? 'Custom Location'
            : _addressController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'Use current location',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.map, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                'OpenStreetMap View',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$_selectedLatitude, $_selectedLongitude',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Note: Full map integration requires\nGoogle Maps API key.\n'
                                'You can manually enter coordinates below.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: FloatingActionButton(
                          mini: true,
                          heroTag: 'zoom_in',
                          onPressed: () {
                            setState(() {
                              _selectedLatitude += 0.001;
                              _selectedLongitude += 0.001;
                            });
                          },
                          child: const Icon(Icons.add),
                        ),
                      ),
                      Positioned(
                        top: 72,
                        right: 16,
                        child: FloatingActionButton(
                          mini: true,
                          heroTag: 'zoom_out',
                          onPressed: () {
                            setState(() {
                              _selectedLatitude -= 0.001;
                              _selectedLongitude -= 0.001;
                            });
                          },
                          child: const Icon(Icons.remove),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Location Name (Optional)',
                            prefixIcon: Icon(Icons.location_on),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Latitude',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(
                                  text: _selectedLatitude.toStringAsFixed(6),
                                ),
                                onChanged: (value) {
                                  final lat = double.tryParse(value);
                                  if (lat != null) {
                                    setState(() => _selectedLatitude = lat);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Longitude',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(
                                  text: _selectedLongitude.toStringAsFixed(6),
                                ),
                                onChanged: (value) {
                                  final lng = double.tryParse(value);
                                  if (lng != null) {
                                    setState(() => _selectedLongitude = lng);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _confirmLocation,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Confirm Location'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
