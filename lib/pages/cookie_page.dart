import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CookiePage extends StatefulWidget {
  const CookiePage({super.key});

  @override
  State<CookiePage> createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {
  /// Controlador do webview
  late WebViewController _webViewController;

  /// Controller de cookies
  final _cookieManager = CookieManager();

  /// Dados do cookie a ser recebido  em [_getCookies]
  var cookies = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookies'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _showContent(),
        ),
      ),
    );
  }

  /// Mostra o conteúdio da página
  Widget _showContent() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child:
              Text('Incluíndo, lendo e excluíndo cookies em uma página web.'),
        ),
        SizedBox(
          height: 140.0,
          width: double.infinity,
          child: _buttons(),
        ),
        Container(
          height: 200.0,
          color: Colors.grey.withOpacity(0.5),
          padding: const EdgeInsets.all(20.0),
          child: _buildWebView(),
        ),
        const SizedBox(height: 30.0),
        const Text('Cookies:'),
        const SizedBox(height: 30.0),
        Text(
          cookies,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Botões de ação da página acionando os métodos [_getCookies], [_setCookies] e [_clearCookies]
  Widget _buttons() {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        Wrap(
          spacing: 20.0,
          children: [
            ElevatedButton(
              child: const Text('Set Cookies'),
              onPressed: () {
                _setCookies();
              },
            ),
            ElevatedButton(
              child: const Text('Get Cookies'),
              onPressed: () {
                _getCookies();
              },
            ),
            ElevatedButton(
              child: const Text('Clear Cookies'),
              onPressed: () {
                _clearCookies();
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Configura e inclui o webview na página
  Widget _buildWebView() {
    return WebView(
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) async {
        _webViewController = webViewController;
        String fileContent =
            await rootBundle.loadString('assets/html/blank.html');
        _webViewController.loadUrl(
          Uri.dataFromString(
            fileContent,
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'),
          ).toString(),
        );
      },
    );
  }

  /// Inclui ciookies na página web
  Future<void> _setCookies() async {
    await _cookieManager.clearCookies();

    await _cookieManager.setCookie(
      const WebViewCookie(
          name: 'cookie_test_1',
          value: 'value_cookie_1',
          domain: 'httpbin.org',
          path: '/anything'),
    );
    await _cookieManager.setCookie(
      const WebViewCookie(
          name: 'cookie_test_2',
          value: 'value_cookie_2',
          domain: 'httpbin.org',
          path: '/anything'),
    );

    await _webViewController.loadUrl('https://httpbin.org/anything');

    setState(() {
      cookies = 'Cookies included';
    });
  }

  /// Retorna os cookies registrados na pagina web
  void _getCookies() async {
    await _webViewController
        .runJavascriptReturningResult('document.cookie')
        .then((value) {
      setState(() {
        cookies = value.isNotEmpty ? value : 'No cookies included';
      });
    });
  }

  /// Limpa os cookies registrados na página web
  void _clearCookies() async {
    await _cookieManager.clearCookies();

    await _webViewController.loadUrl('https://httpbin.org/anything');

    setState(() {
      cookies = 'No cookies included';
    });
  }
}
