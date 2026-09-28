// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'สแกนเอกสาร';

  @override
  String get resultTitle => 'ผลลัพธ์';

  @override
  String get copyAction => 'คัดลอก';

  @override
  String get shareAction => 'แชร์';

  @override
  String get saveAction => 'บันทึก';

  @override
  String get readyToScan => 'พร้อมสแกน';

  @override
  String get selectLanguageTitle => 'เลือกภาษา';

  @override
  String get searchLanguagesHint => 'ค้นหาภาษา...';

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get adStatusLabel => 'สถานะโฆษณา:';

  @override
  String get adsShownStatus => 'แสดงโฆษณา';

  @override
  String get themeLabel => 'ธีม';

  @override
  String get themeLight => 'สว่าง';

  @override
  String get themeSystem => 'ระบบ';

  @override
  String get themeDark => 'มืด';

  @override
  String get removeAdsButton => 'ลบโฆษณา';

  @override
  String get restorePurchaseButton => 'กู้คืนการซื้อ';

  @override
  String get privacyPolicyLink => 'นโยบายความเป็นส่วนตัว';

  @override
  String get supportLink => 'ความช่วยเหลือ';

  @override
  String get adsRemovedBadge => 'ลบโฆษณาแล้ว';

  @override
  String get semanticsAppIcon => 'ไอคอนแอป Peshat';

  @override
  String get semanticsScanButton => 'ปุ่มสแกนเอกสาร';

  @override
  String get semanticsSearchField => 'ค้นหาภาษา';

  @override
  String get semanticsRemoveAds => 'ลบโฆษณา';

  @override
  String get cameraUsageDescription => 'Peshat ใช้กล้องเพื่อสแกนและแปลข้อความ รูปภาพจะถูกประมวลผลบนอุปกรณ์และไม่ถูกอัปโหลด';

  @override
  String get trackingUsageDescription => 'ใช้เพื่อแสดงโฆษณาที่ไม่ได้ปรับแต่งส่วนบุคคลที่เกี่ยวข้องหากคุณปฏิเสธ; โฆษณาที่ปรับแต่งส่วนบุคคลหากคุณอนุญาต';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'ไม่พบข้อความในภาพ';

  @override
  String get errorImageUnreadable => 'ไม่สามารถอ่านภาพได้';

  @override
  String get errorModelDownloadFailed => 'ไม่สามารถดาวน์โหลดโมเดลการแปลได้';

  @override
  String get errorUnsupportedLanguage => 'ยังไม่รองรับภาษานี้';

  @override
  String get errorOcrFailed => 'การรู้จำข้อความล้มเหลว';

  @override
  String get errorTranslationFailed => 'การแปลล้มเหลว';

  @override
  String get errorTimeout => 'การดำเนินการใช้เวลานานเกินไป';

  @override
  String get errorUnknown => 'เกิดข้อผิดพลาดบางอย่าง';

  @override
  String get statusRecognizing => 'กำลังอ่านข้อความ…';

  @override
  String get statusPreparingModel => 'กำลังเตรียมการแปล…';

  @override
  String get statusTranslating => 'กำลังแปล…';

  @override
  String get sourceLabel => 'ต้นฉบับ';

  @override
  String get translationLabel => 'คำแปล';

  @override
  String get retryButton => 'ลองอีกครั้ง';

  @override
  String get changeLanguageButton => 'เปลี่ยนภาษา';

  @override
  String get historyLabel => 'ประวัติ';

  @override
  String get defaultLanguageLabel => 'ภาษาเป้าหมายเริ่มต้น';

  @override
  String get aboutLabel => 'เกี่ยวกับ';

  @override
  String get licensesLabel => 'สัญญาอนุญาตโอเพนซอร์ส';

  @override
  String get shareAppLabel => 'แชร์แอปนี้';

  @override
  String get versionLabel => 'เวอร์ชัน';
}
