import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shipping_app/booking/cargoSection.dart';
import 'package:shipping_app/bookingNumberService.dart'; // Import Firestore package

class NewBookingPage extends StatefulWidget {
  const NewBookingPage({super.key});

  @override
  _NewBookingPageState createState() => _NewBookingPageState();
}

class _NewBookingPageState extends State<NewBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final BookingNumberService _bookingNumberService = BookingNumberService();

  // Controllers
  final TextEditingController pointOfOriginController = TextEditingController();
  final TextEditingController portOfLoadingController = TextEditingController();
  final TextEditingController portOfDischargeController =
      TextEditingController();
  final TextEditingController finalDestinationController =
      TextEditingController();
  final TextEditingController placeOfDeliveryController =
      TextEditingController();
  final TextEditingController customerController = TextEditingController();
  final TextEditingController freightChargeController = TextEditingController();
  final TextEditingController bookingNumberController = TextEditingController();
  final TextEditingController shipperController = TextEditingController();
  final TextEditingController consigneeController = TextEditingController();
  final TextEditingController notifyController = TextEditingController();
  final TextEditingController shipperAddressController =
      TextEditingController();
  final TextEditingController consigneeAddressController =
      TextEditingController();
  final TextEditingController notifyAddressController = TextEditingController();

  //New Customer Controllers
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController ledgerController = TextEditingController();
  final TextEditingController ledgerGroupController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();
  final TextEditingController tanNumberController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();

  //Cargo Details Controllers
  final _descriptionController = TextEditingController();
  final _marksController = TextEditingController();
  final _quantityController = TextEditingController();
  final _weightController = TextEditingController();
  final _netWeightController = TextEditingController();
  final _volumeController = TextEditingController();
  final _pkgQtyController = TextEditingController();
  final _pkgTypeController = TextEditingController();
  final _bookedByController = TextEditingController();

  //Booking Confirmation Controllers
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
  final _cutOffDateController = TextEditingController();
  final _cutOffTimeController = TextEditingController();
  bool _ownContainer = false;

  DateTime? _cutOffDate;
  TimeOfDay? _cutOffTime;

  String? selectedType;
  String? selectedDeliveryType;
  DateTime? shipmentDate;
  String? selectedStuffingAt;
  String? selectedFreightTerms;
  bool isPartBL = false;
  bool _oblSurrendered = false;
  String _containerSize = '20 ft';
  String _containerCategory = 'General';
  String _weightUnit = 'KGS';

  // Fetch shippers from Firestore
  Future<List<Map<String, String>>> _fetchShippers() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('shipperData').get();
      return snapshot.docs.map((doc) {
        return {
          'name': doc['shipperText'] as String,
          'address': doc['shipperAddress'] as String,
        };
      }).toList();
    } catch (e) {
      print('Error fetching shippers: $e');
      return [];
    }
  }

  // Fetch consignee from Firestore
  Future<List<Map<String, String>>> _fetchConsignee() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('consigneeData').get();
      return snapshot.docs.map((doc) {
        return {
          'name': doc['consigneeText'] as String,
          'address': doc['consigneeAddress'] as String,
        };
      }).toList();
    } catch (e) {
      print('Error fetching consignees: $e');
      return [];
    }
  }

  // Fetch notify from Firestore
  Future<List<Map<String, String>>> _fetchNotify() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('notifyData').get();
      return snapshot.docs.map((doc) {
        return {
          'name': doc['notifyText'] as String,
          'address': doc['notifyAddress'] as String,
        };
      }).toList();
    } catch (e) {
      print('Error fetching notifies: $e');
      return [];
    }
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
        _cutOffDateController.text =
            _cutOffDate!.toLocal().toString().split(' ')[0];
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
        _cutOffTimeController.text = _cutOffTime!.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Booking'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const Text('Shipment Details',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: false,
                                    controller: bookingNumberController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Booking Number'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: selectedType,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedType = value;
                                      });
                                    },
                                    items: [
                                      'LCL/LCL',
                                      'FCL/FCL',
                                      'LCL/FCL',
                                      'FCL/LCL'
                                    ].map((String type) {
                                      return DropdownMenuItem<String>(
                                        value: type,
                                        child: Text(type),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Type'),
                                  ),
                                ),
                                Expanded(
                                  child: CheckboxListTile(
                                    title: const Text('Part B/L'),
                                    value: isPartBL,
                                    onChanged: (value) {
                                      setState(() {
                                        isPartBL = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: pointOfOriginController,
                                    validator: (value) => value!.isEmpty
                                        ? "Enter Point of Origin"
                                        : null,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Point of Origin'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: portOfLoadingController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Port of Loading'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: portOfDischargeController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Port of Discharge'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: finalDestinationController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Final Destination'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: placeOfDeliveryController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Place of Delivery'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: selectedDeliveryType,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDeliveryType = value;
                                      });
                                    },
                                    items: [
                                      'PIER/PIER',
                                      'PIER/DOOR',
                                      'DOOR/DOOR',
                                      'DOOR/PIER'
                                    ].map((String type) {
                                      return DropdownMenuItem<String>(
                                        value: type,
                                        child: Text(type),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Delivery Type'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 150,
                                    child: Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      elevation: 10,
                                      child: Center(
                                        child: ListTile(
                                          title: Text(
                                              'Shipment Date: ${shipmentDate != null ? shipmentDate!.toLocal().toString().split(' ')[0] : 'Select Date'}'),
                                          trailing:
                                              const Icon(Icons.calendar_today),
                                          onTap: () async {
                                            DateTime? picked =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: shipmentDate ??
                                                  DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            );
                                            if (picked != null &&
                                                picked != shipmentDate) {
                                              setState(() {
                                                shipmentDate = picked;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 150,
                                    child: Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      elevation: 10,
                                      child: ListTile(
                                        title: const Text('Stuffing at'),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RadioListTile<String>(
                                              title: const Text('Factory'),
                                              value: 'Factory',
                                              groupValue: selectedStuffingAt,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedStuffingAt = value;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              title: const Text('CFS'),
                                              value: 'CFS',
                                              groupValue: selectedStuffingAt,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedStuffingAt = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: customerController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Customer'),
                                        ),
                                      ),
                                      // IconButton(
                                      //   icon: const Icon(Icons.add),
                                      //   onPressed: () {
                                      //     _showCustomerDialog();
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: selectedFreightTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedFreightTerms = value;
                                      });
                                    },
                                    items: ['PREPAID', 'COLLECT']
                                        .map((String charge) {
                                      return DropdownMenuItem<String>(
                                        value: charge,
                                        child: Text(charge),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Freight Terms'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: freightChargeController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Freight Charge'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Shipper, Consignee, Notify
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: shipperController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Shipper'),
                                          onTap: () async {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (_) async {
                                              final result =
                                                  await _showShipperSearchDialog();
                                              if (result != null) {
                                                setState(() {
                                                  shipperController.text =
                                                      result['name']!;
                                                  shipperAddressController
                                                          .text =
                                                      result['address']!;
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () async {
                                          final result =
                                              await _showShipperDialog();
                                          if (result != null) {
                                            setState(() {
                                              shipperController.text =
                                                  result['name']!;
                                              shipperAddressController.text =
                                                  result['address']!;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: consigneeController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Consignee'),
                                          onTap: () async {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (_) async {
                                              final result =
                                                  await _showConsigneeSearchDialog();
                                              if (result != null) {
                                                setState(() {
                                                  consigneeController.text =
                                                      result['name']!;
                                                  consigneeAddressController
                                                          .text =
                                                      result['address']!;
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () async {
                                          final result =
                                              await _showConsigneeDialog();
                                          if (result != null) {
                                            setState(() {
                                              consigneeController.text =
                                                  result['name']!;
                                              consigneeAddressController.text =
                                                  result['address']!;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: notifyController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Notify'),
                                          onTap: () async {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (_) async {
                                              final result =
                                                  await _showNotifySearchDialog();
                                              if (result != null) {
                                                setState(() {
                                                  notifyController.text =
                                                      result['name']!;
                                                  notifyAddressController.text =
                                                      result['address']!;
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () async {
                                          final result =
                                              await _showNotifyDialog();
                                          if (result != null) {
                                            setState(() {
                                              notifyController.text =
                                                  result['name']!;
                                              notifyAddressController.text =
                                                  result['address']!;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: shipperAddressController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Shipper Address',
                                    ),
                                    maxLines: 3,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: consigneeAddressController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Consignee Address',
                                    ),
                                    maxLines: 3,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: notifyAddressController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Notify Address',
                                    ),
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Shipment Details Section
                    Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text('Cargo Details',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Description of Goods'),
                                    maxLines: 3,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _marksController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Marks and Numbers'),
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _quantityController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Container Quantity'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _containerSize,
                                    items:
                                        ['20 ft', '40 ft'].map((String size) {
                                      return DropdownMenuItem<String>(
                                        value: size,
                                        child: Text(size),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _containerSize = value!;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Container Size'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _containerCategory,
                                    items: ['General', 'Hazardous', 'Scrap']
                                        .map((String category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(category),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _containerCategory = value!;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Cont. Category'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _weightController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Weight'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _weightUnit,
                                    items: [
                                      'GMS',
                                      'KGS',
                                      'LBS',
                                      'MTS',
                                      'QTL',
                                      'TON'
                                    ].map((String unit) {
                                      return DropdownMenuItem<String>(
                                        value: unit,
                                        child: Text(unit),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _weightUnit = value!;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Units'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _netWeightController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Net Weight'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _volumeController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Volume (CBM)'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _pkgQtyController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Pkg Qty'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _pkgTypeController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Pkg Type'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CheckboxListTile(
                              title: const Text('OBL Surrendered'),
                              value: _oblSurrendered,
                              onChanged: (value) {
                                setState(() {
                                  _oblSurrendered = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _bookedByController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Booked by'),
                                    readOnly: false,
                                  ),
                                ),
                                // IconButton(
                                //   icon: const Icon(Icons.add),
                                //   onPressed: () {
                                //     _showBookedByDialog();
                                //   },
                                // ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    //Booking Confirmation Details
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text('Booking Confirmation Details',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _vesselVoyageController,
                                    decoration: const InputDecoration(
                                      labelText: 'Vessel/Voyage',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectCutOffDate(context),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: _cutOffDateController,
                                        decoration: const InputDecoration(
                                          labelText: 'Cut Off Date',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectCutOffTime(context),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: _cutOffTimeController,
                                        decoration: const InputDecoration(
                                          labelText: 'Cut Off Time',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _cfsCartingController,
                                    decoration: const InputDecoration(
                                      labelText: 'CFS Carting Information',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _cfsCartingInfoController,
                              decoration: const InputDecoration(
                                labelText: 'CFS Carting Info Details',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _overseasAgentController,
                                    decoration: const InputDecoration(
                                      labelText: 'Overseas Agent',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _remarkController,
                              decoration: const InputDecoration(
                                labelText: 'Remark',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _chaController,
                                    decoration: const InputDecoration(
                                      labelText: 'CHA',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                // IconButton(
                                //   icon: const Icon(Icons.add),
                                //   onPressed: () => _showChaDialog(context),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    title: const Text('Own Container'),
                                    value: _ownContainer,
                                    onChanged: (value) {
                                      setState(() {
                                        _ownContainer = value!;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _carrierController,
                                    decoration: const InputDecoration(
                                      labelText: 'Carrier',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                // IconButton(
                                //   icon: const Icon(Icons.add),
                                //   onPressed: () => _showCarrierDialog(context),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _slotOperatorController,
                                    decoration: const InputDecoration(
                                      labelText: 'Slot Operator',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                // IconButton(
                                //   icon: const Icon(Icons.add),
                                //   onPressed: () =>
                                //       _showSlotOperatorDialog(context),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _transshipmentController,
                                    decoration: const InputDecoration(
                                      labelText: 'Transshipment At',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _releaseOrderController,
                                    decoration: const InputDecoration(
                                      labelText: 'Release Order Advised To',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Submit'),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Generate booking number before saving
      final bookingNumber = await _bookingNumberService.getNextBookingNumber();
      // Collect data from the form
      final bookingData = {
        'bookingNumber': bookingNumber,
        'type': selectedType,
        'isPartBL': isPartBL,
        'pointOfOrigin': pointOfOriginController.text,
        'portOfLoading': portOfLoadingController.text,
        'portOfDischarge': portOfDischargeController.text,
        'finalDestination': finalDestinationController.text,
        'placeOfDelivery': placeOfDeliveryController.text,
        'deliveryType': selectedDeliveryType,
        'shipmentDate': shipmentDate?.toLocal().toString().split(' ')[0],
        'stuffingAt': selectedStuffingAt,
        'freightTerms': selectedFreightTerms,
        'freightCharge': freightChargeController.text,
        'customer': customerController.text,
        'shipper': shipperController.text,
        'consignee': consigneeController.text,
        'notify': notifyController.text,
        'shipperAddress': shipperAddressController.text,
        'consigneeAddress': consigneeAddressController.text,
        'notifyAddress': notifyAddressController.text,
        'description': _descriptionController.text,
        'marks': _marksController.text,
        'quantity': _quantityController.text,
        'containerSize': _containerSize,
        'containerCategory': _containerCategory,
        'weight': _weightController.text,
        'weightUnit': _weightUnit,
        'netWeight': _netWeightController.text,
        'volume': _volumeController.text,
        'pkgQty': _pkgQtyController.text,
        'pkgType': _pkgTypeController.text,
        'oblSurrendered': _oblSurrendered,
        'bookedBy': _bookedByController.text,
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
      };

      // Print or send the data to a backend
     // print(bookingData);

      // Example: Save data to Firestore (make sure you have the correct Firestore setup)
      FirebaseFirestore.instance
          .collection('bookings')
          .add(bookingData)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking Submitted')),
        );
        // Optionally, navigate to another page or clear the form
        Navigator.pushReplacementNamed(context, '/allbookingspage');
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit booking: $error')),
        );
      });
    }
  }

  Future<Map<String, String>?> _showShipperDialog() {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        String shipperName = '';
        String shipperAddress = '';
        return AlertDialog(
          title: const Text('New Shipper'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Shipper'),
                onChanged: (value) {
                  shipperName = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 3,
                onChanged: (value) {
                  shipperAddress = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _shipperSubmit(shipperName, shipperAddress);
                Navigator.of(context)
                    .pop({'name': shipperName, 'address': shipperAddress});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, String>?> _showShipperSearchDialog() async {
    final shippers = await _fetchShippers();
    String query = '';
    List<Map<String, String>> filteredShippers = shippers;

    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (_, constrains) => AlertDialog(
            title: const Text('Select Shipper'),
            content: SizedBox(
              width: constrains.maxWidth * .8,
              height: constrains.maxHeight * .8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Search Shipper'),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                        filteredShippers = shippers
                            .where((shipper) => shipper['name']!
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredShippers.length,
                        itemBuilder: (context, index) {
                          final shipper = filteredShippers[index];
                          return ListTile(
                            title: Text(shipper['name']!),
                            subtitle: Text(shipper['address']!),
                            onTap: () {
                              Navigator.of(context).pop(shipper);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, String>?> _showConsigneeSearchDialog() async {
    final consignees = await _fetchConsignee();
    String query = '';
    List<Map<String, String>> filteredConsignees = consignees;

    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (_, constrains) => AlertDialog(
            title: const Text('Select Consignee'),
            content: SizedBox(
              width: constrains.maxWidth * .8,
              height: constrains.maxHeight * .8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Search Consignee'),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                        filteredConsignees = consignees
                            .where((consignee) => consignee['name']!
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredConsignees.length,
                        itemBuilder: (context, index) {
                          final consignee = filteredConsignees[index];
                          return ListTile(
                            title: Text(consignee['name']!),
                            subtitle: Text(consignee['address']!),
                            onTap: () {
                              Navigator.of(context).pop(consignee);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, String>?> _showNotifySearchDialog() async {
    final notifies = await _fetchNotify();
    String query = '';
    List<Map<String, String>> filterednotifies = notifies;

    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (_, constrains) => AlertDialog(
            title: const Text('Select Consignee'),
            content: SizedBox(
              width: constrains.maxWidth * .8,
              height: constrains.maxHeight * .8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Search Notify'),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                        filterednotifies = notifies
                            .where((notify) => notify['name']!
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filterednotifies.length,
                        itemBuilder: (context, index) {
                          final notify = filterednotifies[index];
                          return ListTile(
                            title: Text(notify['name']!),
                            subtitle: Text(notify['address']!),
                            onTap: () {
                              Navigator.of(context).pop(notify);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, String>?> _showConsigneeDialog() {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        String consigneeName = '';
        String consigneeAddress = '';
        return AlertDialog(
          title: const Text('New Consignee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Consignee'),
                onChanged: (value) {
                  consigneeName = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 3,
                onChanged: (value) {
                  consigneeAddress = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _consigneeSubmit(consigneeName, consigneeAddress);
                Navigator.of(context)
                    .pop({'name': consigneeName, 'address': consigneeAddress});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, String>?> _showNotifyDialog() {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        String notifyName = '';
        String notifyAddress = '';
        return AlertDialog(
          title: const Text('New Notify'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notify'),
                onChanged: (value) {
                  notifyName = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 3,
                onChanged: (value) {
                  notifyAddress = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _notifySubmit(notifyName, notifyAddress);
                Navigator.of(context)
                    .pop({'name': notifyName, 'address': notifyAddress});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _notifySubmit(notifyName, notifyAddress) {
    if (_formKey.currentState!.validate()) {
      final notifyData = {
        'notifyText': notifyName,
        'notifyAddress': notifyAddress
      };
      print(notifyData);
      FirebaseFirestore.instance
          .collection('notifyData')
          .add(notifyData)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Saved')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to data: $error')),
        );
      });
    }
  }

  void _consigneeSubmit(consigneeName, consigneeAddress) {
    if (_formKey.currentState!.validate()) {
      final consigneeData = {
        'consigneeText': consigneeName,
        'consigneeAddress': consigneeAddress
      };
      FirebaseFirestore.instance
          .collection('consigneeData')
          .add(consigneeData)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Saved')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to data: $error')),
        );
      });
    }
  }

  void _shipperSubmit(shipperName, shipperAddress) {
    if (_formKey.currentState!.validate()) {
      final shipperData = {
        'shipperText': shipperName,
        'shipperAddress': shipperAddress
      };
      FirebaseFirestore.instance
          .collection('shipperData')
          .add(shipperData)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Saved')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to data: $error')),
        );
      });
    }
  }

  void _showCustomerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (_, constrains) => AlertDialog(
            title: const Text('New Customer'),
            content: SizedBox(
              width: constrains.maxWidth * .5,
              height: constrains.maxHeight * .9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: emailIdController,
                      decoration: const InputDecoration(labelText: 'Email ID'),
                    ),
                    TextFormField(
                      controller: companyController,
                      decoration: const InputDecoration(labelText: 'Company'),
                    ),
                    TextFormField(
                      controller: ledgerController,
                      decoration: const InputDecoration(labelText: 'Ledger'),
                    ),
                    TextFormField(
                      controller: ledgerGroupController,
                      decoration:
                          const InputDecoration(labelText: 'Ledger Group'),
                    ),
                    TextFormField(
                      controller: address1Controller,
                      decoration: const InputDecoration(labelText: 'Address1'),
                    ),
                    TextFormField(
                      controller: address2Controller,
                      decoration: const InputDecoration(labelText: 'Address2'),
                    ),
                    TextFormField(
                      controller: cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                    TextFormField(
                      controller: panNumberController,
                      decoration: const InputDecoration(labelText: 'Pan No'),
                    ),
                    TextFormField(
                      controller: tanNumberController,
                      decoration: const InputDecoration(labelText: 'TAN No'),
                    ),
                    TextFormField(
                      controller: zipcodeController,
                      decoration: const InputDecoration(labelText: 'Zip Code'),
                    ),
                    TextFormField(
                      controller: gstNumberController,
                      decoration: const InputDecoration(labelText: 'GST No'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Handle saving the new customer
                  if (_formKey.currentState!.validate()) {
                    final customerData = {
                      'emailId': emailIdController.text,
                      'company': companyController.text,
                      'ledger': ledgerController.text,
                      'ledgerGroup': ledgerGroupController.text,
                      'address1': address1Controller.text,
                      'address2': address2Controller.text,
                      'city': cityController.text,
                      'panNo': panNumberController.text,
                      'tanNo': tanNumberController.text,
                      'zipcode': zipcodeController.text,
                      'gstNo': gstNumberController.text
                    };
                    FirebaseFirestore.instance
                        .collection('customerData')
                        .add(customerData)
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Customer Data Saved')),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Failed to save customer data: $error')),
                      );
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBookedByDialog() {
    final seNameController = TextEditingController();
    final remarksController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: seNameController,
                decoration: const InputDecoration(labelText: 'SE Name'),
              ),
              TextField(
                controller: remarksController,
                decoration: const InputDecoration(labelText: 'Remarks'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('bookedBy').add({
                  'seName': seNameController.text,
                  'remarks': remarksController.text,
                }).then((value) {
                  setState(() {
                    _bookedByController.text = seNameController.text;
                  });
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Save'),
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
          title: const Text('New Carrier'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _carrierController,
                decoration: const InputDecoration(
                  labelText: 'Carrier',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _carrierAddressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _carrierPanController,
                decoration: const InputDecoration(
                  labelText: 'PAN No',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('carriers').add({
                  'carrier': _carrierController.text,
                  'address': _carrierAddressController.text,
                  'pan': _carrierPanController.text,
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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
              onPressed: () async {
                await FirebaseFirestore.instance.collection('chas').add({
                  'cha': _chaController.text,
                  'address': _chaAddressController.text,
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
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('slotOperators')
                    .add({
                  'slotOperator': _slotOperatorController.text,
                  'address': _slotOperatorAddressController.text,
                  'attention': _slotOperatorAttentionController.text,
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
