import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class NearbyUsersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Geoflutterfire geo = Geoflutterfire();

  Stream<List<DocumentSnapshot>> getNearbyUsers(Position position, double radiusInKm) {
    GeoFirePoint center = geo.point(latitude: position.latitude, longitude: position.longitude);

    var collectionReference = _firestore.collection('users');
    String field = 'position';

    return geo.collection(collectionRef: collectionReference)
        .within(center: center, radius: radiusInKm, field: field);
  }
}
