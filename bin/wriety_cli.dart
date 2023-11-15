import 'package:args/command_runner.dart';
import 'package:wriety_cli/update_command.dart';

void main(List<String> args) async {
  final runner = CommandRunner('wriety_cli', ' create wriety branding')
    ..addCommand(
      UpdateCommand(),
    );

  await runner.run(args);
}
