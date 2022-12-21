import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CachePage extends StatefulWidget {
  const CachePage({super.key});

  @override
  State<CachePage> createState() => _CachePageState();
}

class _CachePageState extends State<CachePage> {
  /// Controlador do webview
  late WebViewController _webViewController;

  /// Dados do storage a ser recebido por um canal javascript configurado em [_buildWebView]
  var _storage = '';

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
          height: 140,
          width: double.infinity,
          child: _buttons(),
        ),
        Container(
          height: 200,
          color: Colors.grey.withOpacity(0.5),
          padding: const EdgeInsets.all(20.0),
          child: _buildWebView(),
        ),
        const SizedBox(height: 30.0),
        const Text('Storage:'),
        const SizedBox(height: 30.0),
        Text(
          _storage,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Botões de ação da página acionando os métodos [_getCache], [_setCache] e [_clearCache]
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
              child: const Text('Get Cache Storage'),
              onPressed: () {
                _getCache();
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
    return WebView(
      initialUrl: 'https://httpbin.org/forms/post',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) async {
        _webViewController = webViewController;
      },
      javascriptChannels: <JavascriptChannel>{
        JavascriptChannel(
          name: 'messageHandler', // Nome do canal
          onMessageReceived: (JavascriptMessage message) {
            setState(() {
              _storage = message.message != '{}'
                  ? message.message
                  : 'No cache included';
            });
          },
        )
      },
    );
  }

  /// Adicina dados em sessionStorage e localStorage na página web
  Future<void> _setCache() async {
    await _webViewController.runJavascript(
      '''
        sessionStorage.setItem("key_1", "session cache 1"); 
        sessionStorage.setItem("key_2", "session cache 2");
        localStorage.setItem("key_3", "persistent cache 1");  
        localStorage.setItem("key_4", "persistent cache 2");
      ''',
    );
    setState(() {
      _storage = 'Cache included';
    });
  }

  /// lê informações do cache storage da página web e retorna para o app em um javascripr channel
  void _getCache() async {
    await _webViewController.runJavascript('''
        var storage = {};
        Object.keys(sessionStorage).forEach((key) => {
          storage[key] = sessionStorage.getItem(key);
        });
        Object.keys(localStorage).forEach((key) => {
          storage[key] = localStorage[key];
        });
        messageHandler.postMessage(JSON.stringify(storage));
      ''');
  }

  /// Limpa os dados do cache storage da página web.
  void _clearCache() async {
    await _webViewController.runJavascript(
      '''
        sessionStorage.clear(); 
        localStorage.clear();  
      ''',
    );
    _getCache();
  }
}
