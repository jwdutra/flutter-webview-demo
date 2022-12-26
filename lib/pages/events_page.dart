import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/events_controller.dart';

class EventsPage extends StatefulWidget {
  EventsPage({super.key});

  /// Controller de gestão de estado para mostrar os eventos
  final EventsController controller = EventsController();

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  /// Eventos que serão mostrados na tela apresentando sua sincronicidade
  var events = '';

  /// Controlador do webview
  late WebViewController _webViewController;

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
          height: 130,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: const [
              Text('Página Flutter'),
              SizedBox(height: 20.0),
              Text(
                  'Sequência dos eventos que acontecem enquanto uma página é incluída no webview '),
            ],
          ),
        ),
        Container(
          height: 250,
          color: Colors.grey.withOpacity(0.5),
          padding: const EdgeInsets.all(20.0),
          child: _buildWebView(),
        ),
        const SizedBox(height: 10.0),
        AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(events),
              );
            })
      ],
    );
  }

  /// Configura e inclui o webview na página e configura os events, mostrando a sincronicidade de cada evento
  Widget _buildWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            events = "$events \n - onProgress $progress";
            widget.controller.setEvents(events);
          },
          onPageStarted: (String url) {
            events = "$events \n\n - onPageStarted:\n"
                "Ocorre quando a página web começa a ser carregada.\n";
            widget.controller.setEvents(events);
          },
          onPageFinished: (String url) {
            events = "$events \n\n - onPageFinished:\n"
                "Ocorre quando a página web termina de ser carregada.\n";
            widget.controller.setEvents(events);
          },
          onWebResourceError: (WebResourceError error) {
            events = "$events \n\n - onPageFinished:\n"
                "Ocorre quando acontece algum erro no webview.\n $error 'n";
            widget.controller.setEvents(events);
          },
        ),
      )
      ..loadRequest(uri, method: LoadRequestMethod.get);

    return WebViewWidget(controller: _webViewController);
  }
}
