import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'order_detailed_screen_active.dart';

class DriverCard extends StatelessWidget {
  final String driverName;
  final String driverImage;
  final VoidCallback onCallPressed;

  const DriverCard({
    Key? key,
    required this.driverName,
    required this.driverImage,
    required this.onCallPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(driverImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driverName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Tu conductor',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onCallPressed,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigo.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.phone,
                    color: Colors.indigo,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// You might also want to add this extension for better error handling
extension DriverCardErrorHandler on DriverCard {
  Widget withErrorHandler() {
    return ErrorBoundary(
      child: this,
      fallback: (error, stackTrace) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[600]),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error loading driver information',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}