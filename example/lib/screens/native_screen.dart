import 'package:flutter/material.dart';
import 'package:flutter_appnext/flutter_appnext.dart';

class NativeAdScreen extends StatefulWidget {
  final String placementID;

  NativeAdScreen(this.placementID);

  @override
  State<StatefulWidget> createState() {
    return _NativeAdScreenState();
  }
}

class _NativeAdScreenState extends State<NativeAdScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ANNativeAd _nativeAd;
  String _log = '';
  BuildContext _context;
  List<ANAdData> _ads;
  bool _adVisible = false;
  bool _adInAction = false;

  @override
  void initState() {
    super.initState();

    _nativeAd = ANNativeAd(
      placementID: widget.placementID,
      adsLoaded: _adsLoaded,
      errorForRequest: (_, error) => showInSnackBar('native error: ${error}'),
      storeOpened: _storeOpened,
      errorForAdData: _errorForAdData,
      successOpeningAppnextPrivacy: (_, __) => log('successOpeningAppnextPrivacy'),
      failureOpeningAppnextPrivacy: (_, __) => log('failureOpeningAppnextPrivacy'),
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Appnext Native Ad Test'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          _nativeAd.dispose();
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
                        RaisedButton(onPressed: () => _handleLoadAd(), child: Text('loadAd')),
                        RaisedButton(onPressed: () => _handleShowAdd(), child: Text('(show ad)')),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [],
                    ),
                  ),
                ],
              ),
              _adWidget(context),
              SingleChildScrollView(
                child: Row(children: <Widget>[
                  Expanded(child: Text(_log, maxLines: null)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void log(String message) {
    setState(() => _log += '$message\n');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void _adsLoaded(ANNativeAd instance, List<ANAdData> ads) {
    log('adsLoaded: length=${ads.length}');
    setState(() {
      _ads = ads;
      _adVisible = false;
    });

    for (ANAdData adData in ads) {
      if (adData.urlImg != null) {
        precacheImage(NetworkImage(adData.urlImg), _context);
      }
      if (adData.urlImgWide != null) {
        precacheImage(NetworkImage(adData.urlImgWide), _context);
      }
    }
  }

  _handleLoadAd() {
    _nativeAd.loadAds(
      count: 1,
      creativeType: ANCreativeType.Managed,
      clickInApp: false,
    );
  }

  void _handleShowAdd() {
    if (_ads != null && 0 < _ads.length && !_adVisible) {
      _nativeAd.adImpression(_ads[0].bannerID);
      setState(() => _adVisible = true);
    }
  }

  Widget _adWidget(BuildContext context) {
    if (!_adVisible || _ads == null || _ads.length == 0) {
      return Container();
    }
    ANAdData ad = _ads[0];
    var theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Stack(children: [
          Image.network(
            ad.urlImg,
            height: 150.0,
          )
        ]),
        Column(children: [
          GestureDetector(
            onTap: _adInAction ? null : () => _handleAdClick(ad),
            child: LimitedBox(
              maxHeight: 210.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    ad.urlImgWide,
                  ),
                  _adInAction
                      ? CircularProgressIndicator(
                          backgroundColor: theme.primaryColor,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Container(child: Text(ad.title)),
        ]),
      ],
    );
  }

  void _handleAdClick(ANAdData ad) {
    setState(() => _adInAction = true);
    _nativeAd.adClicked(ad.bannerID);
  }

  void _storeOpened(ANNativeAd instance, ANAdData adData) {
    log('storeOpened');
    setState(() => _adInAction = false);
  }

  void _errorForAdData(ANNativeAd instance, String error, ANAdData adData) {
    showInSnackBar('native error: ${error}');
    setState(() => _adInAction = false);
  }
}
