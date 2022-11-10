import 'package:band_names/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Server stautus: ${socketProvider.serverStatus}')
        ],
      )),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.message),
              elevation: 1,
              onPressed: () {}),
    );
  }
}
