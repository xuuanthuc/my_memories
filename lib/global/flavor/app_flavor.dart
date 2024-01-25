
enum Flavor {
  female,
  male,
}

class AppFlavor {
  static Flavor appFlavor = Flavor.male;

  static String get baseApi {
    switch (appFlavor) {
      case Flavor.female:
        return 'https://jsonplaceholder.typicode.com';
      case Flavor.male:
        return 'https://jsonplaceholder.typicode.com';
      default:
        return 'https://jsonplaceholder.typicode.com';
    }
  }
}