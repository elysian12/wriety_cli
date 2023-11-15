import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart' as dcli;
import 'package:dcli/dcli.dart';

class UpdateCommand extends Command {
  @override
  String get description => 'Update Wriety Branding';

  @override
  String get name => 'update';

  @override
  Future run() async {
    print('''
${dcli.orange('Please select a brand')}

1) ${dcli.green('Wriety')}
2) ${dcli.green('Dahua')} 
3) ${dcli.green('HikVision')} 
4) ${dcli.green('Epson')} 

''');

    var options = ask('Brand:', required: true, validator: Ask.integer);

    switch (options) {
      case '1':
        SwitchBranding.updateBranding(Brands.wriety);
        break;
      case '2':
        SwitchBranding.updateBranding(Brands.dahua);
        break;
      case '3':
        SwitchBranding.updateBranding(Brands.hikvision);
        break;
      case '4':
        SwitchBranding.updateBranding(Brands.epson);
        break;
      default:
    }

    print('''
# ---------------------------------
# 🚀 Step : 1  Updating ${dcli.orange('Branding File')} 💙 to ${SwitchBranding.getBranding().name}
# ---------------------------------
''');

    //load the branding file
    final branding = File('lib/common/branding.dart').readAsStringSync();

    // 'image_path'

    final updatedbranding = branding.replaceFirst(
        "static const brand = Brands.hikvision",
        'static const brand = Brands.${SwitchBranding.brand.name}');
    final updatedbranding1 = updatedbranding.replaceFirst(
        "static const brand = Brands.wriety",
        'static const brand = Brands.${SwitchBranding.brand.name}');
    final updatedbranding2 = updatedbranding1.replaceFirst(
        "static const brand = Brands.dahua",
        'static const brand = Brands.${SwitchBranding.brand.name}');
    final updatedbranding3 = updatedbranding2.replaceFirst(
        "static const brand = Brands.epson",
        'static const brand = Brands.${SwitchBranding.brand.name}');

    print(updatedbranding3);

    File('lib/common/branding.dart').writeAsStringSync(updatedbranding3);

    print('''
# ---------------------------------
# 🚀 Step : 2  Updating ${dcli.orange('Package Name')} 💙 to ${SwitchBranding.getBranding().packageName}
# ---------------------------------
''');

    final packageresult = await Process.run('flutter', [
      'pub',
      'run',
      'change_app_package_name:main',
      SwitchBranding.getBranding().packageName
    ]);

    print(packageresult.stdout);
    print(packageresult.stderr);

    print('''
# ---------------------------------
# 🚀 Step : 3  Updating ${dcli.orange('Application Name')} 💙 to ${SwitchBranding.getBranding().name}
# ---------------------------------
''');

    final nameresult = await Process.run('flutter', [
      'pub',
      'run',
      'rename_app:main',
      "all=${SwitchBranding.getBranding().name}",
    ]);

    print(nameresult.stdout);
    print(nameresult.stderr);

    print('''
# ---------------------------------
# 🚀 Step : 4  Updating ${dcli.orange('Application LOGO')} 💙 to ${SwitchBranding.getBranding().appLogo}
# ---------------------------------
''');

    //load the pubspec file
    final pubspec = File('pubspec.yaml').readAsStringSync();

    // 'image_path'

    final updatedPubSpec = pubspec.replaceFirst(
        "image_path:", 'image_path: "${SwitchBranding.getBranding().appLogo}"');

    print(updatedPubSpec);

    File('pubspec.yaml').writeAsStringSync(updatedPubSpec);

    final pubGetResult = await Process.run('flutter', ['pub', 'get']);
    print(pubGetResult.stdout);
    print(pubGetResult.stderr);

    final logoresult =
        await Process.run('flutter', ['pub', 'run', 'flutter_launcher_icons']);

    print(logoresult.stdout);
    print(logoresult.stderr);

    print('''
# ---------------------------------
# 🚀 Step : 5  Finishing ${dcli.orange('Pubspec file')} 💙}
# ---------------------------------
''');

    final pubspec1 = File('pubspec.yaml').readAsStringSync();

    final updatedPubSpec1 = pubspec1.replaceFirst(
        'image_path: "${SwitchBranding.getBranding().appLogo}"', "image_path:");

    File('pubspec.yaml').writeAsStringSync(updatedPubSpec1);

    print('''
# ---------------------------------
# 🚀 Step : 6  Made with 💙 ${dcli.orange('Wriety Developers')}}
# ---------------------------------
''');
  }
}

class Branding {
  final String name;
  final String packageName;
  final String appLogo;

  Branding({
    required this.name,
    required this.appLogo,
    required this.packageName,
  });
}

class SwitchBranding {
  static Brands brand = Brands.wriety;

  static updateBranding(Brands value) {
    brand = value;
  }

  static Branding getBranding() {
    switch (brand) {
      case Brands.wriety:
        return Branding(
          name: "Wriety",
          appLogo: "assets/branding/wriety/wriety_app_logo.svg",
          packageName: 'play.wriety',
        );
      case Brands.epson:
        return Branding(
          name: "EPSON",
          appLogo: "assets/branding/epson/Epson-E_logo.svg",
          packageName: 'play.wriety.epson',
        );
      case Brands.dahua:
        return Branding(
          name: "DeepHub",
          appLogo: "assets/branding/dahua/deephub_white.png",
          packageName: 'play.wriety.deephubcanvas',
        );
      case Brands.hikvision:
        return Branding(
          name: "Hikvision",
          appLogo: "assets/branding/hikvision/hikvision_app_logo.png",
          packageName: 'play.wriety.hikvision',
        );
    }
  }
}

enum Brands {
  wriety,
  epson,
  dahua,
  hikvision,
}
