import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/events_controller.dart';

// ignore: must_be_immutable
class CachePage extends StatelessWidget {
  CachePage({super.key});

  /// Controlador do webview
  late WebViewController _webViewController;

  /// Controller de gestão de estado para mostrar os eventos
  final EventsController controller = EventsController();

  /// Uri da página onde os cookies serão gerenciados
  final uri = Uri.parse('https://httpbin.org/forms/post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cache Storage'),
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
          child: Text(
              'Incluíndo lendo e excluíndo informações em localStorage e sessionStorage na página web.'),
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
        const Text('Storage:'),
        const SizedBox(height: 30.0),
        AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(controller.storages),
            );
          },
        )
      ],
    );
  }

  /// Botões de ação da página acionando os métodos [_setCache] e [_clearCache]
  Widget _buttons() {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        Wrap(
          spacing: 20.0,
          children: [
            ElevatedButton(
              child: const Text('Add Cache Storage'),
              onPressed: () {
                _setCache();
              },
            ),
            ElevatedButton(
              child: const Text('Clear Cache Storage'),
              onPressed: () {
                _clearCache();
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Configura e inclui o webview na página
  Widget _buildWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'messageHandler',
        onMessageReceived: (JavaScriptMessage message) {
          controller.setStorage(
              message.message != '{}' ? message.message : 'No cache included');
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            await _preparePage();
          },
        ),
      )
      ..loadRequest(uri, method: LoadRequestMethod.get);

    return WebViewWidget(controller: _webViewController);
  }

  /// Prepara a página web para receber os testes
  Future<void> _preparePage() async {
    await _webViewController.runJavaScript('''
              document.getElementsByTagName('body')[0].innerHTML = '<h1 id="teste">Teste</h1>';
            ''');
  }

  /// Adicina dados em sessionStorage e localStorage na página web
  Future<void> _setCache() async {
    await _webViewController.runJavaScript(
      '''
        sessionStorage.setItem("key_1", "session cache 1"); 
        sessionStorage.setItem("key_2", "session cache 2");
        localStorage.setItem("key_3", "persistent cache 3");  
        localStorage.setItem("key_4", "persistent cache 4");

        var storage = {};
        Object.keys(sessionStorage).forEach((key) => {
          storage[key] = sessionStorage.getItem(key);
        });
        Object.keys(localStorage).forEach((key) => {
          storage[key] = localStorage[key];
        });
        document.getElementById('teste').innerHTML = JSON.stringify(storage);
        messageHandler.postMessage(JSON.stringify(storage));
      ''',
    );
  }

  /// Limpa os dados do cache storage da página web.
  void _clearCache() async {
    await _webViewController.clearCache();
    await _webViewController.clearLocalStorage();

    await _webViewController.runJavaScript(
      '''
         sessionStorage.clear();
         document.getElementById('teste').innerHTML = '';

       ''',
    );
    controller.setStorage('No Cache included');
  }
}
