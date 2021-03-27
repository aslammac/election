import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
//models
import '../models/booth_model.dart';
import '../models/contact_model.dart';
//pages
import '../screen/contact_screen.dart';

class MainProvider with ChangeNotifier {
  final firebase = cloud.FirebaseFirestore.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  bool _isLoading = true;
  String _lacName;
  String _lsgaName;
  BoothModel _pollingStationName;
  BoothModel _pollingStationNameTemp;
  BoothModel _recentBooth;
  List<String> _lacList = [
    'ERANAD',
    'KONDOTTY',
    'KOTTAKKAL',
    'MALAPPURAM',
    'MANJERI',
    'MANKADA',
    'NILAMBUR',
    'PERINTHALMANNA',
    'PONNANI',
    'TANUR',
    'THAVANUR',
    'TIRUR',
    'TIRURANGADI',
    'VALLIKKUNNU',
    'VENGARA',
    'WANDOOR'
  ];
  Map<String, List<String>> _lsgaList = {
    'ERANAD': [
      'Chaliyar',
      'Areecode',
      'Edavanna',
      'Kavanoor',
      'Keezhuparamba',
      'Urangattiri',
      'Kuzhimanna',
    ],
    'KONDOTTY': [
      'Cheacode',
      'Cherukav',
      'Kondotty Muncipality',
      'Pulikkal',
      'Vazhakkad',
      'Vazhayur',
      'Muthuvallur',
      'Kondotty Block Panchayat',
    ],
    'KOTTAKKAL': [
      'Edayur',
      'irimbiliyam',
      'Kottakkal Muncipality',
      'kuttippuram',
      'Marakkara',
      'ponmala',
      'Valancheri Muncipality',
    ],
    'MALAPPURAM': [
      'Malappuram Municipality',
      'Morayur',
      'Pookkottur',
      'Anakkayam',
      'Pulpatta',
      'Kodur',
    ],
    'MANJERI': [
      'Manjeri Muncipality',
      'Pandikkad',
      'Thrikkalangode',
      'Edappatta',
      'Keezhatoor',
    ],
    'MANKADA': [
      'Angadippuram',
      'Koottilangadi',
      'Kuruva',
      'Makkaraparamba',
      'Mankada',
      'Moorkanad',
      'Puzhakkattiri',
    ],
    'NILAMBUR': [
      'Amarambalam',
      'Chungathara',
      'Edakkara',
      'Karulai',
      'Moothedam',
      'Nilambur Muncipality',
      'Pothukal',
      'Vazhikkadav',
    ],
    'PERINTHALMANNA': [
      'Perinthalmanna Muncipality',
      'Aliparamba',
      'Elamkulam',
      'Thazhekkode',
      'Melattur',
      'Vettathur',
      'Pulamanthole',
    ],
    'PONNANI': [
      'Ponnani Muncipality',
      'Alancode',
      'Marancheri',
      'Nannamukku',
      'Perumpadappa',
      'Kaladi',
      'Veliancode',
    ],
    'TANUR': [
      'Cheriyamundam',
      'Niramaruthur',
      'Ozhur',
      'Ponmundam',
      'Thanalur',
      'Tanur Muncipality',
    ],
    'THAVANUR': [
      'Edappal',
      'Thavanur',
      'Vattamkulam',
      'Purathur',
      'Mangalam',
      'Thriprangode',
    ],
    'TIRUR': [
      'Tirur Muncipality',
      'Athavanad',
      'Kalpakancherey',
      'Thalakkad',
      'Thirunavaya',
      'Valavannur',
      'Vettom',
    ],
    'TIRURANGADI': [
      'Edarikkode',
      'Nannambra',
      'Parappanangadi Muncipality',
      'Thennala',
      'Tirurangadi Muncipality',
      'Perumanna klari',
    ],
    'VALLIKKUNNU': [
      'Chelembra',
      'Moonniyur',
      'Pallikkal',
      'Peruvallur',
      'Thenhippalam',
      'Vallikunnu',
    ],
    'VENGARA': [
      'A.R. nagar',
      'Kannamangalam',
      'Othukkungal',
      'Parappur',
      'Oorakam',
      'Vengara',
    ],
    'WANDOOR': [
      'Chokkad',
      'Kalikavu',
      'Karuvarakundu',
      'Mampad',
      'Porur',
      'Thiruvali',
      'Thuvvur',
      'Wandoor',
    ]
  };
  List<BoothModel> _pollingStationList = [];
  List<String> _lsgaSelectedList = [];
  String get lacName {
    return _lacName;
  }

