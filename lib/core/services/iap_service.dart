import 'package:in_app_purchase/in_app_purchase.dart';

class IapService {
  static const String proProductId = 'com.zdmgold.peshat.pro';
  final InAppPurchase _iap = InAppPurchase.instance;

  Future<void> buyPro() async {
    final response = await _iap.queryProductDetails({proProductId});
    if (response.productDetails.isEmpty) return;
    
    await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: response.productDetails.first),
    );
  }

  Future<void> restore() async {
    await _iap.restorePurchases();
  }
}
