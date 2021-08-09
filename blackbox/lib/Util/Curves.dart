import 'package:flutter/material.dart';

import '../Constants.dart';

class CategoryTopCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Constants.black.withOpacity(0.7);

    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.09);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.14,
        size.width * 0.5, size.height * 0.14);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.14,
        size.width * 1.0, size.height * 0.09);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TopCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.lightBlueAccent[100]!.withOpacity(0.5);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.24);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.27,
        size.width * 0.5, size.height * 0.27);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.27,
        size.width * 1.0, size.height * 0.33);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.lightBlueAccent[100]!.withOpacity(0.5);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.86,
        size.width * 0.5, size.height * 0.86);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.86,
        size.width * 1.0, size.height * 0.9);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class StartCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.lightBlueAccent[100]!.withOpacity(0.5);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.66,
        size.width * 0.5, size.height * 0.66);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.66,
        size.width * 1.0, size.height * 0.60);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class QuestionTopCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.lightBlueAccent[100]!.withOpacity(0.5);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.13);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.07,
        size.width * 0.5, size.height * 0.07);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.07,
        size.width * 1.0, size.height * 0.04);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PassTopCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.lightBlueAccent[100]!.withOpacity(0.5);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.30);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.33,
        size.width * 0.5, size.height * 0.33);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.33,
        size.width * 1.0, size.height * 0.36);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ResultsBottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.lightBlueAccent[100]!.withOpacity(0.5);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.40);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.43,
        size.width * 0.5, size.height * 0.43);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.43,
        size.width * 1.0, size.height * 0.46);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
