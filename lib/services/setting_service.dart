import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:lol_friend/widgets/info_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingService {
  void sendEmail(BuildContext context) async {
    print('SENDEMAIL');
    String body = await _getEmailBody();

    final Email email = Email(
      body: body,
      subject: '[LOL.fr APP 제보 및 문의]',
      recipients: ['21900215@handong.ac.kr'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      const InfoDialog();
    }
  }

  Future<String> _getEmailBody() async {
    Map<String, dynamic> appInfo = await _getAppInfo();
    Map<String, dynamic> deviceInfo = await _getDeviceInfo();

    String body = '';

    body += "\n\n";
    body += "==================\n";
    body += "아래 내용을 함께 보내주시면 큰 도움이 됩니다 ☺️\n";

    appInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    deviceInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    body += "==================\n";

    return body;
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } catch (e) {
      print(e);
      deviceData = {"ERROR": "플랫폼 버전을 불러오는데 실패했습니다."};
    }

    return deviceData;
  }

  Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
    var release = info.version.release;
    var sdkInt = info.version.sdkInt;
    var manufacturer = info.manufacturer;
    var model = info.model;

    return {
      "OS 버전": "Android $release (SDK $sdkInt)",
      "기기": "$manufacturer $model"
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
    var systemName = info.systemName;
    var version = info.systemVersion;
    var machine = info.utsname.machine.iOSProductName;

    return {"OS 버전": "$systemName $version", "기기": machine};
  }

  Future<Map<String, dynamic>> _getAppInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    return {"LOL.fr Version": info.version};
  }
}
