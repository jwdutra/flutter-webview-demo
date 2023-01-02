import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/events_controller.dart';

// ignore: must_be_immutable
class EventsPage extends StatelessWidget {
  EventsPage({super.key});

  /// Controller de gestão de estado para mostrar os eventos
  final EventsController controller = EventsController();

  /// Eventos que serão mostrados na tela apresentando sua sincronicidade
  var _events = '';

  /// URI da página a ser aberta no webview
  final uri = Uri.parse('https://www.guide.com.br');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
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
        Container(
          height: 130.0,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: const [
              Text('Página Flutter'),
              SizedBox(height: 20.0),
              Text(
                'Sequência dos eventos que acontecem enquanto uma página é incluída no webview ',
              ),
            ],
          ),
        ),
        Container(
          height: 250.0,
          color: Colors.grey.withOpacity(0.5),
          padding: const EdgeInsets.all(20.0),
          child: _buildWebView(),
        ),
        const SizedBox(height: 10.0),
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(_events),
            );
          },
        ),
      ],
    );
  }

  /// Configura e inclui o webview na página e configura os events,
  /// mostrando a sincronicidade de cada evento
  Widget _buildWebView() {
    final webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            _events = "$_events \n - onProgress $progress";
            controller.setEvents(_events);
          },
          onPageStarted: (String url) {
            _events = "$_events \n\n - onPageStarted:\n"
                "Ocorre quando a página web começa a ser carregada.\n";
            controller.setEvents(_events);
          },
          onPageFinished: (String url) {
            _events = "$_events \n\n - onPageFinished:\n"
                "Ocorre quando a página web termina de ser carregada.\n";
            controller.setEvents(_events);
          },
          onWebResourceError: (WebResourceError error) {
            _events = "$_events \n\n - onPageFinished:\n"
                "Ocorre quando acontece algum erro no webview.\n $error 'n";
            controller.setEvents(_events);
          },
        ),
      )
      ..loadRequest(uri, method: LoadRequestMethod.get);

    return WebViewWidget(controller: webViewController);
  }
}
