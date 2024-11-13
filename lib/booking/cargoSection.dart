import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingConfirmationDetailsPage extends StatefulWidget {
  @override
  _BookingConfirmationDetailsPageState createState() => _BookingConfirmationDetailsPageState();
}

class _BookingConfirmationDetailsPageState extends State<BookingConfirmationDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _vesselVoyageController = TextEditingController();
  final _cfsCartingController = TextEditingController();
  final _cfsCartingInfoController = TextEditingController();
  final _overseasAgentController = TextEditingController();
  final _remarkController = TextEditingController();
  final _chaController = TextEditingController();
  final _chaAddressController = TextEditingController();
  final _carrierController = TextEditingController();
  final _carrierAddressController = TextEditingController();
  final _carrierPanController = TextEditingController();
  final _slotOperatorController = TextEditingController();
  final _slotOperatorAddressController = TextEditingController();
  final _slotOperatorAttentionController = TextEditingController();
  final _transshipmentController = TextEditingController();
  final _releaseOrderController = TextEditingController();
  bool _ownContainer = false;

  DateTime? _cutOffDate;
  TimeOfDay? _cutOffTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Confirmation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _vesselVoyageController,
                        decoration: InputDecoration(
                          labelText: 'Vessel/Voyage',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectCutOffDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Cut Off Date',
                              hintText: _cutOffDate == null
                                  ? 'Select Date'
                                  : _cutOffDate!.toLocal().toString().split(' ')[0],
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectCutOffTime(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Cut Off Time',
                              hintText: _cutOffTime == null
                                  ? 'Select Time'
                                  : _cutOffTime!.format(context),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cfsCartingController,
                        decoration: InputDecoration(
                          labelText: 'CFS Carting Information',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _cfsCartingInfoController,
                  decoration: InputDecoration(
                    labelText: 'CFS Carting Info Details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _overseasAgentController,
                        decoration: InputDecoration(
                          labelText: 'Overseas Agent',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _chaController,
                        decoration: InputDecoration(
                          labelText: 'CHA',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _showChaDialog(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: Text('Own Container'),
                        value: _ownContainer,
                        onChanged: (value) {
                          setState(() {
                            _ownContainer = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _carrierController,
                        decoration: InputDecoration(
                          labelText: 'Carrier',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _showCarrierDialog(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _slotOperatorController,
                        decoration: InputDecoration(
                          labelText: 'Slot Operator',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _showSlotOperatorDialog(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _transshipmentController,
                        decoration: InputDecoration(
                          labelText: 'Transshipment At',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _releaseOrderController,
                        decoration: InputDecoration(
                          labelText: 'Release Order Advised To',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FirebaseFirestore.instance.collection('bookingConfirmationDetails').add({
                        'vesselVoyage': _vesselVoyageController.text,
                        'cutOffDate': _cutOffDate?.toLocal().toString().split(' ')[0],
                        'cutOffTime': _cutOffTime?.format(context),
                        'cfsCarting': _cfsCartingController.text,
                        'cfsCartingInfo': _cfsCartingInfoController.text,
                        'overseasAgent': _overseasAgentController.text,
                        'remark': _remarkController.text,
                        'cha': _chaController.text,
                        'chaAddress': _chaAddressController.text,
                        'ownContainer': _ownContainer,
                        'carrier': _carrierController.text,
                        'carrierAddress': _carrierAddressController.text,
                        'carrierPan': _carrierPanController.text,
                        'slotOperator': _slotOperatorController.text,
                        'slotOperatorAddress': _slotOperatorAddressController.text,
                        'slotOperatorAttention': _slotOperatorAttentionController.text,
                        'transshipmentAt': _transshipmentController.text,
                        'releaseOrderAdvisedTo': _releaseOrderController.text,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking details saved successfully')));
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectCutOffDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _cutOffDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _cutOffDate) {
      setState(() {
        _cutOffDate = picked;
      });
    }
  }

  Future<void> _selectCutOffTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _cutOffTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _cutOffTime) {
      setState(() {
        _cutOffTime = picked;
      });
    }
  }

  void _showChaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New CHA'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _chaController,
                decoration: InputDecoration(
                  labelText: 'CHA',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _chaAddressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _chaController.text = _chaController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showCarrierDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Carrier'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _carrierController,
                decoration: InputDecoration(
                  labelText: 'Carrier',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _carrierAddressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _carrierPanController,
                decoration: InputDecoration(
                  labelText: 'PAN No',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _carrierController.text = _carrierController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showSlotOperatorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Slot Operator'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _slotOperatorController,
                decoration: InputDecoration(
                  labelText: 'Slot Operator',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _slotOperatorAddressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _slotOperatorAttentionController,
                decoration: InputDecoration(
                  labelText: 'Attention',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _slotOperatorController.text = _slotOperatorController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

}
