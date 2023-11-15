import 'package:dcli/dcli.dart';

void askName() {
  var name = ask('name:', required: true, validator: Ask.alpha);
  print('Hello $name');
}
