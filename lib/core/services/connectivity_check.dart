import 'dart:async';
import 'dart:io';

/// Quick "can this phone reach the internet right now" check.
/// A DNS lookup with a short limit; no extra package or permission needed.
/// It proves reachability, not speed.
Future<bool> hasInternet() async {
  try {
    final r = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 3));
    return r.isNotEmpty && r.first.rawAddress.isNotEmpty;
  } on SocketException {
    return false;
  } on TimeoutException {
    return false;
  } catch (_) {
    return false;
  }
}
