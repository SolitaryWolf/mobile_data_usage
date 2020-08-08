import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_response.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/record.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/year_record.dart';
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
    _mobileDataUsageBloc.handleData(records);

    return StreamBuilder<List<YearRecord>>(
        stream: _mobileDataUsageBloc.bsYearRecords.stream,
        builder: (context, AsyncSnapshot<List<YearRecord>> snapshot) {
          final yearRecords = snapshot.data;

          return (yearRecords != null && yearRecords.length > 0)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Data from 2008 to 2018(Petabytes)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 18),
                          Text(
                            'Year',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Data Volume',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Impairment',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: _buildDataList(yearRecords),
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }

  Widget _buildDataList(List<YearRecord> yearRecords) {
    return RefreshIndicator(
      child: ListView.builder(
        itemCount: yearRecords.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                leading: Text(
                  yearRecords[index].year.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
                title: Text(
                    yearRecords[index].totalVolumeOfMobileDataInDec.toString()),
                trailing: Visibility(
                  child: Ink(
                    decoration: const ShapeDecoration(
                      color: AppColor.primaryColor,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Image.asset('assets/images/ic_decrease.png'),
                      color: Colors.white,
                      onPressed: () {
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.NO_HEADER,
                                animType: AnimType.SCALE,
                                headerAnimationLoop: false,
                                title: 'Decrease Description',
                                desc: yearRecords[index].decreaseDescription,
                                btnOkOnPress: () {},
                                btnOkColor: AppColor.primaryColor)
                            .show();
                      },
                    ),
                  ),
                  visible: yearRecords[index].hasDataDecrease ? true : false,
                )),
          );
        },
      ),
      onRefresh: _fetchData,
    );
  }

  Future<void> _fetchData() async {
    setState(() {
      _mobileDataUsageBloc.fetchMobileDataUsage();
    });
  }
}
