import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(new PrimaApp());

class PrimaApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Prima App",
      home: new MyContent(),
    );
  }
  
}

class MyContent extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _MyContentState();
  }
}

class _MyContentState extends State<MyContent> {
  String appbarText = "Prima App";
  String myText = "Prima App";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.appbarText),
        backgroundColor: Colors.blue,
      ),
      body: new CryptoList(),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () {
            Firestore.instance.collection('cryptos').document()
                .setData({ 'name': 'bitcoin', 'valueineuro': 8742 });
          }
      ),
    );
  }
}

class CryptoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('cryptos').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['name']),
                  subtitle: new Text(document['valueineuro'].toString()),
                );
              }).toList(),
            );
        }
      },
    );
  }
}