import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/main.dart';

class newpage extends StatefulWidget {
  const newpage({
    super.key,
  });

  @override
  State<newpage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<newpage> {
  late Stream<QuerySnapshot> _stream;
  bool iscliked = false;
  String selecteduser = "uid2";
  TextEditingController edit1 = TextEditingController();
  String currentuser = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> getmessages(String uid1, String uid2) {
    List<String> ids = [uid1, uid2];
    ids.sort();
    String chatromid = ids.join("_");
    return FirebaseFirestore.instance
        .collection('chatroms')
        .doc(chatromid)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  void initState() {
    super.initState();
    selecteduser = "uid2";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('hi'),

        actions: <Widget>[
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MyApp()),
                  (route) => false,
                );
              },
              icon: Icon(Icons.door_back_door))
        ],
      ),
      drawer: Drawer(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('listofusers')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(); // Show loading indicator
              }

              final items = snapshot.data!.docs; // List of documents

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final itemData = items[index].data() as Map<String, dynamic>;
                  final itemName = itemData['user'];
                  DocumentSnapshot docu = snapshot.data!.docs[index];
                  return Expanded(
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(itemName),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  iscliked = true;
                                  selecteduser = itemName;
                                });
                              },
                              icon: Icon(Icons.message)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('items')
                                .doc(docu.id)
                                .delete();
                            print('Item deleted successfully');
                          } catch (e) {
                            print('Error deleting item: $e');
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot>(
                stream: getmessages(selecteduser, currentuser),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(); // Show loading indicator
                  }
                  if (iscliked && selecteduser != null) {
                    final items = snapshot.data!.docs; // List of documents

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final itemData =
                            items[index].data() as Map<String, dynamic>;
                        final itemName = itemData['messageText'];
                        DocumentSnapshot docu = snapshot.data!.docs[index];
                        return Expanded(
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(itemName),
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.update)),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('items')
                                      .doc(docu.id)
                                      .delete();
                                  print('Item deleted successfully');
                                } catch (e) {
                                  print('Error deleting item: $e');
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else
                    return Text('noclik');
                }),
          ),
          Spacer(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: edit1,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      List<String> ids = [selecteduser, currentuser];
                      ids.sort();
                      String chatromid = ids.join("_");
                      FirebaseFirestore.instance
                          .collection('chatroms')
                          .doc(chatromid)
                          .collection('messages')
                          .add({
                        'messageText': edit1.text,
                        'timestamp': Timestamp.now().microsecondsSinceEpoch
                      });
                    },
                    icon: Icon(Icons.send),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
