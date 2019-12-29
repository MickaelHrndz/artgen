import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

// Generic painter that can save its canvas as an image
class RecordablePainter extends CustomPainter {

  // Picture recorder to save the canvas as an image
  ui.PictureRecorder recorder = ui.PictureRecorder();

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
    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if(permissions[PermissionGroup.storage] == PermissionStatus.granted) {
      await ImageGallerySaver.saveImage(pngBytes.buffer.asUint8List());
    }
  }
}

//Frank Farris equation : (cos(t) + cos(6t)/2 + sin(14t)/3, sin(t) + sin(6t)/2 + cos(14t)/3)
class FarrisPainter extends RecordablePainter {
  
  static final ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
          ui.ParagraphStyle(
            fontSize:   18,
            textAlign: TextAlign.center
          )
        );
          //..pushStyle(TextStyle(color: blue))
          
  @override
  void paint(Canvas canvas, Size size) {
    ui.Paragraph paragraph = paragraphBuilder.build()
          ..layout(ui.ParagraphConstraints(width: size.width)); 
    var paint = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    var a = rnd.nextInt(24);
    var b = rnd.nextInt(24);
    paragraphBuilder..pop()..pop();
    paragraphBuilder.pushStyle(ui.TextStyle(color: Colors.grey));
    paragraphBuilder.addText("($a,$b)");
    canvas.drawParagraph(paragraph, Offset(0, -16));
    var points = 5000;
    var iColor = 0;
    for(var i in List.generate(points, (i) => i)){
      var xi = i*(size.width / points);
      var yi = i*(size.height / points);
      iColor = iColor+1;
      if(iColor > colors.length-1) iColor = 0;
      canvas.drawPoints(
      ui.PointMode.points, 
      [
          Offset(
            (size.width /2)+(cos(xi) + cos(a*xi)/2 + sin(b*xi)/3)*100, 
            (size.height /2)+(sin(yi) + sin(a*yi)/2 + cos(b*yi)/3)*100)
          //Offset(i*(size.width / points), i*(size.height / points ))
      ],
      paint
        ..color = colors[iColor]);
    }
  }

  @override
  bool shouldRepaint(FarrisPainter oldDelegate) => true;
}
class PointsPainter extends RecordablePainter {
  @override
  void paint(Canvas canvas, Size size) {
    for(var i in List.generate(100, (i) => i))
    canvas.drawPoints(
      ui.PointMode.points, 
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

