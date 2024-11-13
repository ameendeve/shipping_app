import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? 'User Name'),
              accountEmail: Text(user?.email ?? 'user@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : AssetImage('assets/default_profile.png') as ImageProvider,
              ),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('All Bookings'),
              onTap: () {
                Navigator.pushNamed(context, '/allBookings');
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('New Booking'),
              onTap: () {
                Navigator.pushNamed(context, '/newBooking');
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('All Inventory'),
              onTap: () {
                Navigator.pushNamed(context, '/allInventory');
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('New Inventory'),
              onTap: () {
                Navigator.pushNamed(context, '/newInventory');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            buildCard(
              context,
              title: 'All Bookings',
              icon: Icons.book,
              color: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context, '/allBookings');
              },
            ),
            buildCard(
              context,
              title: 'New Booking',
              icon: Icons.add,
              color: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, '/newBooking');
              },
            ),
            buildCard(
              context,
              title: 'All Inventory',
              icon: Icons.inventory,
              color: Colors.orange,
              onTap: () {
                Navigator.pushNamed(context, '/allInventory');
              },
            ),
            buildCard(
              context,
              title: 'New Inventory',
              icon: Icons.add_box,
              color: Colors.purple,
              onTap: () {
                Navigator.pushNamed(context, '/newInventory');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
