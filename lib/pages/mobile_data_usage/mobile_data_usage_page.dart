import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_response.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/record.dart';
import 'package:mobile_data_usage/pages/base/base_bloc.dart';
import 'package:mobile_data_usage/pages/mobile_data_usage/mobile_data_usage_bloc.dart';
import 'package:mobile_data_usage/services/common/app_loading_service.dart';
import 'package:mobile_data_usage/utils/app_color.dart';
import 'package:mobile_data_usage/widgets/app_button.dart';
import 'package:mobile_data_usage/widgets/app_loading.dart';
import 'package:rxdart/rxdart.dart';

class MobileDataUsagePage extends StatefulWidget {
  final String title;

  MobileDataUsagePage({Key key, this.title}) : super(key: key);

  @override
  _MobileDataUsagePageState createState() => _MobileDataUsagePageState();
}

class _MobileDataUsagePageState extends State<MobileDataUsagePage> {
  MobileDataUsageBloc _mobileDataUsageBloc;

  @override
  Future<void> initState() {
    super.initState();

    if (null == _mobileDataUsageBloc) {
      _mobileDataUsageBloc = BlocProvider.of<MobileDataUsageBloc>(context);
    }

    _mobileDataUsageBloc.fetchMobileDataUsage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Stack(
        children: <Widget>[
          _buildMainWidget(),
        ],
      ),
    );
  }

  Widget _buildMainWidget() {
    return StreamBuilder<MobileDataUsageResponse>(
      stream: _mobileDataUsageBloc.bsMobileDataUsage.stream,
      builder: (context, AsyncSnapshot<MobileDataUsageResponse> snapshot) {
        if (snapshot.hasData) {
          // Handle error from server
          if (snapshot.data.error != null &&
              snapshot.data.error.type.isNotEmpty) {
            return _buildErrorWidget(snapshot.data.error.type);
          } else if (snapshot.data.dioError != null) {
            return _buildErrorWidget(snapshot.data.dioError.error);
          }
          // Handle data from server
          return _buildMobileDataUsageWidget(snapshot.data.result.records);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          // Display loading widget
          return AppLoading();
        }
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    Future.delayed(
        Duration.zero,
        () => AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: false,
                title: 'Error',
                desc: error,
                btnOkOnPress: () {},
                btnOkColor: Colors.red)
            .show());

    return Center(
        child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppButton(
            text: 'Retry',
            onPressed: () async {
              AppLoadingProvider.show(context);
              await _mobileDataUsageBloc.fetchMobileDataUsage();
              AppLoadingProvider.hide(context);
            },
          ),
        ],
      ),
    ));
  }

  Widget _buildMobileDataUsageWidget(List<Record> records) {
    String test = records[0].volumeOfMobileData;
    return Text(test);
  }
}
