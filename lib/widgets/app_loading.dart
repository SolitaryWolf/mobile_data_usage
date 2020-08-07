import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_data_usage/utils/app_color.dart';

class AppLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: const SpinKitDoubleBounce(color: AppColor.primaryColor),
        ),
      ),
    );
  }
}
