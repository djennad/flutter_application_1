import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/newpage.dart';
import 'dart:math';
//import firebase firrestore
//comit

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'djennad mohamed sadek',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'djennad mohamed sadek'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController txt = TextEditingController();
  late Stream<QuerySnapshot> _streamm;
  String userUID = "noone";
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();

    _streamm = FirebaseFirestore.instance.collection('listofusers').snapshots();
  }

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() async {
                    await signIn();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => newpage(),
                      ),
                    );
                  });
                },
                child: Text(userUID),
              ),
            ],
          ),
          Expanded(
            flex: 5,
            child: ddf(),
            // child: Container(
            //   alignment: Alignment.center,
            //   child: Text("container1"),
            //   color: Color.fromARGB(99, 68, 49, 88),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              controller: txt,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _streamm = FirebaseFirestore.instance
                            .collection('items')
                            .where('name', isGreaterThanOrEqualTo: txt.text)
                            .where('name',
                                isLessThanOrEqualTo: txt.text + '\uf8ff')
                            .snapshots();
                      });
                    },
                    child: Text("search")),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: _showAddDialog,
                  child: Text("add data"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _streamm = FirebaseFirestore.instance
                          .collection("items")
                          .snapshots();
                    });
                  },
                  child: Text("show all data"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> ddf() {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('listofusers').snapshots(),
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
                      IconButton(onPressed: () {}, icon: Icon(Icons.update)),
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
        });
  }

// Function to sign in anonymously and update variables

  Future<void> signIn() async {
    // Check if a user is already signed in
    if (FirebaseAuth.instance.currentUser != null) {
      userUID = FirebaseAuth.instance.currentUser!.uid;
      isSignedIn = true; // Update sign-in status
    } else {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      userUID = userCredential.user!.uid; // Store UID in a variable
      isSignedIn = true; // Update sign-in status
      await adduser();
    }
  }

  Future<void> adduser() async {
    await FirebaseFirestore.instance.collection('listofusers').add(
      {
        'user': userUID,
        'isonline': isSignedIn,
      },
    );
  }

  // Call this function when you want to check the sign-in status

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: TextField(
            controller: txt,
            decoration: InputDecoration(hintText: 'Enter item name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final itemName = txt.text;
                FirebaseFirestore.instance
                    .collection('items')
                    .add({'name': itemName});
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
