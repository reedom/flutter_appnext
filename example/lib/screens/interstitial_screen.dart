import 'package:flutter/material.dart';
import 'package:flutter_appnext/flutter_appnext.dart';

class InterstitialAdScreen extends StatefulWidget {
  final String placementID;

  InterstitialAdScreen(this.placementID);

  @override
  State<StatefulWidget> createState() {
    return _InterstitialAdScreenState();
  }
}

class _InterstitialAdScreenState extends State<InterstitialAdScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ANInterstitialAd _interstitialAd;
  String _log = '';

  @override
  void initState() {
    super.initState();

    final adConfiguration = ANAdConfiguration(postback: 'qaTest');
    _interstitialAd = ANInterstitialAd(
      placementID: widget.placementID,
      adConfiguration: adConfiguration,
      adLoaded: (_) => log('adLoaded'),
      adOpened: (_) => log('adOpened'),
      adClicked: (_) => log('adClicked'),
      adUserWillLeaveApplication: (_) => log('adUserWillLeaveApplication'),
      adError: (_, error) => showInSnackBar('interestitial error: $error'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Appnext Interstitial Ad Test'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          _interstitialAd.dispose();
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RaisedButton(onPressed: () => _descInterstitial(), child: Text('(describe)')),
                          RaisedButton(onPressed: () => _interstitialAd.loadAd(), child: Text('loadAd')),
                          RaisedButton(onPressed: () => _interstitialAd.showAd(), child: Text('showAd')),
                          RaisedButton(onPressed: () => _setInterstitialProps(), child: Text('(set props)')),
                          RaisedButton(onPressed: () => _interstitialAd.dispose(), child: Text('dispose')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: <Widget>[
                Expanded(child: Text(_log, maxLines: null)),
              ]),
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

  void log(String message) {
    setState(() => _log += '$message\n');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
