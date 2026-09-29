/// Peshat's app-level theme preference. Mirrors the three states the
/// user can pick in Settings. Replaces Flutter's Material `ThemeMode`,
/// which lives in Flutter's Material library and pulls the whole
/// Material package into any file that references it.
enum AppThemeMode { light, system, dark }
