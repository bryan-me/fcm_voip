import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String region;
  final String branchName;
  final String customer;
  final String siteId;
  final String dateAssigned;
  final String dateReceived;
  final Color color;
  final IconData icon;

  const NoteCard({
    Key? key,
    required this.title,
    required this.region,
    required this.branchName,
    required this.customer,
    required this.siteId,
    required this.dateAssigned,
    required this.dateReceived,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: Colors.black),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            region,
                            style: const TextStyle(color: Colors.black45),
                          ),
                          Text(
                            branchName,
                            style: const TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            customer,
                            style: const TextStyle(color: Colors.black45),
                          ),
                          Text(
                            siteId,
                            style: const TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dateAssigned,
                            style: const TextStyle(color: Colors.black45),
                          ),
                          Text(
                            dateReceived,
                            style: const TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}