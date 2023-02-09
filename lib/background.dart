import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0.h,
                right: 0.h,
                child: Image.asset("assets/images/top1.png", width: size.width),
              ),
              Positioned(
                top: 0.h,
                right: 0.h,
                child: Image.asset("assets/images/top2.png", width: size.width),
              ),
              Positioned(
                top: 300.h,
                left: -131.h,
                child: Container(
                  width: 700,
                  height: 700,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bottom2.png")),
                    borderRadius: BorderRadius.all(
                      Radius.circular(350),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 245.h,
                left: -131.h,
                child: Container(
                  width: 700,
                  height: 700,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bottom1.png")),
                    borderRadius: BorderRadius.all(
                      Radius.circular(350),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 30,
                child: Image.asset("assets/images/main.png",
                    width: size.width * 0.35),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
