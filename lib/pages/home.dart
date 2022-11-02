import 'package:flutter/material.dart';

import '../model/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'metallica', votos: 1),
    Band(id: '2', name: 'linki par', votos: 1),
    Band(id: '3', name: 'nirvana', votos: 1)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bandas'),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i){
          return _bandTile(bands [i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ) {
        print('direccion: $direction');
        print('id: ${band.id}');
        //TODO: llamar el borrado en el server
      },
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
          print(band.name);
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
    print(name);
    if (name.length > 1){
      //podemos agregar
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votos: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
