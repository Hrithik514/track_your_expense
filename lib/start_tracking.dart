import 'package:flutter/material.dart';

class StartTrackingPage extends StatelessWidget {
  final String eventKey; // Ensure this is a String
  final Map<String, dynamic> event;

  const StartTrackingPage({
    required this.eventKey,
    required this.event,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            "${event['eventName'] ?? 'Unknown'} - ${event['groupName'] ?? 'Unknown'}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 5.0,
          shadowColor: Colors.black54,
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the color of the back arrow
          ),
        ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [

            Positioned(
              top: 0, // Space below the second Text widget
              left: 0,
              child: ElevatedButton(
                onPressed: () {
                  print('Start tracking for event: $eventKey');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(170, 30), // Set minimum width and height
                  maximumSize: const Size(200, 60), // Optionally set maximum size
                ),
                child: const Text('Add Expense', style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),

            Positioned(
              top: 0, // Space below the second Text widget
              left: 225,
              child: ElevatedButton(
                onPressed: () {
                  print('Start tracking for event: $eventKey');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(170, 30), // Set minimum width and height
                  maximumSize: const Size(200, 60), // Optionally set maximum size
                ),
                child: const Text('View Bill', style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),

          ],
        ),

      ),
    );
  }
}
