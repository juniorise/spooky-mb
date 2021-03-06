import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/types/sound_type.dart';

part 'sound_model.g.dart';

class WeatherImageModel {
  final String url;
  final String src;
  WeatherImageModel({
    required this.src,
    required this.url,
  });
}

@JsonSerializable()
class SoundModel {
  SoundModel({
    required this.type,
    required this.soundName,
    required this.fileName,
    required this.fileSize,
    required this.weatherType,
  });

  final SoundType type;
  final String soundName;
  final String fileName;
  final int fileSize;
  final WeatherType weatherType;

  WeatherImageModel get imageUrl {
    switch (weatherType) {
      case WeatherType.heavyRainy:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/4KKVELjJsNw",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647890323/william-zhang-4KKVELjJsNw-unsplash_1-min_xgid9c.jpg",
        );
      case WeatherType.heavySnow:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/Oaec-W0b2ss",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647885863/christian-spuller-Oaec-W0b2ss-unsplash-min_icm1o9.jpg",
        );
      case WeatherType.middleSnow:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/EPgGW0EMshY",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647885913/simon-berger-EPgGW0EMshY-unsplash-min_vbozsx.jpg",
        );
      case WeatherType.thunder:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/iecFSEsQiqY",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647890539/les-argonautes-iecFSEsQiqY-unsplash_1-min_mx8xu9.jpg",
        );
      case WeatherType.lightRainy:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/2QS7wbeRe3c",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647886602/sean-mcauliffe-2QS7wbeRe3c-unsplash-min_1_n3tl10.jpg",
        );
      case WeatherType.lightSnow:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/g8oPS-OSviE",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647890480/barbara-kosulin-g8oPS-OSviE-unsplash_1-min_wvn2bt.jpg",
        );
      case WeatherType.sunnyNight:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/HyYpd6WRrCE",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647890079/jose-mizrahi-HyYpd6WRrCE-unsplash-min_ncdpcs_1-min_thrkbb.jpg",
        );
      case WeatherType.sunny:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/ns5Valsrpho",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647886988/maria-oswalt-ns5Valsrpho-unsplash-min_xsra08.jpg",
        );
      case WeatherType.cloudy:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/gnxb59lGU1M",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647887169/jelleke-vanooteghem-gnxb59lGU1M-unsplash-min_wq3ski.jpg",
        );
      case WeatherType.cloudyNight:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/h_gwdi8UH2o",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647890380/zoltan-tasi-h_gwdi8UH2o-unsplash_1-min_depja2.jpg",
        );
      case WeatherType.middleRainy:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/qPcoYUEw1Jk",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647890215/mehmet-ali-turan-qPcoYUEw1Jk-unsplash_1-min_gcbtsw.jpg",
        );
      case WeatherType.overcast:
      case WeatherType.hazy:
      case WeatherType.foggy:
      case WeatherType.dusty:
        return WeatherImageModel(
          src: "https://unsplash.com/photos/JJ0Kuh9_Y6g",
          url:
              "https://res.cloudinary.com/juniorise/image/upload/v1647887435/despo-potamou-JJ0Kuh9_Y6g-unsplash-min_k6n8hy.jpg",
        );
    }
  }

  Map<String, dynamic> toJson() => _$SoundModelToJson(this);
  factory SoundModel.fromJson(Map<String, dynamic> json) => _$SoundModelFromJson(json);
}
