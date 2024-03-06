import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UiSizes {
  // Height expressions
  static late double height_1;
  static late double height_2;
  static late double height_4;
  static late double height_5;
  static late double height_7;
  static late double height_8;
  static late double height_10;
  static late double height_12;
  static late double height_14;
  static late double height_15;
  static late double height_16;
  static late double height_20;
  static late double height_24_6;
  static late double height_26;
  static late double height_30;
  static late double height_33;
  static late double height_35;
  static late double height_40;
  static late double height_45;
  static late double height_55;
  static late double height_56;
  static late double height_60;
  static late double height_66;
  static late double height_70;
  static late double height_76;
  static late double height_80;
  static late double height_82;
  static late double height_90;
  static late double height_110;
  static late double height_131;
  static late double height_140;
  static late double height_160;
  static late double height_170;
  static late double height_180;
  static late double height_200;
  static late double height_246;
  static late double height_600;
  static late double height_660;
  static late double height_700;
  static late double height_710;
  static late double height_740;
  static late double height_756;
  static late double height_765;
  static late double height_780;

  // Width expressions
  static late double width_1;
  static late double width_1_5;
  static late double width_2;
  static late double width_3;
  static late double width_4;
  static late double width_5;
  static late double width_6;
  static late double width_8;
  static late double width_10;
  static late double width_16;
  static late double width_20;
  static late double width_25;
  static late double width_30;
  static late double width_33;
  static late double width_35;
  static late double width_40;
  static late double width_45;
  static late double width_56;
  static late double width_66;
  static late double width_80;
  static late double width_100;
  static late double width_111;
  static late double width_123_4;
  static late double width_140;
  static late double width_160;
  static late double width_170;
  static late double width_180;
  static late double width_190;
  static late double width_200;
  static late double width_294;
  static late double width_300;
  static late double width_304;
  static late double width_320;

  // Size expressions
  static late double size_8;
  static late double size_12;
  static late double size_13;
  static late double size_14;
  static late double size_15;
  static late double size_16;
  static late double size_17;
  static late double size_18;
  static late double size_19;
  static late double size_20;
  static late double size_21_3;
  static late double size_23;
  static late double size_24;
  static late double size_25;
  static late double size_26;
  static late double size_28;
  static late double size_30;
  static late double size_32;
  static late double size_35;
  static late double size_40;
  static late double size_56;
  static late double size_65;
  static late double size_70;
  static late double size_200;

  static void init(BuildContext context) {
    // Height expressions
    height_1 = MediaQuery.of(context).size.height * 0.0012;
    height_2 = MediaQuery.of(context).size.height * 0.0024;
    height_4 = MediaQuery.of(context).size.height * 0.005;
    height_5 = MediaQuery.of(context).size.height * 0.006;
    height_7 = MediaQuery.of(context).size.height * 0.0085;
    height_8 = MediaQuery.of(context).size.height * 0.0097;
    height_10 = MediaQuery.of(context).size.height * 0.012;
    height_12 = MediaQuery.of(context).size.height * 0.015;
    height_14 = MediaQuery.of(context).size.height * 0.017;
    height_15 = MediaQuery.of(context).size.height * 0.018;
    height_16 = MediaQuery.of(context).size.height * 0.0206888;
    height_20 = MediaQuery.of(context).size.height * 0.024;
    height_24_6 = MediaQuery.of(context).size.height * 0.03;
    height_26 = MediaQuery.of(context).size.height * 0.0316;
    height_30 = MediaQuery.of(context).size.height * 0.036;
    height_33 = MediaQuery.of(context).size.height * 0.04;
    height_35 = MediaQuery.of(context).size.height * 0.0425;
    height_40 = MediaQuery.of(context).size.height * 0.045;
    height_45 = MediaQuery.of(context).size.height * 0.05476;
    height_55 = MediaQuery.of(context).size.height * 0.067;
    height_56 = MediaQuery.of(context).size.height * 0.06815;
    height_60 = MediaQuery.of(context).size.height * 0.073;
    height_66 = MediaQuery.of(context).size.height * 0.08;
    height_70 = MediaQuery.of(context).size.height * 0.085;
    height_76 = MediaQuery.of(context).size.height * 0.0921;
    height_80 = MediaQuery.of(context).size.height * 0.0973;
    height_82 = MediaQuery.of(context).size.height * 0.1;
    height_90 = MediaQuery.of(context).size.height * 0.1095;
    height_110 = MediaQuery.of(context).size.height * 0.133;
    height_131 = MediaQuery.of(context).size.height * 0.16;
    height_140 = MediaQuery.of(context).size.height * 0.17;
    height_160 = MediaQuery.of(context).size.height * 0.1945;
    height_170 = MediaQuery.of(context).size.height * 0.2;
    height_180 = MediaQuery.of(context).size.height * 0.219;
    height_200 = MediaQuery.of(context).size.height * 0.243;
    height_246 = MediaQuery.of(context).size.height * 0.3;
    height_600 = MediaQuery.of(context).size.height * 0.73;
    height_660 = MediaQuery.of(context).size.height * 0.8;
    height_700 = MediaQuery.of(context).size.height * 0.85;
    height_710 = MediaQuery.of(context).size.height * 0.864;
    height_740 = MediaQuery.of(context).size.height * 0.9;
    height_756 = MediaQuery.of(context).size.height * 0.92;
    height_765 = MediaQuery.of(context).size.height * 0.93;
    height_780 = MediaQuery.of(context).size.height * 0.95;

    // Width expressions
    width_1 = 0.0024 * MediaQuery.of(context).size.width;
    width_1_5 = 0.00364 * MediaQuery.of(context).size.width;
    width_2 = 0.00486 * MediaQuery.of(context).size.width;
    width_3 = 0.0072 * MediaQuery.of(context).size.width;
    width_4 = 0.009 * MediaQuery.of(context).size.width;
    width_5 = 0.012 * MediaQuery.of(context).size.width;
    width_6 = 0.015 * MediaQuery.of(context).size.width;
    width_8 = 0.02 * MediaQuery.of(context).size.width;
    width_10 = 0.024 * MediaQuery.of(context).size.width;
    width_16 = 0.04 * MediaQuery.of(context).size.width;
    width_20 = 0.0486 * MediaQuery.of(context).size.width;
    width_25 = 0.0608 * MediaQuery.of(context).size.width;
    width_30 = 0.072 * MediaQuery.of(context).size.width;
    width_33 = 0.08 * MediaQuery.of(context).size.width;
    width_35 = 0.085 * MediaQuery.of(context).size.width;
    width_40 = 0.0972 * MediaQuery.of(context).size.width;
    width_45 = 0.109 * MediaQuery.of(context).size.width;
    width_56 = 0.1361 * MediaQuery.of(context).size.width;
    width_66 = 0.16 * MediaQuery.of(context).size.width;
    width_80 = 0.1944 * MediaQuery.of(context).size.width;
    width_100 = 0.243 * MediaQuery.of(context).size.width;
    width_111 = 0.27 * MediaQuery.of(context).size.width;
    width_123_4 = 0.30 * MediaQuery.of(context).size.width;
    width_140 = 0.34 * MediaQuery.of(context).size.width;
    width_160 = 0.3889 * MediaQuery.of(context).size.width;
    width_170 = 0.413 * MediaQuery.of(context).size.width;
    width_180 = 0.437 * MediaQuery.of(context).size.width;
    width_190 = 0.461 * MediaQuery.of(context).size.width;
    width_200 = 0.486 * MediaQuery.of(context).size.width;
    width_294 = 0.7146 * MediaQuery.of(context).size.width;
    width_300 = 0.729 * MediaQuery.of(context).size.width;
    width_304 = 0.74 * MediaQuery.of(context).size.width;
    width_320 = 0.77783 * MediaQuery.of(context).size.width;

    // Size expressions
    size_8 = 0.009722 * MediaQuery.of(context).size.width +
        0.00486 * MediaQuery.of(context).size.height;
    size_12 = 0.0073 * MediaQuery.of(context).size.height +
        0.01458 * MediaQuery.of(context).size.width;
    size_13 = 0.008 * MediaQuery.of(context).size.height +
        0.015 * MediaQuery.of(context).size.width;
    size_14 = 0.0085 * MediaQuery.of(context).size.height +
        0.017 * MediaQuery.of(context).size.width;
    size_15 = 0.0182 * MediaQuery.of(context).size.width +
        0.009127 * MediaQuery.of(context).size.height;
    size_16 = 0.02187 * MediaQuery.of(context).size.width +
        0.01095 * MediaQuery.of(context).size.height;
    size_17 = 0.01 * MediaQuery.of(context).size.height +
        0.021 * MediaQuery.of(context).size.width;
    size_18 = 0.0109 * MediaQuery.of(context).size.height +
        0.0218 * MediaQuery.of(context).size.width;
    size_19 = 0.024 * MediaQuery.of(context).size.width +
        0.012 * MediaQuery.of(context).size.height;
    size_20 = 0.012 * MediaQuery.of(context).size.height +
        0.024 * MediaQuery.of(context).size.width;
    size_21_3 = 0.013 * MediaQuery.of(context).size.height +
        0.026 * MediaQuery.of(context).size.width;
    size_23 = 0.014 * MediaQuery.of(context).size.height +
        0.029 * MediaQuery.of(context).size.width;
    size_24 = 0.0146 * MediaQuery.of(context).size.height +
        0.029 * MediaQuery.of(context).size.width;
    size_25 = 0.015 * MediaQuery.of(context).size.height +
        0.03 * MediaQuery.of(context).size.width;
    size_26 = 0.0315 * MediaQuery.of(context).size.width +
        0.01582 * MediaQuery.of(context).size.height;
    size_28 = 0.017 * MediaQuery.of(context).size.height +
        0.034 * MediaQuery.of(context).size.width;
    size_30 = 0.01825 * MediaQuery.of(context).size.height +
        0.0364 * MediaQuery.of(context).size.width;
    size_32 = 0.01947 * MediaQuery.of(context).size.height +
        0.03889 * MediaQuery.of(context).size.width;
    size_35 = 0.021 * MediaQuery.of(context).size.height +
        0.0425 * MediaQuery.of(context).size.width;
    size_40 = 0.024 * MediaQuery.of(context).size.height +
        0.048 * MediaQuery.of(context).size.width;

    size_56 = 0.068 * MediaQuery.of(context).size.width +
        0.034 * MediaQuery.of(context).size.height;
    size_65 = 0.0395 * MediaQuery.of(context).size.height +
        0.0789 * MediaQuery.of(context).size.width;
    size_70 = 0.0425 * MediaQuery.of(context).size.height +
        0.085 * MediaQuery.of(context).size.width;
    size_200 = 0.1216 * MediaQuery.of(context).size.height +
        0.243 * MediaQuery.of(context).size.width;
  }
}
