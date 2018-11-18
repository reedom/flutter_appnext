import 'package:flutter/material.dart';
import 'package:flutter_appnext/flutter_appnext.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const placementID = 'b5c36d44-60b0-44e0-b489-683782e0ae2b';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ANBannerAd _bannerAd;
  ANInterstitialAd _interstitialAd;
  String _log = '';
  double _bannerOffsetX = 0.0;
  double _bannerOffsetY = 0.0;
  ANAnchorPosition _bannerPos = ANAnchorPosition.bottom;

  @override
  void initState() {
    super.initState();

    _bannerAd = ANBannerAd(
      placementID: placementID,
      adLoaded: (_) => log('banner loaded'),
      adOpened: (_) => log('banner opened'),
      adClicked: (_) => log('banner clicked'),
      adImpressionReported: (_) => log('banner clicked'),
      adError: (err) => showInSnackBar('banner error: ${err.error}'),
    );

    final adConfiguration = ANAdConfiguration(postback: 'qaTest');
    _interstitialAd = ANInterstitialAd(
      placementID: placementID,
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
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      RaisedButton(onPressed: () => _bannerAd.loadAd(), child: Text('Load Banner')),
                      RaisedButton(onPressed: () => _bannerAd.showBanner(), child: Text('Show Banner')),
                      RaisedButton(onPressed: () => _bannerAd.hideBanner(), child: Text('Hide Banner')),
                      RaisedButton(onPressed: () => _changeBanner(ANBannerType.Small), child: Text('Small Banner')),
                      RaisedButton(onPressed: () => _changeBanner(ANBannerType.Large), child: Text('Large Banner')),
                      RaisedButton(
                          onPressed: () => _changeBanner(ANBannerType.MediumRectangle),
                          child: Text('Rectangle Banner')),
                      RaisedButton(onPressed: () => _setBannerProps(), child: Text('Set Banner props')),
                      RaisedButton(onPressed: () => _bannerAd.dispose(), child: Text('Dispose Banner')),
                      Slider(
                          onChanged: (v) {
                            _bannerOffsetX = v;
                            setState(() {
                              _bannerAd.setAnchorOffset(Offset(_bannerOffsetX, _bannerOffsetY));
                            });
                          },
                          value: _bannerOffsetX,
                          min: -500.0,
                          max: 500.0),
                      Slider(
                          onChanged: (v) {
                            _bannerOffsetY = v;
                            setState(() {
                              _bannerAd.setAnchorOffset(Offset(_bannerOffsetX, _bannerOffsetY));
                            });
                          },
                          value: _bannerOffsetY,
                          min: -500.0,
                          max: 500.0),
                      PopupMenuButton<ANAnchorPosition>(
                        initialValue: _bannerPos,
                        onSelected: (v) {
                          _bannerAd.setAnchorPosition(v);
                          setState(() => _bannerPos = v);
                        },
                        itemBuilder: (_) => [
                              const PopupMenuItem(value: ANAnchorPosition.none, child: Text('none')),
                              const PopupMenuItem(value: ANAnchorPosition.bottomRight, child: Text('bottomRight')),
                              const PopupMenuItem(value: ANAnchorPosition.bottomLeft, child: Text('bottomLeft')),
                              const PopupMenuItem(value: ANAnchorPosition.bottom, child: Text('bottom')),
                              const PopupMenuItem(value: ANAnchorPosition.topRight, child: Text('topRight')),
                              const PopupMenuItem(value: ANAnchorPosition.topLeft, child: Text('topLeft')),
                              const PopupMenuItem(value: ANAnchorPosition.top, child: Text('top')),
                              const PopupMenuItem(value: ANAnchorPosition.right, child: Text('right')),
                              const PopupMenuItem(value: ANAnchorPosition.left, child: Text('left')),
                              const PopupMenuItem(value: ANAnchorPosition.center, child: Text('center')),
                            ],
                      )
                    ]),
                  ),
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      RaisedButton(onPressed: () => _descInterstitial(), child: Text('Describe Interstitial')),
                      RaisedButton(onPressed: () => _interstitialAd.loadAd(), child: Text('Load Interstitial')),
                      RaisedButton(onPressed: () => _interstitialAd.showAd(), child: Text('Show Interstitial')),
                      RaisedButton(onPressed: () => _setInterstitialProps(), child: Text('Set Interstitial props')),
                      RaisedButton(onPressed: () => _interstitialAd.dispose(), child: Text('Dispose Interstitial')),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _log,
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ],
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

  void _setBannerProps() {}

  void _changeBanner(ANBannerType bannerType) {
    _bannerAd.dispose();

    _bannerAd = ANBannerAd(
      placementID: placementID,
      bannerType: bannerType,
      anchorOffset: Offset(_bannerOffsetX, _bannerOffsetY),
      anchorPosition: _bannerPos,
      adLoaded: (_) => log('banner loaded'),
      adOpened: (_) => log('banner opened'),
      adClicked: (_) => log('banner clicked'),
      adImpressionReported: (_) => log('banner adImpressionReported'),
      adError: (err) => showInSnackBar('banner error: ${err.error}'),
    );
  }
}
