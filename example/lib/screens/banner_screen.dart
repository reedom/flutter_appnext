import 'package:flutter/material.dart';
import 'package:flutter_appnext/flutter_appnext.dart';

class BannerAdScreen extends StatefulWidget {
  final String placementID;

  BannerAdScreen(this.placementID);

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
      placementID: widget.placementID,
      adLoaded: (_) => log('adLoaded'),
      adOpened: (_) => log('adOpened'),
      adClicked: (_) => log('adClicked'),
      adImpressionReported: (_) => log('adImpressionReported'),
      adError: (_, error) => showInSnackBar('banner error: $error'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                        RaisedButton(onPressed: () => _bannerAd.loadAd(), child: Text('loadAd')),
                        RaisedButton(onPressed: () => _bannerAd.hideBanner(), child: Text('hideBanner')),
                        RaisedButton(onPressed: () => _bannerAd.dispose(), child: Text('dispose')),
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
              Row(children: <Widget>[
                Expanded(child: Text(_log, maxLines: null)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void _changeBanner(ANBannerType bannerType) {
    _bannerAd.dispose();

    _bannerAd = ANBannerAd(
      placementID: widget.placementID,
      bannerType: bannerType,
      anchorOffset: Offset(_bannerOffsetX, _bannerOffsetY),
      anchorPosition: _bannerPos,
      adLoaded: (_) => log('banner loaded'),
      adOpened: (_) => log('banner opened'),
      adClicked: (_) => log('banner clicked'),
      adImpressionReported: (_) => log('banner adImpressionReported'),
      adError: (_, error) => showInSnackBar('banner error: $error'),
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
