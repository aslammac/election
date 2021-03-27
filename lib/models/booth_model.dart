import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import './contact_model.dart';

class BoothModel {
  String id;
  String lac;
  String pollingStation;
  String lsga;
  String partNum;
  ContactModel contactModel;
  BoothModel({
    this.id,
    this.lac,
    this.pollingStation,
    this.lsga,
    this.partNum,
    this.contactModel,
  });
  factory BoothModel.fromDocument(QueryDocumentSnapshot snapshot) {
    return BoothModel(
      id: snapshot.id,
      lac: snapshot.data()['lac'],
      pollingStation: snapshot.data()['pollingStation'],
      lsga: snapshot.data()['lsga'],
      partNum: snapshot.data()['partNum'].toString(),
      contactModel: ContactModel(
        adpaName: snapshot.data()['adpaName'],
        adpaNumber: snapshot.data()['adpaNumber'].toString(),
        operatorName: snapshot.data()['operatorName'],
        operatorNumber: snapshot.data()['operatorNumber'].toString(),
        hseName: snapshot.data()['hseName'],
        hseNumber: snapshot.data()['hseNumber'].toString(),
        taName: snapshot.data()['taName'],
        taNumber: snapshot.data()['taNumber'].toString(),
        bsnlName: snapshot.data()['bsnlName'],
        bsnlNumber: snapshot.data()['bsnlNumber'].toString(),
        sectorName: snapshot.data()['sectorName'],
        sectorNumber: snapshot.data()['sectorNumber'].toString(),
      ),
    );
  }
  factory BoothModel.fromRealtimeDocument(dynamic snapshot) {
    return BoothModel(
      id: snapshot['id'].toString(),
      lac: snapshot['lac'].toString(),
      pollingStation: snapshot['pollingStation'],
      lsga: snapshot['lsga'],
      partNum: snapshot['partNum'].toString(),
      contactModel: ContactModel(
        adpaName: snapshot['adpaName'],
        adpaNumber: snapshot['adpaNumber'].toString(),
        operatorName: snapshot['operatorName'],
        operatorNumber: snapshot['operatorNumber'].toString(),
        hseName: snapshot['hseName'],
        hseNumber: snapshot['hseNumber'].toString(),
        taName: snapshot['taName'],
        taNumber: snapshot['taNumber'].toString(),
        bsnlName: snapshot['bsnlName'],
        bsnlNumber: snapshot['bsnlNumber'].toString(),
        sectorName: snapshot['sectorName'],
        sectorNumber: snapshot['sectorNumber'].toString(),
      ),
    );
  }
  Map<String, String> toJson() {
    return {
      'id': this.id,
      'lac': this.lac,
      'pollingStation': this.pollingStation,
      'lsga': this.lsga,
      'partNum': this.partNum,
      'adpaName': this.contactModel.adpaName,
      'adpaNumber': this.contactModel.adpaNumber,
      'operatorName': this.contactModel.operatorName,
      'operatorNumber': this.contactModel.operatorNumber,
      'hseName': this.contactModel.hseName,
      'hseNumber': this.contactModel.hseNumber,
      'taName': this.contactModel.taName,
      'taNumber': this.contactModel.taNumber,
      'bsnlName': this.contactModel.bsnlName,
      'bsnlNumber': this.contactModel.bsnlNumber,
      'sectorName': this.contactModel.sectorName,
      'sectorNumber': this.contactModel.sectorNumber,
    };
  }

  factory BoothModel.fromJson(Map<String, dynamic> booth) {
    return BoothModel(
      id: booth['id'].toString(),
      lac: booth['lac'],
      pollingStation: booth['pollingStation'],
      lsga: booth['lsga'],
      partNum: booth['partNum'].toString(),
      contactModel: ContactModel(
        adpaName: booth['adpaName'],
        adpaNumber: booth['adpaNumber'].toString(),
        operatorName: booth['operatorName'],
        operatorNumber: booth['operatorNumber'].toString(),
        hseName: booth['hseName'],
        hseNumber: booth['hseNumber'].toString(),
        taName: booth['taName'],
        taNumber: booth['taNumber'].toString(),
        bsnlName: booth['bsnlName'],
        bsnlNumber: booth['bsnlNumber'].toString(),
        sectorName: booth['sectorName'],
        sectorNumber: booth['sectorNumber'].toString(),
      ),
    );
  }

  bool isEqual(BoothModel model) {
    return this?.id == model?.id;
  }

  String boothAsString() {
    return '${this.partNum} . ${this.pollingStation}';
  }
}
