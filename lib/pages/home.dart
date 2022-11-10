import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:band_names/model/band.dart';
import 'package:band_names/providers/socket_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    // TODO: implement initState
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.socket?.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload){
    this.bands = (payload as List)
        .map((band) => Band.fromMap(band))
        .toList();
    setState((){});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.socket?.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bandas',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 10),
              child: (socketProvider.serverStatus == ServerStatus.Online)
                  ? Icon(Icons.check_circle, color: Colors.blue[300])
                  : Icon(Icons.offline_bolt, color: Colors.red[300]),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _shoGraph(),
          Expanded(
              child: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, i) => _bandTile(bands[i]),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketProvider.socket?.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle( color: Colors.white)),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votos}',
        style: TextStyle(fontSize: 20),),
        onTap: (){
          socketProvider.socket?.emit('vote-band', {'id': band.id});
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(''),
            content: TextField(controller: textController,),
            actions: <Widget>[
              MaterialButton(
                child: Text('add'),
                onPressed: () => addBandTolist(textController.text),
                elevation: 5,
              )
            ],
          );
        });
  }

  void addBandTolist(String name){
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    print(name);
    if (name.length > 1){
     socketProvider.socket?.emit('add-band', {'name':name});
    }
    Navigator.pop(context);
  }

  _shoGraph(){
    Map<String, double> dataMapVacio = {
      "no-votes": 1,
    };
    Map<String, double> dataMap = new Map();
    bands.forEach((element) {
      this.bands.isNotEmpty
          ? dataMap.putIfAbsent(element.name, () => element.votos.toDouble())
          : null;
    });
    if(this.bands.length == 0){
      return PieChart(dataMap: dataMapVacio);
    }else{
      return Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        height: 250,
        child: PieChart(
            dataMap: dataMap,
          chartType: ChartType.ring,
          chartValuesOptions: ChartValuesOptions(
            decimalPlaces: 0
          ),
        ),
      );
    }
  }
}
