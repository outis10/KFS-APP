/// Build environment. Each flavor has its own entry point (`lib/main_*.dart`),
/// Android product flavor and `env/<flavor>.json` file.
enum Flavor {
  dev,
  staging,
  prod;

  bool get isProduction => this == Flavor.prod;
}
