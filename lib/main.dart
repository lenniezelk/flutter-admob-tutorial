import 'package:admob_flutter/admob_flutter.dart';
import 'package:admob_tut/ad_manager.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids
  Admob.initialize(AdManager.appId);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AdmobInterstitial interstitial;
  AdmobReward reward;

  @override
  void initState() {
    super.initState();
    interstitial = AdmobInterstitial(adUnitId: AdManager.interstitialId);
    interstitial.load();
    reward = AdmobReward(
        adUnitId: AdManager.rewardId,
        listener: (event, args) {
          if (event == AdmobAdEvent.rewarded) {
            print("User rewarded.......");
          }
        });
    reward.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admob"),
      ),
      body: Column(
        children: <Widget>[
          AdmobBanner(
              adUnitId: AdManager.bannerId, adSize: AdmobBannerSize.BANNER),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  if (await interstitial.isLoaded) {
                    interstitial.show();
                  }
                },
                child: Text("Interstitial Ad"),
              ),
              SizedBox(
                width: 10.0,
              ),
              RaisedButton(
                onPressed: () async {
                  if (await reward.isLoaded) {
                    reward.show();
                  }
                },
                child: Text("Reward Ad"),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  if (index % 12 == 0 && index != 0) {
                    return AdmobBanner(
                        adUnitId: AdManager.bannerId,
                        adSize: AdmobBannerSize.LARGE_BANNER);
                  }
                  return ListTile(
                    title: Text('Item $index'),
                  );
                }),
          )
        ],
      ),
    );
  }
}
