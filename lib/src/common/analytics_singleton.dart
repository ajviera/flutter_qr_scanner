import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticSingleton {
  static final AnalyticSingleton _singleton = AnalyticSingleton._internal();

  static FirebaseAnalytics analytics;
  static FirebaseAnalyticsObserver observer;

  factory AnalyticSingleton() {
    return _singleton;
  }

  AnalyticSingleton._internal();
}
