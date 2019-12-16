import 'dart:ffi';
import 'package:ffi/ffi.dart';

typedef hello_world_func = Pointer<Utf8> Function();

class TriangulateIO extends Struct {
  Pointer<Double> pointList;
  Pointer<Double> pointAttributeList;
  Pointer<Int32> pointMarkerList;

  @Int32()
  int numberOfPoints;
  @Int32()
  int numberOfPointAttributes;

  Pointer<Int32> triangleList;
  Pointer<Double> triangleAttributeList;
  Pointer<Double> triangleAreaList;
  Pointer<Int32> neighborList;
  @Int32()
  int numberOfTriangles;
  @Int32()
  int numberOfCorners;
  @Int32()
  int numberOfTriangleAttributes;

  Pointer<Int32> segmentList;
  Pointer<Int32> segmentMarkerList;
  @Int32()
  int numberOfSegments;

  Pointer<Double> holeList;
  @Int32()
  int numberOfHoles;

  Pointer<Double> regionList;
  @Int32()
  int numberOfRegions;

  Pointer<Int32> edgeList;
  Pointer<Int32> edgeMarkerList;
  Pointer<Double> normList;
  @Int32()
  int numberOfEdges;
}

typedef triangulate_func = Void Function(
    Pointer<Utf8> triSwitches,
    Pointer<TriangulateIO> input,
    Pointer<TriangulateIO> output,
    Pointer<TriangulateIO> voronoiOut);

typedef triangulateFunc = void Function(
    Pointer<Utf8> triSwitches,
    Pointer<TriangulateIO> input,
    Pointer<TriangulateIO> output,
    Pointer<TriangulateIO> vorout);

main() {
  var path = './c/triangle.dylib';
  final dylib = DynamicLibrary.open(path);

  final triangulateFunc triangulate = dylib
      .lookup<NativeFunction<triangulate_func>>('triangulate')
      .asFunction();

  Pointer<TriangulateIO> triIn = allocate();
  Pointer<TriangulateIO> triOut = allocate();
  Pointer<TriangulateIO> vorOut = allocate();

  var inStruct = triIn.ref;
  var outStruct = triOut.ref;
  var vorStruct = vorOut.ref;

  inStruct.numberOfPoints = 4;
  inStruct.numberOfPointAttributes = 1;

  inStruct.pointList = allocate(count: inStruct.numberOfPoints * 2);
  inStruct.pointList[0] = 0.0;
  inStruct.pointList[1] = 0.0;
  inStruct.pointList[2] = 1.0;
  inStruct.pointList[3] = 0.0;
  inStruct.pointList[4] = 1.0;
  inStruct.pointList[5] = 10.0;
  inStruct.pointList[6] = 0.0;
  inStruct.pointList[7] = 10.0;

  inStruct.pointAttributeList = allocate(
      count: inStruct.numberOfPoints * inStruct.numberOfPointAttributes);
  inStruct.pointAttributeList[0] = 0.0;
  inStruct.pointAttributeList[1] = 1.0;
  inStruct.pointAttributeList[2] = 11.0;
  inStruct.pointAttributeList[3] = 10.0;

  inStruct.pointMarkerList = allocate(count: inStruct.numberOfPoints);
  inStruct.pointMarkerList[0] = 0;
  inStruct.pointMarkerList[1] = 2;
  inStruct.pointMarkerList[2] = 0;
  inStruct.pointMarkerList[3] = 0;

  inStruct.numberOfSegments = 0;
  inStruct.numberOfHoles = 0;
  inStruct.numberOfRegions = 1;

  inStruct.regionList = allocate(count: inStruct.numberOfRegions * 4);
  inStruct.regionList[0] = 0.5;
  inStruct.regionList[1] = 5.0;
  inStruct.regionList[2] = 7.0;
  inStruct.regionList[3] = 0.1;

  outStruct.pointList = nullptr;
  outStruct.pointAttributeList = nullptr;
  outStruct.pointMarkerList = nullptr;
  outStruct.triangleList = nullptr;
  outStruct.triangleAttributeList = nullptr;
  outStruct.neighborList = nullptr;
  outStruct.segmentList = nullptr;
  outStruct.segmentMarkerList = nullptr;
  outStruct.edgeList = nullptr;
  outStruct.edgeMarkerList = nullptr;

  vorStruct.pointList = nullptr;
  vorStruct.pointAttributeList = nullptr;
  vorStruct.edgeList = nullptr;
  vorStruct.normList = nullptr;

  triangulate(Utf8.toUtf8("pczAevn"), triIn, triOut, vorOut);

  free(triIn);
  free(triOut);
  free(vorOut);
}
