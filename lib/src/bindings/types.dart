// File created by
// Lung Razvan <long1eu>
// on 22/08/2019

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:h3/h3.dart';

class GeoCoordNative extends Struct {
  factory GeoCoordNative.allocate(double lat, double lon) {
    return calloc<GeoCoordNative>().ref
      ..lat = lat
      ..lon = lon;
  }

  static Pointer<GeoCoordNative> create(double lat, double lon) {
    var _pointer = calloc<GeoCoordNative>();
    _pointer.ref
      ..lat = lat
      ..lon = lon;
    return _pointer;
  }

  /// latitude in radians
  @Double()
  double? lat;

  /// longitude in radians
  @Double()
  double? lon;

  @override
  String toString() => 'GeoCoordNative{lat: $lat, lon: $lon}';
}

class GeoPolygonNative {
  GeoPolygonNative._(this.geofence, this.geofenceNum, this.holes,
      this.holesSizes, this.holesNum);

  final Pointer<GeoCoordNative> geofence;
  final int geofenceNum;
  final Pointer<Pointer<GeoCoordNative>> holes;
  final Pointer<Int32> holesSizes;
  final int holesNum;

  factory GeoPolygonNative.allocate(GeoPolygon geoPolygon) {
    final int geofenceNum = geoPolygon.geofence.length;
    final Pointer<GeoCoordNative> geofence =
        calloc<GeoCoordNative>(geofenceNum);
    for (int i = 0; i < geofenceNum; i++) {
      // final GeoCoordNative item = geofence.elementAt(i).ref
      //   ..lat = geoPolygon.geofence[i].lat
      //   ..lon = geoPolygon.geofence[i].lon;
    }

    final int holesNum = geoPolygon.holes.length;
    final Pointer<Int32> holesSizes = calloc<Int32>(holesNum);
    final Pointer<Pointer<GeoCoordNative>> holes =
        calloc<Pointer<GeoCoordNative>>(holesNum);

    for (int i = 0; i < holesNum; i++) {
      final List<GeoCoord> hole = geoPolygon.holes[i];
      final int holeLength = hole.length;
      holesSizes.elementAt(i).value = holeLength;

      final Pointer<GeoCoordNative> holePtr =
          calloc<GeoCoordNative>(holeLength);
      for (int j = 0; j < holeLength; j++) {
        final GeoCoordNative item = holePtr.elementAt(j).ref;
        item.lat = hole[j].lat;
        item.lon = hole[j].lon;
      }

      holes.elementAt(i).value = holePtr;
    }

    return GeoPolygonNative._(
        geofence, geofenceNum, holes, holesSizes, holesNum);
  }

  void dispose() {
    calloc.free(geofence);
    calloc.free(holesSizes);
    for (int j = 0; j < holesNum; j++) {
      final Pointer<GeoCoordNative> item = holes.elementAt(j).value;
      calloc.free(item);
    }
    calloc.free(holes);
  }
}
