import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  /// Eventos que serão mostrados na tela apresentando sua sincronicidade
  var events = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(), //_showContent(),
        ),
      ),
    );
  }

/*
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(events),
        ),
      ],
    );
  }

  /// Configura e inclui o webview na página e configura os events, mostrando a sincronicidade de cada evento
  Widget _buildWebView() {
    return WebView(
      initialUrl: 'https://www.guide.com.br',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) async {
        events = '';

        setState(() {
          events = " - onWebViewCreated:\n"
              "Ocorre quando o webview é instanciado e fica pronto para receber uma página web.\n";
        });
      },
      onPageStarted: (url) {
        setState(() {
          events = "$events \n\n - onPageStarted:\n"
              "Ocorre a página web começa a ser carregada.\n";
        });
      },
      onProgress: (progress) {
        setState(() {
          events = "$events \n - onProgress $progress";
        });
      },
      onPageFinished: (url) {
        setState(() {
          events = "$events \n\n - onPageFinished:\n"
              "Ocorre a página web termina de ser carregada.\n";
        });
      },
      onWebResourceError: (error) {
        inspect(error);
      },
    );
  }
  */
}
