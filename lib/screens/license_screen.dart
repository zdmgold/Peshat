import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show LicenseRegistry;
import 'package:package_info_plus/package_info_plus.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';

/// Cupertino-native replacement for Material's `showLicensePage`.
///
/// Reads [LicenseRegistry.licenses], groups entries by the first package
/// name each entry references, and renders one card per package. Package
/// versions are not shown: `LicenseEntry` carries no version data, and
/// `PackageInfo` provides only the app's own version, which appears once
/// at the top.
class LicenseScreen extends StatefulWidget {
  const LicenseScreen({super.key});

  @override
  State<LicenseScreen> createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  List<_LicenseGroup>? _groups;
  String _version = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final info = await PackageInfo.fromPlatform();
    final groups = await _collectLicenses();
    if (!mounted) return;
    setState(() {
      _version = '${info.version}+${info.buildNumber}';
      _groups = groups;
    });
  }

  Future<List<_LicenseGroup>> _collectLicenses() async {
    final map = <String, List<String>>{};
    await for (final entry in LicenseRegistry.licenses) {
      final pkg = entry.packages.isNotEmpty ? entry.packages.first : '';
      final list = map.putIfAbsent(pkg, () => <String>[]);
      for (final p in entry.paragraphs) {
        list.add(p.text);
      }
    }
    final groups = map.entries
        .map((e) => _LicenseGroup(
              packageName: e.key,
              paragraphs: e.value,
            ))
        .toList()
      ..sort((a, b) =>
          a.packageName.toLowerCase().compareTo(b.packageName.toLowerCase()));
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          l10n.licensesLabel,
          style: AppTypography.chrome.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: _buildBody(l10n: l10n, isDark: isDark),
      ),
    );
  }

  Widget _buildBody({
    required AppLocalizations l10n,
    required bool isDark,
  }) {
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final border =
        isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final cardBg =
        isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight;

    final groups = _groups;

    if (groups == null) {
      return Center(
        child: CupertinoActivityIndicator(radius: 12, color: accent),
      );
    }

    if (groups.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.doc_text, size: 48, color: textTertiary),
              const SizedBox(height: Spacing.md),
              Text(
                l10n.licenseEmptyLabel,
                textAlign: TextAlign.center,
                style: AppTypography.chrome.copyWith(
                  fontSize: 16,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.md,
      ),
      itemCount: groups.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          if (_version.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: Spacing.lg),
            child: Text(
              '${l10n.versionLabel} $_version',
              style: AppTypography.chrome.copyWith(
                fontSize: 13,
                color: textTertiary,
              ),
            ),
          );
        }

        final g = groups[i - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: Spacing.md),
          child: Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.licensePackageLabel}: ${g.packageName}',
                  style: AppTypography.chrome.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                ...g.paragraphs.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.sm),
                    child: Text(
                      p,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 12,
                        height: 1.4,
                        color: textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LicenseGroup {
  final String packageName;
  final List<String> paragraphs;
  const _LicenseGroup({required this.packageName, required this.paragraphs});
}
