import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _posicaoCamera = CameraPosition(
    target: LatLng(
      -18.585214,
      -46.514667
    ),
    zoom: 15
  );

  Set<Marker> _marcadores = {};

  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              -18.577082,
              -46.519495
          ),
          zoom: 15,
          tilt: 0,
          bearing: 0
        )
      )
    );
  }

  _carregarMarcadores(){
    Set<Marker> marcadoresLocal = {};

    Marker marcadorShopping = Marker(
        markerId: MarkerId("marcador-shopping"),
        position: LatLng(
            -18.585214,
            -46.514667
        ),
      infoWindow: InfoWindow(
        title: "Shopping Patos de Minas"
      ),
    );

    Marker marcadorBigPatos = Marker(
        markerId: MarkerId("marcador-shopping"),
        position: LatLng(
            -18.584106,
            -46.514351
        ),
        infoWindow: InfoWindow(
            title: "Big Patos"
        )
    );

    marcadoresLocal.add(marcadorShopping);
    marcadoresLocal.add(marcadorBigPatos);

    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  _recuperarLocalizacaoAtual() async{
    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
  }

  @override
  void initState(){
    super.initState();
    //_carregarMarcadores();
    _recuperarLocalizacaoAtual();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapas e Geolocalizações"),),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _movimentarCamera
      ),
      body: Container(
        child: GoogleMap(
         mapType: MapType.normal,
         //mapType: MapType.satellite,
          //-18.572082, -46.519495
          initialCameraPosition:  _posicaoCamera,
          onMapCreated: _onMapCreated,
          markers: _marcadores,
        ),
      ),
    );
  }
}
