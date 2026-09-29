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

  @override
  String get historyEmpty => 'ยังไม่มีการสแกน';

  @override
  String get historyClearConfirm => 'ลบประวัติทั้งหมดหรือไม่';

  @override
  String get termsLink => 'ข้อกำหนดการให้บริการ';

  @override
  String get tagline => 'หันกล้องไปที่ข้อความใด ๆ แล้วเข้าใจได้ทันที';

  @override
  String get noResults => 'ไม่พบผลลัพธ์';

  @override
  String get copiedMessage => 'คัดลอกไปยังคลิปบอร์ดแล้ว';

  @override
  String get exportTxtAction => 'ส่งออกเป็นข้อความ';

  @override
  String get exportPdfAction => 'ส่งออกเป็น PDF';

  @override
  String get translatedTo => 'แปลเป็น';

  @override
  String get translateToLabel => 'แปลเป็น';

  @override
  String get typeTextLabel => 'พิมพ์หรือวางข้อความ';

  @override
  String get importFileLabel => 'นำเข้าไฟล์';

  @override
  String get recentScansLabel => 'การสแกนล่าสุด';

  @override
  String get seeAllLabel => 'ดูทั้งหมด';

  @override
  String get uiLanguageLabel => 'ภาษาของแอป';

  @override
  String get historyToday => 'วันนี้';

  @override
  String get historyYesterday => 'เมื่อวาน';

  @override
  String get historyOlder => 'เก่ากว่า';

  @override
  String get typeTextButtonLabel => 'พิมพ์ข้อความ';

  @override
  String get removeAdsSubtitle => 'ซื้อครั้งเดียว';

  @override
  String get removeAdsShortLabel => 'ลบ';

  @override
  String get charactersLabel => 'ตัวอักษร';

  @override
  String get clearHistoryLabel => 'ล้างประวัติทั้งหมด';

  @override
  String get cameraLabel => 'กล้อง';

  @override
  String get recentLanguagesLabel => 'ล่าสุด';

  @override
  String get allLanguagesLabel => 'ทุกภาษา';

  @override
  String get noResultsSubtitle => 'ลองสะกดแบบอื่น';

  @override
  String get sectionSystemLabel => 'ระบบ';

  @override
  String get appLanguageLabel => 'ภาษาของแอป';

  @override
  String get clearTextConfirm => 'ล้างข้อความหรือไม่';

  @override
  String get historyEmptySubtitle => 'การสแกนที่คุณแปลจะแสดงที่นี่';

  @override
  String get cancelButtonLabel => 'ยกเลิก';

  @override
  String get okButtonLabel => 'ตกลง';

  @override
  String get closeButtonTooltip => 'ปิด';

  @override
  String get showMenuTooltip => 'แสดงเมนู';

  @override
  String get licensePackageLabel => 'แพ็กเกจ';

  @override
  String get licenseEmptyLabel => 'ไม่มีข้อมูลใบอนุญาต';
}
