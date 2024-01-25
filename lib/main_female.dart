import './../../initial_app.dart';
import './../../global/flavor/app_flavor.dart';
import './../../src/app.dart';

void main() {
  AppFlavor.appFlavor = Flavor.female;
  initialApp(() => const MyApp());
}