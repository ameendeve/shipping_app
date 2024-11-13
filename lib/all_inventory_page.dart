import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllInventoryPage extends StatefulWidget {
  const AllInventoryPage({super.key});

  @override
  _AllInventoryPageState createState() => _AllInventoryPageState();
}

class _AllInventoryPageState extends State<AllInventoryPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    // Add listener to update the search text whenever the search field changes
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Inventory'),
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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Container Number',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No inventory data available.'));
                }

                // Filter rows based on search text
                List<DataRow> rows = snapshot.data!.docs
                    .where((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      String containerNo = data['containerNo'] ?? '';
                      return containerNo.contains(_searchText);
                    })
                    .map((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      return DataRow(cells: [
                        DataCell(Text(data['containerNo'] ?? '')),
                        DataCell(Text(data['size'] ?? '')),
                        DataCell(Text(data['remarks'] ?? '')),
                        DataCell(Text(data['blNumber'] ?? '')),
                        DataCell(Text(data['freeDays'] ?? '')),
                        DataCell(Text(data['vessel'] ?? '')),
                        DataCell(Text(data['sailedDate'] != null
                            ? (data['sailedDate'] as Timestamp).toDate().toLocal().toString().split(' ')[0]
                            : '')),
                        DataCell(Text(data['dischargeDate'] != null
                            ? (data['dischargeDate'] as Timestamp).toDate().toLocal().toString().split(' ')[0]
                            : '')),
                        DataCell(Text(data['sntcDate'] != null
                            ? (data['sntcDate'] as Timestamp).toDate().toLocal().toString().split(' ')[0]
                            : '')),
                        DataCell(Text(data['rcvcDate'] != null
                            ? (data['rcvcDate'] as Timestamp).toDate().toLocal().toString().split(' ')[0]
                            : '')),
                        DataCell(Text(data['pod'] ?? '')),
                        DataCell(Text(data['status'] ?? '')),
                      ]);
                    })
                    .toList();

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                            border: TableBorder.all(color: Colors.grey, width: 0.5),
                            columns: const [
                              DataColumn(label: Text('Container No')),
                              DataColumn(label: Text('Size')),
                              DataColumn(label: Text('Remarks')),
                              DataColumn(label: Text('B/L Number')),
                              DataColumn(label: Text('Free Days')),
                              DataColumn(label: Text('Vessel')),
                              DataColumn(label: Text('Sailed Date')),
                              DataColumn(label: Text('Discharge Date')),
                              DataColumn(label: Text('SNTC')),
                              DataColumn(label: Text('RCVC')),
                              DataColumn(label: Text('POD')),
                              DataColumn(label: Text('Status')),
                            ],
                            rows: rows,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
