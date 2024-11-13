import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class NewInventoryPage extends StatefulWidget {
  const NewInventoryPage({super.key});

  @override
  _NewInventoryPageState createState() => _NewInventoryPageState();
}

class _NewInventoryPageState extends State<NewInventoryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _containerNoController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _blNumberController = TextEditingController();
  final TextEditingController _freeDaysController = TextEditingController();
  final TextEditingController _vesselController = TextEditingController();
  final TextEditingController _podController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  
  String? selectedSize;
  DateTime? sailedDate;
  DateTime? dischargeDate;
  DateTime? sntcDate;
  DateTime? rcvcDate;

  Future<void> _selectDate(BuildContext context, DateTime? initialDate, Function(DateTime?) onDateSelected) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),  // Adds padding around the Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Row: Container No, Size, and Remarks
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _containerNoController,
                          decoration: const InputDecoration(
                            labelText: 'Container No.',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedSize,
                          onChanged: (value) => setState(() => selectedSize = value),
                          items: ['40HC', '20GP'].map((size) {
                            return DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Size',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  const SizedBox(height: 16),
              
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _remarksController,
                          decoration: const InputDecoration(
                            labelText: 'Remarks',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
              
                  // Second Row: B/L Number, Free Days, and Vessel
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _blNumberController,
                          decoration: const InputDecoration(
                            labelText: 'B/L Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _freeDaysController,
                          decoration: const InputDecoration(
                            labelText: 'Free Days',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _vesselController,
                          decoration: const InputDecoration(
                            labelText: 'Vessel',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
              
                  // Third Row: Sailed Date, Discharge Date, and SNTC Date
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, sailedDate, (date) => setState(() => sailedDate = date)),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Sailed',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              sailedDate != null ? sailedDate!.toLocal().toString().split(' ')[0] : 'Select Date',
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, dischargeDate, (date) => setState(() => dischargeDate = date)),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Discharge Date',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              dischargeDate != null ? dischargeDate!.toLocal().toString().split(' ')[0] : 'Select Date',
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, sntcDate, (date) => setState(() => sntcDate = date)),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'SNTC',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              sntcDate != null ? sntcDate!.toLocal().toString().split(' ')[0] : 'Select Date',
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
              
                  // Fourth Row: RCVC Date, POD, and Status
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, rcvcDate, (date) => setState(() => rcvcDate = date)),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'RCVC',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              rcvcDate != null ? rcvcDate!.toLocal().toString().split(' ')[0] : 'Select Date',
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _podController,
                          decoration: const InputDecoration(
                            labelText: 'POD',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _statusController,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
              
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: const Text('Save', style: TextStyle(fontSize: 18),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //on submit code section
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create a reference to the Firestore collection
        CollectionReference inventory =
            FirebaseFirestore.instance.collection('inventory');

        // Add a new document to the Firestore collection with the data from the form fields
        await inventory.add({
          'containerNo': _containerNoController.text,
          'size': selectedSize,
          'remarks': _remarksController.text,
          'blNumber': _blNumberController.text,
          'freeDays': _freeDaysController.text,
          'vessel': _vesselController.text,
          'sailedDate': sailedDate,
          'dischargeDate': dischargeDate,
          'sntcDate': sntcDate,
          'rcvcDate': rcvcDate,
          'pod': _podController.text,
          'status': _statusController.text,
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Inventory saved successfully!'),
          backgroundColor: Colors.green,
        ));

        // Clear the form
        _formKey.currentState?.reset();
        _containerNoController.clear();
        _remarksController.clear();
        _blNumberController.clear();
        _freeDaysController.clear();
        _vesselController.clear();
        _podController.clear();
        _statusController.clear();
        setState(() {
          selectedSize = null;
          sailedDate = null;
          dischargeDate = null;
          sntcDate = null;
          rcvcDate = null;
        });
      } catch (e) {
        // Show an error message if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save inventory: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