  String get lsgaName {
    return _lsgaName;
  }

  BoothModel get pollingStationName {
    return _pollingStationName;
  }

  BoothModel get pollingStationNameTemp {
    return _pollingStationNameTemp;
  }

  BoothModel get recentBooth {
    return _recentBooth;
  }

  List<String> get lacList {
    return _lacList;
  }

  List<String> get lsgaSelectedList {
    return _lsgaSelectedList;
  }

  List<BoothModel> get pollingStaionList {
    return _pollingStationList;
  }

  bool get isLoading {
    return _isLoading;
  }

  void fetchLsga(String lac) {
    // _lsgaSelectedList = [];
    _lsgaName = null;
    _lacName = lac;
    _isLoading = true;
    _pollingStationNameTemp = null;
    _lsgaSelectedList = _lsgaList[lac];
    notifyListeners();
  }

  Future<void> fetchBooth(String lsga) async {
    _lsgaName = lsga;
    notifyListeners();
    _pollingStationList = [];
    final prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url');
    if (url == null) {
      final DocumentSnapshot urlQuery =
          await firebase.collection('static').doc('realtimeDb').get();
      String url = urlQuery.data()['db0'];
      await prefs.setString('url', url);
    } else {
      url = prefs.getString('url');
    }
    final _filter = '?orderBy="lsga"&equalTo="$lsga"';
    final _url = "$url$_filter";

    // final cloud.DocumentReference cacheDocRef =
    //     cloud.FirebaseFirestore.instance.doc('status/status');

    // final String cacheField = 'time';

    // final cloud.Query query =
    //     firebase.collection('booth').where('lac', isEqualTo: lac.trim());
    // try {
    //   final cloud.QuerySnapshot snapshot = await FirestoreCache.getDocuments(
    //     query: query,
    //     cacheDocRef: cacheDocRef,
    //     firestoreCacheField: cacheField,
    //     localCacheKey: 'time',
    //   );
    //   await prefs.setString('time', DateTime.now().toIso8601String());
    // snapshot.docs.forEach((element) {
    //     _pollingStationList.add(BoothModel.fromDocument(element));
    //   });
    try {
      final response = await http.get(_url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((index, element) {
        _pollingStationList.add(BoothModel.fromRealtimeDocument(element));
      });
    } catch (e) {
      throw e;
    }

    // if (_pollingStationList.isNotEmpty) {
    //   _isLoading = false;
    // }
    notifyListeners();
    // firebase
    //     .collection('booth')
    //     .where('lac', isEqualTo: lac.trim())
    //     .get()
    //     .then((value) => print(value.docs.length));
  }

  Future<bool> fetchRecent() async {
    // readData();
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> booth = await jsonDecode(prefs.getString('booth'));
    // print(booth);
    if (booth != null) {
      _recentBooth = BoothModel.fromJson(booth);
      notifyListeners();
      return true;
    }
    return false;
  }

  void readData() {
    final ref = databaseReference
        .child('1844vNCBfUOZWF8RGWbJZsUxJB-1AGrMNLJpVLT6R2Jo')
        .child('primary')
        .orderByChild('lac')
        .equalTo('KONDOTTY')
        .once()
        .then((snapshot) {
      List<dynamic> results = snapshot.value;
      results.forEach((value) {
        BoothModel model = BoothModel.fromRealtimeDocument(value);

        // print(model.lsgi);
      });
      // // BoothModel model = BoothModel.fromRealtimeDocument(snapshot.value[1]);
      // print('${snapshot.value[1]}');
      // print('${snapshot.key}');
    });
    //     .then((DataSnapshot snapshot) {
    //   BoothModel model = BoothModel.fromRealtimeDocument(snapshot);
    //   print(model.lsgi);
    //   print('${snapshot.value}');
    // });
  }

  void selectPollingBooth(BoothModel booth) async {
    final prefs = await SharedPreferences.getInstance();
    _isLoading = false;
    _pollingStationNameTemp = booth;
    _pollingStationName = booth;
    await prefs.setString('booth', jsonEncode(booth.toJson()));
    notifyListeners();
  }

  void searchContact(BuildContext context, {BoothModel booth}) {
    if (booth != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactScreen(booth)),
      );
      return;
    }
    if (_pollingStationNameTemp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select polling Station'),
        ),
      );
      return;
    }
    if (_pollingStationName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactScreen(_pollingStationName)),
      );
      // _isLoading = true;
      // _pollingStationNameTemp = null;
      // _pollingStationList = [];
      notifyListeners();
    }

    print(_pollingStationName.pollingStation);
  }
}
