import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// This controller is responsible for fetching the data from the firebase and providing it to the UI as a object from JSON

abstract class CRUDcontroller {
  Future<void> create(String query, dynamic data);
  Future<dynamic> read(String query);
  Future<void> update(String query, dynamic data);
  Future<void> delete(String query);
}

class FirebaseCRUDcontroller extends CRUDcontroller {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  FirebaseCRUDcontroller() {}

  DocumentReference getDocumentReference(String query) {
    List<String> parts = query.split('>');
    DocumentReference docRef = db.collection(parts[0]).doc(parts[1]);
    try {
      for (int i = 2; i < parts.length; i+=2) {
        if (i == parts.length - 1) {
          docRef = docRef.collection(parts[i]).doc(parts[i+1]);
        }
      }
    }
    catch (e) {
      throw Exception('Error creating data: Could not create path: $e'); 
    }
    return docRef;
  }

  @override
  Future<void> create(String query, dynamic data) async {
    DocumentReference docRef = getDocumentReference(query);

    try{
      await docRef.set(data);
    }
    catch (e) {
      throw Exception('Error creating data: Could not set data: $e');
    }
    String currentPath = '';


    if (currentPath.isNotEmpty) {
      await docRef.update({currentPath: data});
    } else {
      await docRef.set(data);
    }
    return await db.collection('hierarchical_data').doc('structure').set({'structure': '{"name": "root", "children": []}'}, SetOptions(merge: true));
  }

  @override
  Future<dynamic> read(String query) async {
    DocumentReference docRef = getDocumentReference(query);
    try {
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      throw Exception('Error reading data: $e');
    }
  }

  @override
  Future<void> update(String query, dynamic data) async {
    DocumentReference docRef = getDocumentReference(query);
    try {
      await docRef.update(data);
    } catch (e) {
      throw Exception('Error updating data: $e');
    }
  }

  @override
  Future<void> delete(String query) async {
    DocumentReference docRef = getDocumentReference(query);
    try {
      await docRef.delete();
    } catch (e) {
      throw Exception('Error deleting data: $e');
    }
  }
}

class EROrganizationModel {
  String name;
  String id;
  String parentId;
  String description;
  GeoPoint location;
  late CRUDcontroller FirebaseCRUDcontroller;
  EROrganizationModel({required this.name, required this.id, required this.parentId, required this.description, required this.location}) {
    this.FirebaseCRUDcontroller = FirebaseCRUDcontroller;
  }
  Map<String, dynamic> toFirebaseJson() {
    return {
      'name': name,
      'id': id,
      'parentId': parentId,
      'description': description,
      'location': location
    };
  }
  String query = 'ERMetadatas';
  void update(String id) async {
    await FirebaseCRUDcontroller.update(query+id, this.toFirebaseJson());
  }
  void delete(String id) async {
    await FirebaseCRUDcontroller.delete(query+id);
  }
  void create(String id) async {
    await FirebaseCRUDcontroller.create(query+id, this.toFirebaseJson());
  }
  void read(String id) async {
    await FirebaseCRUDcontroller.read(query+id);
  }
  
}

class ERDataController {
  final CRUDcontroller db = FirebaseFirestore.instance as CRUDcontroller;
  late String index;
  bool loading = true;
  ERDataController() {
    _initIndex().then((value) => loading = false);
  }

  Future<void> _initIndex() async {
    try {
      index = await db.read('ERMetadatas>index');
    } catch (e) {
      print(e);
      db.create('ERMetadatas>index', '{"children": []}');
      index = '{"children": []}';
    }
  }

  createNewDefaultER() async {
    EROrganizationModel erOrganizationModel = EROrganizationModel(name: 'New ER', id: 'newER', parentId: 'root', description: 'New ER', location: GeoPoint(0, 0));
    erOrganizationModel.create('newER');
    await db.update('ERMetadatas>index', jsonDecode(index)['children'].add(erOrganizationModel.id));
  }
}

class HierarchicalDataPage extends StatefulWidget {
  HierarchicalDataPage({super.key});
  final ERDataController _erDataController = ERDataController();
  @override
  State<HierarchicalDataPage> createState() => _HierarchicalDataPageState();
}

class _HierarchicalDataPageState extends State<HierarchicalDataPage> {
  @override
  Widget build(BuildContext context) {
    ERDataController _erDataController = widget._erDataController;
    if (_erDataController.loading) {
      return CircularProgressIndicator();
    }
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text('ER Data'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: 
          Builder(
            builder: (context) {
              final indexData = jsonDecode(_erDataController.index);
              return Expanded(
                child: ListView.builder(
                  itemCount: indexData['children'].length,
                  itemBuilder: (context, index) {
                    final child = indexData['children'][index];
                    return ListTile(
                      title: Text(child['name'] ?? 'Unnamed'),
                      subtitle: Text(child['type'] ?? 'No type'),
                      onTap: () {
                        // Handle tap on child item
                      },
                    );
                  },
                ),
              );
            },
          )
          
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement adding a new ER
          print('Add new ER');

        },
        child: Icon(Icons.add),
        tooltip: 'Add new ER',
      ),
    ));
  }
}