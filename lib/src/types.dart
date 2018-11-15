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
      print('received unknown value for ANPreferredOrientation ($value)');
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
      } else {
        print('unknown type ANPreferredOrientation.${value.index}');
      }
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
      print('received unknown value for ANCreativeType ($value)');
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
      print('unknown type for ANCreativeType.${value.index}');
      return -1;
  }
}
