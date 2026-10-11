import 'package:in_app_purchase/in_app_purchase.dart';

class IapService {
  static const String removeAdsProductId = 'com.zdmgold.peshat.removeads';
  final InAppPurchase _iap = InAppPurchase.instance;

  /// Returns true when the store purchase sheet was started, false when the
  /// store or product is unavailable (so the caller can tell the user).
  Future<bool> buyRemoveAds() async {
    try {
      if (!await _iap.isAvailable()) return false;
      final response = await _iap.queryProductDetails({removeAdsProductId});
      if (response.error != null || response.productDetails.isEmpty) {
        return false;
      }
      return await _iap.buyNonConsumable(
        purchaseParam:
            PurchaseParam(productDetails: response.productDetails.first),
      );
    } catch (_) {
      return false;
    }
  }

  /// Returns true when a restore request was sent to the store.
  Future<bool> restore() async {
    try {
      if (!await _iap.isAvailable()) return false;
      await _iap.restorePurchases();
      return true;
    } catch (_) {
      return false;
    }
  }
}
