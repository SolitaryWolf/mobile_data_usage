import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_data_usage/pages/base/base_bloc.dart';
import 'package:mobile_data_usage/pages/mobile_data_usage/mobile_data_usage_bloc.dart';
import 'package:mobile_data_usage/pages/mobile_data_usage/mobile_data_usage_page.dart';
import 'package:mobile_data_usage/services/common/app_loading_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'utils/app_config.dart';

Future<void> main() async {
  // Init dev config
  Config(environment: Env.dev());
  await myMain();
}

Future<void> myMain() async {
  // Start services later
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);

  // Run Application
  runApp(
      MultiProvider(
        providers: <SingleChildWidget>[

          Provider<AppLoadingProvider>(create: (_) => AppLoadingProvider()),
        ],

        child: MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider<MobileDataUsageBloc>(
        blocBuilder: () => MobileDataUsageBloc(),
        child: MobileDataUsagePage(title: 'Singapore Mobile Data Usage'),
      ),
    );
  }
}

