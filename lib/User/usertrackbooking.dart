import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/User/payemettype.dart';
import 'package:loginrace/User/statustrackbooking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTrackBooking extends StatefulWidget {
  String rt_id;
  var level1;
   UserTrackBooking({Key? key, required this. rt_id, required this. level1, }) : super(key: key);

  @override
  State<UserTrackBooking> createState() => _UserTrackBookingState();
}

class _UserTrackBookingState extends State<UserTrackBooking> {
  var name = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var place = TextEditingController();
  var paymentOption = 'Google Pay'; 
  // Default payment option
  bool isBookingSubmitted = false;

  final _formKey = GlobalKey<FormState>();
 @override
  void initState() {
    super.initState();
    // Retrieve user details from SharedPreferences and set them as initial values
    getUserDetails();
    // Check if the user has already booked the track
    checkBookingStatus();
  }

  void getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name.text = prefs.getString('name') ?? '';
      email.text = prefs.getString('email') ?? '';
      phone.text = prefs.getString('phone') ?? '';
      place.text = prefs.getString('place') ?? '';
    });
  }

  void checkBookingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('uid');

    // Query Firestore to check if the user has already booked the track
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user_track_booking')
        .where('userid', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // User has already booked the track
      setState(() {
        isBookingSubmitted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Track Booking'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_motorsports,
                      size: 64,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Join the Adventure!',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 20),
                    buildTextFieldRow('Name', Icons.person, name, (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    }),
                    buildTextFieldRow('Email', Icons.email, email, (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    }),
                    buildTextFieldRow('phone', Icons.phone, phone, (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    }),
                    buildTextFieldRow('place', Icons.place, place, (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    }),
                    SizedBox(height: 20),
                    buildPaymentDropdown(),
                    SizedBox(height: 20),
                    if (!isBookingSubmitted) // Render the submit button if booking is not yet submitted
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Form is validated, proceed to save data to Firestore
                            try {
                              SharedPreferences sp = await SharedPreferences.getInstance();
                              var userid = sp.getString('uid');

                              await FirebaseFirestore.instance.collection('user_track_booking').add({
                                'name': name.text,
                                'email': email.text,
                                'phone': phone.text,
                                'place': place.text,
                                'payment_option': paymentOption,
                                'status': '0',
                                'rt_id': widget.rt_id,
                                'userid': userid,
                              });

                              // Data saved successfully, update the state to show status button
                              setState(() {
                                isBookingSubmitted = true;
                              });
                            } catch (e) {
                              // Error occurred while saving data
                              print('Error saving data: $e');
                              // Handle error appropriately, e.g., show an error dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Failed to save data. Please try again later.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close dialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text('Submit', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    if (isBookingSubmitted) // Render the status button if booking is submitted
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StatusTrack()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text('View Status', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldRow(String label, IconData icon, TextEditingController controller, String? Function(String?)? validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          TextFormField(
            controller: controller,
            validator: validator,
            onChanged: (value) {
              // Update the corresponding text field value as user types
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Enter your $label',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.payment, color: Colors.blue),
            SizedBox(width: 10),
            Text(
              'Payment Option',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: paymentOption,
          onChanged: (String? newValue) {
            setState(() {
              paymentOption = newValue!;
            });
          },
          items: <String>['Google Pay', 'Credit Card', 'PayPal']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}