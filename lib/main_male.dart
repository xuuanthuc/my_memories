import './../../global/flavor/app_flavor.dart';
import './../../src/app.dart';
import 'initial_app.dart';

void main() {
  AppFlavor.appFlavor = Flavor.male;
  initialApp(() => const MyApp());
}