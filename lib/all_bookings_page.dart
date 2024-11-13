import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shipping_app/edit_booking_page.dart';

class AllBookingsPage extends StatefulWidget {
  const AllBookingsPage({super.key});

  @override
  _AllBookingsPageState createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends State<AllBookingsPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Bookings'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').orderBy('bookingNumber', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          final bookings = snapshot.data!.docs;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4, // You can adjust the elevation as needed
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                      border: TableBorder.all(color: Colors.grey, width: 0.25),
                      sortAscending: false,
                      columns: const [
                        DataColumn(label: Text('S.No.')),
                        DataColumn(label: Text('Booking No.')),
                        DataColumn(label: Text('POL')),
                        DataColumn(label: Text('Client')),
                        DataColumn(label: Text('Bill of Lading No.')),
                        DataColumn(label: Text('Vessel / Voyage')),
                        DataColumn(label: Text('Final Destination')),
                        DataColumn(label: Text('Commodity')),
                      ],
                      rows: List<DataRow>.generate(
                        bookings.length,
                        (index) {
                          var data = bookings[index].data() as Map<String, dynamic>;
                          String bookingId = bookings[index].id; // Get document ID
                    
                          return DataRow(
                            cells: [
                              DataCell(Text((index + 1).toString())), // S.No.
                              DataCell(
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditBookingPage(
                                          bookingId: bookingId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    data['bookingNumber'] ?? 'N/A',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 12, 75, 127),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ), // Booking No. (Clickable)
                              DataCell(Text(data['customer'] ?? 'N/A')), // Client
                              DataCell(Text(data['billOfLadingNo'] ?? 'N/A')), // Bill of Lading No.
                              DataCell(Text(data['vesselVoyage'] ?? 'N/A')), // Vessel / Voyage
                              DataCell(Text(data['finalDestination'] ?? 'N/A')), // Final Destination
                              DataCell(Text(data['containerCategory'] ?? 'N/A')), // Container Category
                              DataCell(Text(data['portOfLoading'] ?? 'N/A')), // Port of Loading
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
