import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/nearby_users_service.dart';

class NearbyUsersScreen extends StatefulWidget {
  @override
  _NearbyUsersScreenState createState() => _NearbyUsersScreenState();
}

class _NearbyUsersScreenState extends State<NearbyUsersScreen> {
  Position? currentPosition;
  final NearbyUsersService nearbyUsersService = NearbyUsersService();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Position? position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nearby Users")),
      body: currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<List<DocumentSnapshot>>(
              stream: nearbyUsersService.getNearbyUsers(currentPosition!, 10.0), // 10km radius
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                var users = snapshot.data!;
                
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    return ListTile(
                      title: Text("User ID: ${user.id}"),
                      subtitle: Text("Location: ${user['position']}"),
                    );
                  },
                );
              },
            ),
    );
  }
}
