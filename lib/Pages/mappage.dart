import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  final v1, v2, v3, v4;
  MapsPage(this.v1, this.v2, this.v3, this.v4);
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  Position? userLocation;
  GoogleMapController? mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    userLocation = await Geolocator.getCurrentPosition();
    return userLocation!;
  }

  double? latitude, longitude;
  var rmutt, title;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    latitude = double.parse(widget.v1);
    longitude = double.parse(widget.v2);
    rmutt = widget.v3;
    title = widget.v4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: LatLng(latitude!, longitude!), zoom: 16),
              markers: {
                Marker(
                  markerId: MarkerId("1"),
                  position: LatLng(latitude!, longitude!),
                  infoWindow: InfoWindow(title: title, snippet: rmutt),
                ),
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     mapController?.animateCamera(CameraUpdate.newLatLngZoom(
      //         LatLng(userLocation!.latitude, userLocation!.longitude), 18));
      //     showDialog(
      //       context: context,
      //       builder: (context) {
      //         return AlertDialog(
      //           content: Text(
      //               'Your location has been send !\nlat: ${userLocation!.latitude} long: ${userLocation!.longitude} '),
      //         );
      //       },
      //     );
      //   },
      //   label: Text("Send Location"),
      //   icon: Icon(Icons.near_me),
      // ),
    );
  }
}
