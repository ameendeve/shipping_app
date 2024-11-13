import 'package:cloud_firestore/cloud_firestore.dart';

class BookingNumberService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getNextBookingNumber() async {
    final now = DateTime.now();
    final year = now.year.toString().substring(2, 4); // Get last two digits of the year
    final sequenceRef = _firestore.collection('sequences').doc('booking_number');

    // Generate the booking number inside a transaction to ensure atomicity
    final bookingNumber = await _firestore.runTransaction<String>((transaction) async {
      final snapshot = await transaction.get(sequenceRef);
      int sequenceNumber;
      if (snapshot.exists) {
        sequenceNumber = snapshot.data()!['number'] as int;
      } else {
        sequenceNumber = 0;
      }
      sequenceNumber++;
      transaction.set(sequenceRef, {'number': sequenceNumber});
      return '$year-${sequenceNumber.toString().padLeft(3, '0')}';
    });

    return bookingNumber;
  }
}
