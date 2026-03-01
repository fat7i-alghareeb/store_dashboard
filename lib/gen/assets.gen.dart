// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/cart.svg
  String get cart => 'assets/icons/cart.svg';

  /// File path: assets/icons/cart_selected.svg
  String get cartSelected => 'assets/icons/cart_selected.svg';

  /// File path: assets/icons/categories.svg
  String get categories => 'assets/icons/categories.svg';

  /// File path: assets/icons/categories_selected.svg
  String get categoriesSelected => 'assets/icons/categories_selected.svg';

  /// File path: assets/icons/fav.svg
  String get fav => 'assets/icons/fav.svg';

  /// File path: assets/icons/fav_selected.svg
  String get favSelected => 'assets/icons/fav_selected.svg';

  /// File path: assets/icons/home.svg
  String get home => 'assets/icons/home.svg';

  /// File path: assets/icons/home_selected.svg
  String get homeSelected => 'assets/icons/home_selected.svg';

  /// File path: assets/icons/offeres.svg
  String get offeres => 'assets/icons/offeres.svg';

  /// File path: assets/icons/offers_selected.svg
  String get offersSelected => 'assets/icons/offers_selected.svg';

  /// List of all assets
  List<String> get values => [
    cart,
    cartSelected,
    categories,
    categoriesSelected,
    fav,
    favSelected,
    home,
    homeSelected,
    offeres,
    offersSelected,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/IMAGE2025-09-03 20_39_11.jpg
  AssetGenImage get image20250903203911 =>
      const AssetGenImage('assets/images/IMAGE2025-09-03 20_39_11.jpg');

  /// File path: assets/images/evo.png
  AssetGenImage get evo => const AssetGenImage('assets/images/evo.png');

  /// File path: assets/images/kids.png
  AssetGenImage get kids => const AssetGenImage('assets/images/kids.png');

  /// File path: assets/images/mens.png
  AssetGenImage get mens => const AssetGenImage('assets/images/mens.png');

  /// File path: assets/images/menw.png
  AssetGenImage get menw => const AssetGenImage('assets/images/menw.png');

  /// File path: assets/images/or1b.png
  AssetGenImage get or1b => const AssetGenImage('assets/images/or1b.png');

  /// File path: assets/images/or1w.png
  AssetGenImage get or1w => const AssetGenImage('assets/images/or1w.png');

  /// File path: assets/images/origami.png
  AssetGenImage get origami => const AssetGenImage('assets/images/origami.png');

  /// File path: assets/images/rebonLogo.jpg
  AssetGenImage get rebonLogo =>
      const AssetGenImage('assets/images/rebonLogo.jpg');

  /// File path: assets/images/womens.png
  AssetGenImage get womens => const AssetGenImage('assets/images/womens.png');

  /// File path: assets/images/womenw.png
  AssetGenImage get womenw => const AssetGenImage('assets/images/womenw.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    image20250903203911,
    evo,
    kids,
    mens,
    menw,
    or1b,
    or1w,
    origami,
    rebonLogo,
    womens,
    womenw,
  ];
}

class $AssetsL10nGen {
  const $AssetsL10nGen();

  /// File path: assets/l10n/ar.json
  String get ar => 'assets/l10n/ar.json';

  /// File path: assets/l10n/en.json
  String get en => 'assets/l10n/en.json';

  /// List of all assets
  List<String> get values => [ar, en];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsL10nGen l10n = $AssetsL10nGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
