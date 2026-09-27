import 'package:in_app_purchase/in_app_purchase.dart';

class IapService {
  static const String removeAdsProductId = 'com.zdmgold.peshat.removeads';
  final InAppPurchase _iap = InAppPurchase.instance;

  Future<void> buyRemoveAds() async {
    final response = await _iap.queryProductDetails({removeAdsProductId});
    if (response.productDetails.isEmpty) return;
    await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: response.productDetails.first),
    );
  }

  Future<void> restore() async {
    await _iap.restorePurchases();
  }
}
