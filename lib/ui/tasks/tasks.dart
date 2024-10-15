import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Tasks', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/fcm_logo.png'),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '3 Tasks',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  buildNoteCard(
                    title: "123456",
                    color: Colors.blue.shade100,
                    icon: Icons.work_outline, 
                    region: 'Greater Accra',
                     branchName: 'Accra Regional HQ', 
                     customer: 'GCB', 
                     siteId: '9733723',
                    dateAssigned: '14-09-2024', 
                    dateReceived: '10-10-2024',
                  ),
                  buildNoteCard(
                    title: "654321",
                    color: Colors.yellow.shade100,
                    icon: Icons.design_services_outlined,
                    region: 'Ashanti Region',
                    branchName: 'Kumasi', 
                     customer: 'Rent Control', 
                     siteId: '8362739',
                    dateAssigned: '14-09-2024', 
                    dateReceived: '10-10-2024',
                  ),
                  buildNoteCard(
                    title: "321456",
                    color: Colors.purple.shade100,
                    icon: Icons.task_alt_outlined,
                    region: 'Central Region',
                    branchName: 'Ayensu', 
                     customer: 'NHIA', 
                     siteId: '1246278',
                    dateAssigned: '14-09-2024', 
                    dateReceived: '10-10-2024',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNoteCard({
    required String title,
    required String region,
    required String branchName,
    required String customer,
    required String siteId,
    required String dateAssigned,
    required String dateReceived,
    required Color color,
    required IconData icon,
  }) {
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
                  // Text(
                  //   description,
                  //   style: const TextStyle(color: Colors.black54, fontSize: 14),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
