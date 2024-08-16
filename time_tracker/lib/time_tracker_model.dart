import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'user_model.dart';


class ProjectModel {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String? id;
  String? name;
  String? description;
  String? createdByUID; //UID of the user that created the project
  DateTime? createdAt;
  List<TimeTrackerModel>? heldLoadedTimeTrackers;
  List<String>? TimeTrackerIds;
  List<String>? sharedWithUids;
  ProjectModel();

  Future<void> updateToFirebase() async {
    if (this.id == null){
      throw Exception("Cannot update to Firebase if no ID is provided");
    }
    await db.collection("user_timetracker").doc(this.id).update(this.toFirebaseJson());
  }

  Map<String, dynamic> toFirebaseJson(){
    return {
      "name": name,
      "description": description,
      "createdByUID": createdByUID,
      "createdAt": createdAt,
      "TimeTrackerIds": TimeTrackerIds,
      "sharedWithUids": sharedWithUids
    };
  }

  Future<void> addSharedWithUid(String uid) async {
    // ignore: prefer_conditional_assignment
    if (sharedWithUids == null){
      sharedWithUids = <String>[];
    }
    sharedWithUids!.add(uid);
    await updateToFirebase();
  }
}

//TODO: Find way to turn model into a object that is accepted by db collection documents for update, create
class TimeTrackerModel{
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String? id;
  String name;
  String project = "";
  String description = "";
  DateTime startTime =  DateTime.now();
  DateTime? endTime;
  DateTime? deletedAt;
  String createdByUID;
  RxBool loading = false.obs;
  RxBool error = false.obs;
  RxString errMsg = "".obs;

  Map<String, dynamic> toFirebaseJson(){
    return {
      "name": name,
      "project": project,
      "description": description,
      "startTime": startTime,
      "endTime": endTime,
      "deletedAt": deletedAt,
      "createdByUID": createdByUID
    };
  }
  // @throws Exception
  
  Future<void> StopTimer() async {
    if (endTime != null){
      throw new Exception("could not set End time as End time already set");
    }
    endTime = DateTime.now();
    await updateToFirebase();
  }

  Future<void> updateToFirebase() async {
    if (this.id == null){
      throw Exception("Cannot update to Firebase if no ID is provided");
    }
    await db.collection("user_timetracker").doc(this.id).update(this.toFirebaseJson());
  }

  

  Future<void> loadFromFirebase() async {
    loading.value = true;
    DocumentSnapshot<Map<String, dynamic>> prev_snapshot = await db.collection("user_timetracker").doc(this.id).get();
    if (prev_snapshot.exists){
      this.name = prev_snapshot.data()?["name"];
      this.project = prev_snapshot.data()?["project"];
      this.description = prev_snapshot.data()?["description"];
      this.startTime = prev_snapshot.data()?["startTime"];
      this.endTime = prev_snapshot.data()?["endTime"];
      this.deletedAt = prev_snapshot.data()?["deletedAt"];
      this.createdByUID = prev_snapshot.data()?["createdByUID"];
    }
  }

  // verify if us,er is legit
  void userIsLegit(String UID) async {
    DocumentSnapshot<Map<String, dynamic>> user = await db.collection("users").doc(UID).get();
    if (user.id != ""){
      loading = true.obs;
    }else{
      error = false.obs;
      errMsg = "Author User is not a valid user for this operation".obs;
    }
  }

  TimeTrackerModel({required this.name, required this.createdByUID}){
    userIsLegit(createdByUID);
  }

}

Future<TimeTrackerModel> createTimeTrackerModelFromId(String findId) async{
    TimeTrackerModel loadingModel = TimeTrackerModel(name:"loading", createdByUID:findId);
    try{
      await loadingModel.loadFromFirebase();
      return loadingModel;
    }catch(e){
      throw "Database could not verify if $findId is a valid ID";
    }
  }

class TimeTrackerUpdateListModel{
  final String updatedBy;
  final String TimeTrackerModelId;
  final String beforeUpdate;
  final String afterUpdate;
  TimeTrackerUpdateListModel({required this.updatedBy, required this.TimeTrackerModelId, required this.beforeUpdate, required this.afterUpdate});
}


