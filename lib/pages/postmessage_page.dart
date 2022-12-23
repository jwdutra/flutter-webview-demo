import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PostmessagePage extends StatefulWidget {
  const PostmessagePage({super.key});

  @override
  State<PostmessagePage> createState() => _PostmessagePageState();
}

class _PostmessagePageState extends State<PostmessagePage> {
  /// Controlador do webview
  late WebViewController _webViewController;

// Mensagem de retorno recebida pelo javascripr channel
  var mensagemRetorno = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Javascript Channel'),
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
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text('Página Flutter'),
              const SizedBox(height: 20.0),
              Text('Mensagem recebida da WebView = $mensagemRetorno'),
              const SizedBox(height: 20.0),
              const Text(
                  'Ao ligar ou desligar o Switch na página web, uma mensagem do estado do switch é enviada '
                  'ao app e mostrada, e imediatamente, esta mesma mensagem é enviada à web manipulando o DOM e '
                  'mostrando a mesma mensagem.'),
            ],
          ),
        ),
        Container(
          height: 300,
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
    return WebView(
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) async {
        _webViewController = webViewController;
        String fileContent =
            await rootBundle.loadString('assets/html/postmessage.html');
        _webViewController.loadUrl(
          Uri.dataFromString(
            fileContent,
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'),
          ).toString(),
        );
      },
      javascriptChannels: <JavascriptChannel>{
        JavascriptChannel(
          name: 'messageHandler',

          /// Nome do canal
          onMessageReceived: (JavascriptMessage message) {
            /// Recebe e mostra mensagen vinda da web através do canal
            setState(() {
              mensagemRetorno = message.message;
            });

            /// Retorna a mensagem recebida pelo canal à web via javascript manipulando o DOM para ser mostrada
            final script =
                "document.getElementById('switch-value').innerText=\"${message.message}\"";
            _webViewController.runJavascript(script);
          },
        )
      },
    );
  }
  */
}
