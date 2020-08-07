import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_response.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/record.dart';
import 'package:mobile_data_usage/pages/base/base_bloc.dart';
import 'package:mobile_data_usage/pages/mobile_data_usage/mobile_data_usage_bloc.dart';
import 'package:mobile_data_usage/services/common/app_loading_service.dart';
import 'package:mobile_data_usage/widgets/app_loading.dart';

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
    return StreamBuilder<MobileDataUsageResponse>(
      stream: _mobileDataUsageBloc.bsMobileDataUsage.stream,
      builder: (context, AsyncSnapshot<MobileDataUsageResponse> snapshot) {
        if (snapshot.hasData) {
          // Handle error from server
          if (snapshot.data.error != null &&
              snapshot.data.error.type.isNotEmpty) {
            return _buildErrorWidget(snapshot.data.error.type);
          }
          // Handle data from server
          return _buildMobileDataUsageWidget(snapshot.data.result.records);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: AppLoading());
        }
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error",
            style: Theme.of(context).textTheme.subtitle2),
      ],
    ));
  }

  Widget _buildMobileDataUsageWidget(List<Record> records) {
    String test = records[0].volumeOfMobileData;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Text(test));
  }
}
