import 'package:flutter/material.dart';
import 'package:flutter_appnext/flutter_appnext.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ANInterstitialAd _interstitialAd;
  String _log = '';

  @override
  void initState() {
    super.initState();
    final adConfiguration = ANAdConfiguration(postback: 'qaTest');
    _interstitialAd = ANInterstitialAd(
      placementID: 'b5c36d44-60b0-44e0-b489-683782e0ae2b',
      adConfiguration: adConfiguration,
      adLoaded: (_) => log('interestitial loaded'),
      adOpened: (_) => log('interestitial opened'),
      adClicked: (_) => log('interestitial clicked'),
      adUserWillLeaveApplication: (_) => log('interestitial user will leave app'),
      adError: (err) => showInSnackBar('interestitial error: ${err.error}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Flutter Appnext example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RaisedButton(onPressed: _descInterstitial, child: Text('Describe Interstitial')),
                  RaisedButton(onPressed: _loadInterstitial, child: Text('Load Interstitial')),
                  RaisedButton(onPressed: _showInterstitial, child: Text('Show Interstitial')),
                  RaisedButton(onPressed: _setInterstitialProps, child: Text('Set Interstitial props')),
                  RaisedButton(onPressed: _disposeInterstitial, child: Text('Dispose Interstitial')),
                  Expanded(
                    child: Text(
                      _log,
                      maxLines: null,
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _descInterstitial() async {
    final creativeType = await _interstitialAd.getCreativeType();
    final skipText = await _interstitialAd.getSkipText();
    final autoPlay = await _interstitialAd.getAutoPlay();
    final category = await _interstitialAd.getCategories();
    final postback = await _interstitialAd.getPostback();
    final buttonText = await _interstitialAd.getButtonText();
    final buttonColor = await _interstitialAd.getButtonColor();
    final orientation = await _interstitialAd.getPreferredOrientation();

    setState(() {
      _log = 'interstitialAd.creativeType = $creativeType\n' +
          'interstitialAd.skipText = $skipText\n' +
          'interstitialAd.autoPlay = $autoPlay\n' +
          'interstitialAd.category = $category\n' +
          'interstitialAd.postback = $postback\n' +
          'interstitialAd.buttonText = $buttonText\n' +
          'interstitialAd.buttonColor = $buttonColor\n' +
          'interstitialAd.orientation = ${preferredOrientationToString(orientation)}\n';
    });
  }

  void _loadInterstitial() async {
    _interstitialAd.loadAd();
  }

  void _showInterstitial() {
    _interstitialAd.showAd();
  }

  void log(String message) {
    setState(() => _log += '$message\n');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void _setInterstitialProps() {
    _interstitialAd.setCreativeType(ANCreativeType.Managed);
    _interstitialAd.setSkipText('Close');
    _interstitialAd.setAutoPlay(true);
    _interstitialAd.setCategories(['Music']);
    _interstitialAd.setPostback('myAppPostBack');
    _interstitialAd.setButtonColor('#FF0000');
    _interstitialAd.setPreferredOrientation(ANPreferredOrientation.Portrait);
    _descInterstitial();
  }

  void _disposeInterstitial() {
    _interstitialAd.dispose();
  }
}
