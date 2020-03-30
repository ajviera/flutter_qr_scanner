import 'package:provider/provider.dart' as provider;
import 'package:qr_scanner/src/common/build_context_singleton.dart';
import 'package:qr_scanner/src/providers/app_change_notifier.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';
import 'package:qr_scanner/src/providers/theme_change_notifier.dart';

class ProviderManager {
  static LanguageChangeNotifier languageChangeNotifier() {
    return provider.Provider.of<LanguageChangeNotifier>(
        BuildContextSingleton.context);
  }

  static ThemeChangeNotifier themeChangeNotifier() {
    return provider.Provider.of<ThemeChangeNotifier>(
        BuildContextSingleton.context);
  }

  static AppGeneralNotifier appGeneralNotifier() {
    return provider.Provider.of<AppGeneralNotifier>(
        BuildContextSingleton.context);
  }
}
