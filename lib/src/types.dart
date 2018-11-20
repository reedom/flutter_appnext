import 'package:flutter/foundation.dart';

typedef ANVoidEvent<T> = void Function(T instance);
typedef ANValueEvent<T, U> = void Function(T instance, U value);

enum ANPreferredOrientation {
  Automatic, // 0
  Landscape, // 1
  Portrait, // 2
  NotSet, // 3
}

ANPreferredOrientation preferredOrientationFrom(String value) {
  switch (value) {
    case 'automatic':
      return ANPreferredOrientation.Automatic;
    case 'landscape':
      return ANPreferredOrientation.Landscape;
    case 'portrait':
      return ANPreferredOrientation.Portrait;
    case 'not_set':
      return ANPreferredOrientation.NotSet;
    default:
      if (value == null) {
        return null;
      }
      debugPrint('received unknown value for ANPreferredOrientation ($value)');
      return ANPreferredOrientation.NotSet;
  }
}

String preferredOrientationToString(ANPreferredOrientation value) {
  switch (value) {
    case ANPreferredOrientation.Automatic:
      return 'automatic';
    case ANPreferredOrientation.Landscape:
      return 'landscape';
    case ANPreferredOrientation.Portrait:
      return 'portrait';
    case ANPreferredOrientation.NotSet:
      return 'not_set';
    default:
      if (value == null) {
        return null;
      }
      debugPrint('unknown type ANPreferredOrientation.${value.index}');
      return 'not_set';
  }
}

enum ANCreativeType {
  Managed, // 0
  Video, // 1
  Static, // 2
  NotSet, // -1
}

ANCreativeType creativeTypeFrom(int value) {
  switch (value) {
    case -1:
      return ANCreativeType.NotSet;
    case 0:
      return ANCreativeType.Managed;
    case 1:
      return ANCreativeType.Video;
    case 2:
      return ANCreativeType.Static;
    default:
      if (value == null) {
        return null;
      }
      debugPrint('received unknown value for ANCreativeType ($value)');
      return ANCreativeType.NotSet;
  }
}

int creativeTypeToInt(ANCreativeType value) {
  switch (value) {
    case ANCreativeType.NotSet:
      return -1;
    case ANCreativeType.Managed:
    case ANCreativeType.Video:
    case ANCreativeType.Static:
      return value.index;
    default:
      if (value == null) {
        return null;
      }
      debugPrint('unknown type for ANCreativeType.${value.index}');
      return ANCreativeType.NotSet.index;
  }
}

enum ANCreative {
  Static, // 0
  Video, // 1
  All, //2
}

ANCreative creativeFrom(int value) {
  switch (value) {
    case 0:
      return ANCreative.Static;
    case 1:
      return ANCreative.Video;
    case 2:
      return ANCreative.All;
    default:
      if (value == null) {
        return null;
      }
      debugPrint('received unknown value for ANCreative ($value)');
      return ANCreative.All;
  }
}

int creativeToInt(ANCreative value) {
  switch (value) {
    case ANCreative.Static:
    case ANCreative.Video:
    case ANCreative.All:
      return value.index;
    default:
      if (value == null) {
        return null;
      }
      debugPrint('unknown type for ANCreative.${value.index}');
      return ANCreative.All.index;
  }
}

enum ANVideoLength {
  Short, // 0
  Long, // 1
  Auto, // 2
}

ANVideoLength videoLengthFrom(int value) {
  switch (value) {
    case 0:
      return ANVideoLength.Short;
    case 1:
      return ANVideoLength.Long;
    case 2:
      return ANVideoLength.Auto;
    default:
      if (value == null) {
        return null;
      }
      debugPrint('received unknown value for ANVideoLength ($value)');
      return ANVideoLength.Auto;
  }
}

int videoLengthToInt(ANVideoLength value) {
  switch (value) {
    case ANVideoLength.Short:
    case ANVideoLength.Long:
    case ANVideoLength.Auto:
      return value.index;
    default:
      if (value == null) {
        return null;
      }
      debugPrint('unknown type for ANVideoLength.${value.index}');
      return ANVideoLength.Auto.index;
  }
}

enum ANBannerType {
  Small, // 0, 320x50
  Large, // 1, 320x100
  MediumRectangle // 2, 300x250
}

ANBannerType bannerTypeFrom(int value) {
  switch (value) {
    case 0:
      return ANBannerType.Small;
    case 1:
      return ANBannerType.Large;
    case 2:
      return ANBannerType.MediumRectangle;
    default:
      if (value == null) {
        return null;
      }
      debugPrint('received unknown value for ANBannerType ($value)');
      return ANBannerType.Small;
  }
}

