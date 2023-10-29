import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchSummonerPage extends StatelessWidget {
  final String data;

  const SearchSummonerPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String summonerName = data;

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.op.gg/summoners/kr/$summonerName'));

    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                title: Image.asset(
                  'assets/images/appbar.png',
                  height: 30,
                  fit: BoxFit.fitHeight,
                ),
                centerTitle: true,
              ),
              body: WebViewWidget(controller: controller),
            )));
  }
}
