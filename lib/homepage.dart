import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? 'User Name'),
              accountEmail: Text(user?.email ?? 'user@example.com'),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 55,)
                // backgroundImage: user?.photoURL != null
                //     ? NetworkImage(user!.photoURL!)
                //     : const AssetImage('images/default_profile.jpg') as ImageProvider,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/homepage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('All Bookings'),
              onTap: () {
                Navigator.pushNamed(context, '/allbookingspage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('New Booking'),
              onTap: () {
                Navigator.pushNamed(context, '/newbookingspage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('All Inventory'),
              onTap: () {
                Navigator.pushNamed(context, '/allinventorypage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text('New Inventory'),
              onTap: () {
                Navigator.pushNamed(context, '/newinventorypage');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/loginpage');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.0, // Adjust this ratio to control card size
          children: [
            buildCard(
              context,
              title: 'All Bookings',
              icon: Icons.book,
              color: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context, '/allbookingspage');
              },
            ),
            buildCard(
              context,
              title: 'New Booking',
              icon: Icons.add,
              color: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, '/newbookingspage');
              },
            ),
            buildCard(
              context,
              title: 'All Inventory',
              icon: Icons.inventory,
              color: Colors.orange,
              onTap: () {
                Navigator.pushNamed(context, '/allinventorypage');
              },
            ),
            buildCard(
              context,
              title: 'New Inventory',
              icon: Icons.add_box,
              color: Colors.purple,
              onTap: () {
                Navigator.pushNamed(context, '/newinventorypage');
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
            Icon(icon, size: 36, color: Colors.white), // Reduced icon size
            const SizedBox(height: 8), // Reduced spacing
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.white), // Adjusted font size
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
