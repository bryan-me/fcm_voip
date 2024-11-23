import 'package:flutter/material.dart';
import '../../controllers/base_data_controller.dart';
import '../../data/model/base_data.dart';
import '../../services/auth_service.dart';
import '../utilities/form.dart';
import '../utilities/note_card.dart';

class FilteredScreen extends StatefulWidget {
  final String type;

  const FilteredScreen({required this.type});

  @override
  _FilteredScreenState createState() => _FilteredScreenState();
}

class _FilteredScreenState extends State<FilteredScreen> {
  late Future<List<BaseData>> _filteredDataFuture;
  late BaseDataController _baseDataController;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _baseDataController = BaseDataController(
      baseUrl: 'http://192.168.250.209:8060/api/v1/activity-service',
      authService: _authService,
    );

    _filteredDataFuture = _initializeFilteredData();
  }

  Future<List<BaseData>> _initializeFilteredData() async {
    try {
      final currentUserId = await _authService.getCurrentUserId();
      if (currentUserId == null) {
        throw Exception('No user ID found. Please log in again.');
      }
      final allData = await _baseDataController.fetchBaseData(currentUserId);
      return allData.where((data) => data.taskType == widget.type).toList();
    } catch (error) {
      throw Exception('Error fetching ${widget.type}s: $error');
    }
  }

  void showFilterBottomSheet(BuildContext context) {
    // Implement the filter modal functionality as needed.
    showModalBottomSheet(
      context: context,
      builder: (context) => const Center(child: Text('Filter options')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('${widget.type}s', style: const TextStyle(color: Colors.black)),
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
            onPressed: () {
              showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<BaseData>>(
              future: _filteredDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final filteredData = snapshot.data!;
                  int count = filteredData.length;
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$count ${widget.type}${count == 1 ? '' : 's'}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final data = filteredData[index];
                              return GestureDetector(
                                onTap: () {
                                  // Navigate to the detailed view
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FormBuild(formId: data.id),
                                    ),
                                  );
                                },
                                child: NoteCard(
                                  title: data.title ?? 'Title',
                                  region: data.client ?? 'Unknown region',
                                  branchName: data.project ?? 'Unknown branch',
                                  customer: data.client ?? 'Unknown customer',
                                  siteId: data.siteId ?? 'N/A',
                                  dateAssigned: data.dateAssigned != null
                                      ? data.dateAssigned.toString()
                                      : 'N/A',
                                  dateReceived: data.dateReceived != null
                                      ? data.dateReceived.toString()
                                      : 'N/A',
                                  color: Colors.blue.shade100,
                                  icon: Icons.camera_alt_sharp,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('No data found.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}