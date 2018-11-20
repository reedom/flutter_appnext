import 'package:flutter/material.dart';
import 'package:flutter_appnext_example/screens/banner_screen.dart';
import 'package:flutter_appnext_example/screens/interstitial_screen.dart';
import 'package:flutter_appnext_example/screens/native_screen.dart';

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
                      RaisedButton(onPressed: () => _showNativeAdScreen(context), child: Text('Native Ad Test')),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }

  void _showBannerAdScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BannerAdScreen(placementID)));
  }

  void _showInterstitialAdScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => InterstitialAdScreen(placementID)));
  }

  _showNativeAdScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NativeAdScreen(placementID)));
  }
}
