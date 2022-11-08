import 'dart:io';
import 'package:flutter/material.dart';
import 'package:persistence/helpers/database_helper.dart';
import 'package:persistence/models/cat_model.dart';
import 'package:persistence/screens/taken_picture_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class HomeScreen extends StatefulWidget {
  final CameraDescription passCamara;
  final String imgapath;
  const HomeScreen({Key? key, required this.passCamara, required this.imgapath})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? catid;
  final textControllerRace = TextEditingController();
  final textControllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite Example"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            TextFormField(
                controller: textControllerRace,
                decoration: const InputDecoration(
                    icon: Icon(Icons.view_comfortable),
                    labelText: "Input the race of the cat")),
            TextFormField(
                controller: textControllerName,
                decoration: const InputDecoration(
                    icon: Icon(Icons.text_format_outlined),
                    labelText: "Input the cat name")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 137, 69, 146)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TakenPictureScreen(camera: widget.passCamara)));
                },
                child: const Text("Take a picture")),
            Center(
              child: (FutureBuilder<List<Cat>>(
                future: DatabaseHelper.instance.getCats(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Cat>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: const Text("Loading..."),
                      ),
                    );
                  } else {
                    return snapshot.data!.isEmpty
                        ? Center(
                            child: Container(
                              child: const Text("No cats in the list"),
                            ),
                          )
                        : ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data!.map((cat) {
                              return Column(children: [
                                SizedBox(
                                  width: 100,
                                  child: Image.file(File(cat.imagepath)),
                                ),
                                Center(
                                    child: Card(
                                  color: catid == cat.id
                                      ? Color.fromARGB(255, 137, 69, 146)
                                      : Colors.white,
                                  child: ListTile(
                                    textColor: catid == cat.id
                                        ? Colors.white
                                        : Colors.black,
                                    title: Text(
                                        'Name: ${cat.name} | Race: ${cat.race}'),
                                    onLongPress: () {
                                      setState(() {
                                        DatabaseHelper.instance.delete(cat.id!);
                                      });
                                    },
                                    onTap: () {
                                      setState(() {
                                        if (catid == null) {
                                          textControllerName.text = cat.name;
                                          textControllerRace.text = cat.race;
                                          catid = cat.id;
                                        } else {
                                          textControllerName.clear();
                                          textControllerRace.clear();
                                          catid = null;
                                        }
                                      });
                                    },
                                  ),
                                )),
                              ]);
                            }).toList());
                  }
                },
              )),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          if (catid == null) {
            await DatabaseHelper.instance.update(Cat(
                race: textControllerRace.text,
                name: textControllerName.text,
                imagepath: widget.imgapath,
                id: catid));
          } else {
            DatabaseHelper.instance.add(Cat(
                race: textControllerRace.text,
                name: textControllerName.text,
                imagepath: widget.imgapath));
          }
          DatabaseHelper.instance.add(Cat(
              race: textControllerRace.text,
              name: textControllerName.text,
              imagepath: widget.imgapath));
          setState(() {
            textControllerName.clear();
            textControllerRace.clear();
          });
        },
      ),
    );
  }
}
