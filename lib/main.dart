import 'package:flutter/material.dart';
import 'map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute: "/",
                    routes: {
                      "/": (context) => Map_Screen(),
                    }
      // home: MyHomePage(),
    );
  }
}
                    
// class MyHomePage extends StatefulWidget {
//   @override
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<MyHomePage>{
//   GoogleMapController myController;
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             height: 500,
//             width: double.infinity,
//             child: GoogleMap(
//               onMapCreated: (controller) {
//                 setState(() {
//                   myController = controller;
//                 });
//               },
//               options: GoogleMapOptions(
//                 scrollGesturesEnabled: true,
//                 tiltGesturesEnabled: true,
//                 rotateGesturesEnabled: true,
//                 myLocationEnabled: true,
//                 mapType: MapType.normal,
//                 trackCameraPosition: true,
//                 zoomGesturesEnabled: true,
                // cameraPosition: CameraPosition(
                //   target: LatLng(40.7128, -74.0060),
                //   zoom: 10.0
                // )
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  // }
// }