import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.isSelecting = true,
      this.location = const PlaceLocation(
          latitude: 20.2, longitude: 300.3, address: "Dummy Addresss")});
  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<StatefulWidget> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen> {
  LatLng? pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? "Pick your location" : "Your Location"),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop(pickedLocation);
                },
                icon: const Icon(Icons.save))
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  pickedLocation = position;
                });
              },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.latitude),
          zoom: 16,
        ),
        markers: (pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                    markerId: const MarkerId("m1"),
                    position: pickedLocation ??
                        LatLng(
                            widget.location.latitude, widget.location.latitude))
              },
      ),
    );
  }
}
