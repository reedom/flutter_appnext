import 'package:flutter/material.dart';
import 'package:flutter_appnext/flutter_appnext.dart';

const placementID = 'b5c36d44-60b0-44e0-b489-683782e0ae2b';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Appnext Example App'),
        ),
        body: Builder(
          builder: (context) => Center(
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RaisedButton(onPressed: () => _showBannerAdScreen(context), child: Text('Banner Ad Test')),
                      RaisedButton(
                          onPressed: () => _showInterstitialAdScreen(context), child: Text('Interstitial Ad Test')),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }

  void _showBannerAdScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BannerAdScreen()));
  }

  void _showInterstitialAdScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => InterstitialAdScreen()));
  }
}

class BannerAdScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BannerAdScreenState();
  }
}

enum _Direction { vert, horz }

class _BannerAdScreenState extends State<BannerAdScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ANBannerAd _bannerAd;
  double _bannerOffsetX = 0.0;
  double _bannerOffsetY = 0.0;
  ANAnchorPosition _bannerPos = ANAnchorPosition.bottom;
  String _log = '';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Appnext Banner Ad Test'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          _bannerAd.dispose();
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        RaisedButton(onPressed: () => _bannerAd.loadAd(), child: Text('Load Banner')),
                        RaisedButton(onPressed: () => _bannerAd.hideBanner(), child: Text('Hide Banner')),
                        RaisedButton(onPressed: () => _bannerAd.dispose(), child: Text('Dispose Banner')),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RaisedButton(onPressed: () => _changeBanner(ANBannerType.Small), child: Text('Small Banner')),
                        RaisedButton(onPressed: () => _changeBanner(ANBannerType.Large), child: Text('Large Banner')),
                        RaisedButton(
                            onPressed: () => _changeBanner(ANBannerType.MediumRectangle),
                            child: Text('Rectangle Banner')),
                      ],
                    ),
                  ),
                ],
              ),
              _bannerSizeSlider(_Direction.horz),
              _bannerSizeSlider(_Direction.vert),
              _positionMenu(),
            ],
          ),
        ),
      ),
    );
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

  void log(String message) {
    setState(() => _log += '$message\n');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _bannerSizeSlider(_Direction dir) {
    final value = (dir == _Direction.horz) ? _bannerOffsetX : _bannerOffsetY;
    final setValue = (v) {
      if (dir == _Direction.horz) {
        _bannerOffsetX = v;
      } else {
        _bannerOffsetY = v;
      }
      _bannerAd.setAnchorOffset(Offset(_bannerOffsetX, _bannerOffsetY));
      setState(() {});
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(flex: 4, child: Slider(onChanged: setValue, value: value, min: -500.0, max: 500.0)),
        Flexible(flex: 1, child: Text(value.toStringAsFixed(1))),
        Flexible(
          flex: 2,
          child: RaisedButton(
            onPressed: () => setValue(0.0),
            child: Text('Reset'),
          ),
        )
      ],
    );
  }

  Widget _positionMenu() {
    return PopupMenuButton<ANAnchorPosition>(
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
    );
  }
}

class InterstitialAdScreen extends StatefulWidget {
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
                          RaisedButton(onPressed: () => _descInterstitial(), child: Text('Describe Interstitial')),
                          RaisedButton(onPressed: () => _interstitialAd.loadAd(), child: Text('Load Interstitial')),
                          RaisedButton(onPressed: () => _interstitialAd.showAd(), child: Text('Show Interstitial')),
                          RaisedButton(onPressed: () => _setInterstitialProps(), child: Text('Set Interstitial props')),
                          RaisedButton(onPressed: () => _interstitialAd.dispose(), child: Text('Dispose Interstitial')),
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
