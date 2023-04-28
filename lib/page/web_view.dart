import 'package:flutter/src/widgets/framework.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends BaseUiPage {
  String url;

  WebViewPage({required super.title, required this.url});

  late WebViewController _webViewController;

  void _initWebViewController() {
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();
    _webViewController = WebViewController.fromPlatformCreationParams(params);
    _webViewController.loadRequest(Uri.parse(url));
  }

  @override
  Widget createBody(BuildContext context) {
    _initWebViewController();
    return WebViewWidget(controller: _webViewController);
  }

  @override
  initController() => NullController();
}
