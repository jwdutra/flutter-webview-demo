import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/events_controller.dart';

// ignore: must_be_immutable
class CookiePage extends StatelessWidget {
  CookiePage({super.key});

  /// Controlador do webview
  late WebViewController _webViewController;

  /// Controller de cookies
  final _cookieManager = WebViewCookieManager();

  /// Controller de gestão de estado para mostrar os eventos
  final EventsController controller = EventsController();

  /// Url da página onde os cookies serão gerenciados
  final uri = Uri.parse('https://httpbin.org/anything');

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
        AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(controller.cookies),
            );
          },
        )
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
  WebViewWidget _buildWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(uri, method: LoadRequestMethod.get);

    return WebViewWidget(controller: _webViewController);
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

    _webViewController.reload();

    controller.setCookies('Cookies included');
  }

  /// Retorna os cookies registrados na pagina web
  void _getCookies() async {
    await _webViewController
        .runJavaScriptReturningResult('document.cookie')
        .then((value) {
      controller.setCookies(value.toString().isNotEmpty
          ? value.toString()
          : 'No cookies included');
    });
  }

  /// Limpa os cookies registrados na página web
  void _clearCookies() async {
    await _cookieManager.clearCookies();

    _webViewController.reload();

    controller.setCookies('No cookies included');
  }
}
