import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

// Generic painter that can save its canvas as an image
class RecordablePainter extends CustomPainter {

  // Picture recorder to save the canvas as an image
  PictureRecorder recorder = PictureRecorder();

  // Object used for random generation
  Random rnd = Random();

  // Default used colors
  final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple, Colors.pink ];

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    throw UnimplementedError();
  }

  // Save the canvas as an image in the phone gallery
  saveImage() async {
    paint(Canvas(recorder), Size(500, 500));
    var picture = recorder.endRecording();
    var image = await picture.toImage(500, 500);
    var pngBytes = await image.toByteData(format: ImageByteFormat.png);
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if(permissions[PermissionGroup.storage] == PermissionStatus.granted) {
      await ImageGallerySaver.saveImage(pngBytes.buffer.asUint8List());
    }
  }
}

class PointsPainter extends RecordablePainter {
  @override
  void paint(Canvas canvas, Size size) {
    for(var i in List.generate(100, (i) => i))
    canvas.drawPoints(
      PointMode.points, 
      [
        for(var i in List.generate(5, (i) => i))
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height)
      ],
      Paint()
        ..color = colors[rnd.nextInt(colors.length)]
        ..strokeWidth = 4 + rnd.nextDouble() * 32
        ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(PointsPainter oldDelegate) => true;
}

class LinesPainter extends RecordablePainter {
  @override
  void paint(Canvas canvas, Size size) {
    List.generate(100, (i) => i).forEach((i) =>
    canvas.drawLine(
      Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
      Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
      Paint()
        ..color = colors[rnd.nextInt(colors.length)]
        ..strokeWidth = 4 + rnd.nextDouble() * 16
        ..strokeCap = StrokeCap.butt));
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) => true;
}

class ShadowsPainter extends RecordablePainter {
  @override
  void paint(Canvas canvas, Size size) {
    List.generate(8, (i) => i).forEach((i) =>
    canvas.drawShadow(
      Path()
      ..addPolygon(
        List.generate(1+rnd.nextInt(8), (i) => 
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height)),
        false
      ),
      colors[rnd.nextInt(colors.length)],
      rnd.nextDouble() * 8,
      false));
  }

  @override
  bool shouldRepaint(ShadowsPainter oldDelegate) => true;
}


class OvalsPainter extends RecordablePainter {
  @override
  void paint(Canvas canvas, Size size) {
    List.generate(100, (i) => i).forEach((i) =>
      canvas.drawOval(
        Rect.fromPoints(
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        ),
        Paint()
          ..color = colors[rnd.nextInt(colors.length)]
      )
    );
  }

  @override
  bool shouldRepaint(OvalsPainter oldDelegate) => true;
}

class TrianglesPainter extends RecordablePainter {
  @override
  void paint(Canvas canvas, Size size) {
    List.generate(100, (i) => i).forEach((i) =>
      canvas.drawPath(
        Path()..addPolygon([
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        ], true),
        Paint()
          ..color = colors[rnd.nextInt(colors.length)]
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round)
    );
  }

  @override
  bool shouldRepaint(TrianglesPainter oldDelegate) => true;
}

