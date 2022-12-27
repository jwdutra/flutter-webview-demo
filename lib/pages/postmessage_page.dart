import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/events_controller.dart';

// ignore: must_be_immutable
class PostmessagePage extends StatelessWidget {
  PostmessagePage({super.key});

  /// Controlador do webview
  late WebViewController _webViewController;

  /// Controller de gestão de estado para mostrar os eventos
  final EventsController controller = EventsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Javascript Channel'),
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
          height: 200.0,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text('Página Flutter'),
              const SizedBox(height: 20.0),
              AnimatedBuilder(
                animation: controller,
                builder: (_, __) {
                  return Text(
                    'Mensagem recebida da WebView = ${controller.messages}',
                  );
                },
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Ao ligar ou desligar o Switch na página web, uma mensagem do estado do switch é enviada '
                'ao app e mostrada, e imediatamente, esta mesma mensagem é enviada à web manipulando o DOM e '
                'mostrando a mesma mensagem.',
              ),
            ],
          ),
        ),
        Container(
          height: 300.0,
          color: Colors.grey.withOpacity(0.5),
          padding: const EdgeInsets.all(20.0),
          child: _buildWebView(),
        ),
      ],
    );
  }

  /// Configura e inclui o webview na página e configura o canal de comunicação entre a
  /// página web e o aplicativo
  Widget _buildWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'messageHandler',
        onMessageReceived: (JavaScriptMessage message) {
          /// Recebe e mostra mensagen vinda da web através do canal
          controller.setMessage(message.message);

          /// Retorna a mensagem recebida pelo canal à web via javascript manipulando o DOM para ser mostrada
          final script =
              "document.getElementById('switch-value').innerText=\"${message.message}\"";
          _webViewController.runJavaScript(script);
        },
      )
      ..loadFlutterAsset('assets/html/postmessage.html');

    return WebViewWidget(controller: _webViewController);
  }
}
