import 'package:app_webview/pages/cookie_page.dart';
import 'package:flutter/material.dart';

import 'cache_page.dart';
import 'events_page.dart';
import 'postmessage_page.dart';
import 'teste_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo WebView'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _showContent(context),
        ),
      ),
    );
  }

  Container _showContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          const Text(
              'Esta demostração visa apresentar as várias maneiras que um aplicativo flutter '
              'pode interagir com uma página web incluída em um WebView.'),
          const SizedBox(height: 20),
          const Text('Incluíndo, lendo e excluíndo cookies em uma página web.'),
          ElevatedButton(
            style: styleButton,
            child: const Text('Cookies'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CookiePage()),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
              'Manipulando o DOM e recebendo informaçõe de uuma página web através de javscript channel.'),
          ElevatedButton(
            style: styleButton,
            child: const Text('Javascript Channel'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PostmessagePage()),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
              'Incluíndo lendo e excluíndo informações em localStorage e sessionStorage na página web.'),
          ElevatedButton(
            style: styleButton,
            child: const Text('Cache Storage'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CachePage()),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
              'Sequência de eventos que acontecem quando uma página é incluída em um webview.'),
          ElevatedButton(
            style: styleButton,
            child: const Text('Events'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventsPage()),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: styleButton,
            child: const Text('Teste'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WebViewExample()),
              );
            },
          ),
        ],
      ),
    );
  }

  static final styleButton = ElevatedButton.styleFrom(
    minimumSize: const Size.fromHeight(50),
  );
}
