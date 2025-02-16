import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Geoflutterfire geo = Geoflutterfire();

  Future<void> saveUserLocation(String userId, Position position) async {
    GeoFirePoint geoPoint = geo.point(latitude: position.latitude, longitude: position.longitude);

    await _firestore.collection('users').doc(userId).set({
      'position': geoPoint.data,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
