import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharePreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
Position? position;
List<Placemark>? placeMarks;
String completeAddress = "";