int bannerTypeToInt(ANBannerType value) {
  switch (value) {
    case ANBannerType.Small:
    case ANBannerType.Large:
    case ANBannerType.MediumRectangle:
      return value.index;
    default:
      if (value == null) {
        return null;
      }
      debugPrint('unknown type for ANBannerType.${value.index}');
      return ANBannerType.Small.index;
  }
}

enum ANAnchorPosition {
  none, // 0
  bottomRight, // 1
  bottomLeft, // 2
  bottom, // 3
  topRight, // 4
  topLeft, // 5
  top, // 6
  right, // 7
  left, // 8
  center, // 9
}

ANAnchorPosition anchorPositionFrom(int value) {
  switch (value) {
    case 0:
      return ANAnchorPosition.none;
    case 1:
      return ANAnchorPosition.bottomRight;
    case 2:
      return ANAnchorPosition.bottomLeft;
    case 3:
      return ANAnchorPosition.bottom;
    case 4:
      return ANAnchorPosition.topRight;
    case 5:
      return ANAnchorPosition.topLeft;
    case 6:
      return ANAnchorPosition.top;
    case 7:
      return ANAnchorPosition.right;
    case 8:
      return ANAnchorPosition.left;
    case 9:
      return ANAnchorPosition.center;
    default:
      if (value == null) {
        return null;
      }
      debugPrint('received unknown value for ANAnchorPosition ($value)');
      return ANAnchorPosition.none;
  }
}

int anchorPositionToInt(ANAnchorPosition value) {
  switch (value) {
    case ANAnchorPosition.none:
    case ANAnchorPosition.bottomRight:
    case ANAnchorPosition.bottomLeft:
    case ANAnchorPosition.bottom:
    case ANAnchorPosition.topRight:
    case ANAnchorPosition.topLeft:
    case ANAnchorPosition.top:
    case ANAnchorPosition.right:
    case ANAnchorPosition.left:
    case ANAnchorPosition.center:
      return value.index;
    default:
      if (value == null) {
        return null;
      }
      debugPrint('unknown type for ANAnchorPosition.${value.index}');
      return ANAnchorPosition.none.index;
  }
}

String anchorPositionToString(ANAnchorPosition value) {
  switch (value) {
    case ANAnchorPosition.none:
      return 'none';
    case ANAnchorPosition.bottomRight:
      return 'bottomRight';
    case ANAnchorPosition.bottomLeft:
      return 'bottomLeft';
    case ANAnchorPosition.bottom:
      return 'bottom';
    case ANAnchorPosition.topRight:
      return 'topRight';
    case ANAnchorPosition.topLeft:
      return 'topLeft';
    case ANAnchorPosition.top:
      return 'top';
    case ANAnchorPosition.right:
      return 'right';
    case ANAnchorPosition.left:
      return 'left';
    case ANAnchorPosition.center:
      return 'center';
    default:
      if (value == null) {
        return null;
      }
      debugPrint('unknown type for ANAnchorPosition.${value.index}');
      return 'none';
  }
}

class ANAdData {
  String buttonText;
  String title;
  String desc;
  String urlImg;
  String urlImgWide;
  String categories;
  String idx;
  String iosPackage;
  String supportedDevices;
  String urlVideo;
  String urlVideoHigh;
  String urlVideo30Sec;
  String urlVideo30SecHigh;
  String bannerID;
  String campaignID;
  String country;
  String campaignType;
  String supportedVersion;
  String storeRating;
  String appSize;

  ANAdData.fromMap(Map<dynamic, dynamic> adData) {
    buttonText = adData['buttonText'];
    title = adData['title'];
    desc = adData['desc'];
    urlImg = adData['urlImg'];
    urlImgWide = adData['urlImgWide'];
    categories = adData['categories'];
    idx = adData['idx'];
    iosPackage = adData['iosPackage'];
    supportedDevices = adData['supportedDevices'];
    urlVideo = adData['urlVideo'];
    urlVideoHigh = adData['urlVideoHigh'];
    urlVideo30Sec = adData['urlVideo30Sec'];
    urlVideo30SecHigh = adData['urlVideo30SecHigh'];
    bannerID = adData['bannerID'];
    campaignID = adData['campaignID'];
    country = adData['country'];
    campaignType = adData['campaignType'];
    supportedVersion = adData['supportedVersion'];
    storeRating = adData['storeRating'];
    appSize = adData['appSize'];
  }
}
