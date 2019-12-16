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

  const List<double> vertexList = [0, 0, 512, 0, 512, 668, 0, 668];
  const List<int> edgeList = [0, 1, 1, 2, 2, 3, 3, 0];

  final Pointer<Double> pointList = allocate(count: vertexList.length);
  for (var i = 0; i < vertexList.length; i++) {
    pointList[i] = vertexList[i];
  }
  var inStruct = triIn.ref;
  inStruct.numberOfPoints = (vertexList.length / 2).floor();
  inStruct.pointList = pointList;

  final Pointer<Int32> segmentList = allocate(count: edgeList.length);
  for (var i = 0; i < edgeList.length; i++) {
    segmentList[i] = edgeList[i];
  }

  inStruct.numberOfSegments = (edgeList.length / 2).floor();
  inStruct.segmentList = segmentList;

  triangulate(Utf8.toUtf8("pzenQ"), triIn, triOut, null);

  free(triIn);
  free(triOut);
}
