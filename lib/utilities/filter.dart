import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/base_data_controller.dart';
import '../controllers/count_controller.dart';
import '../controllers/filter_controller.dart';
import '../services/auth_service.dart';
import '../services/websocket_service.dart';

class FilterOptionsModal extends StatelessWidget {
  const FilterOptionsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize FilterController
    final WebSocketService _webSocketService = WebSocketService('wss://smpp.stlghana.com/connection/websocket');
    final CountController _countController = Get.put(CountController());

    final filterController = Get.put(FilterController());

    // Initialize BaseDataController
    final baseDataController = Get.put(
      BaseDataController(
        baseUrl: 'http://192.168.250.209:8060/api/v1/activity-service',
        authService: AuthService(),
        webSocketService: _webSocketService, // Pass WebSocketService here
      ),
    );

    // Fetch customers dynamically
    // baseDataController.fetchBaseDataByType("customer");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter Options",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1, color: Colors.grey),

          // Customer Filter
          const SizedBox(height: 16),
          Obx(() {
            // if (baseDataController.filteredData.isEmpty) {
            //   return const Center(child: CircularProgressIndicator());
            // }
            return _buildDropdown(
              context,
              title: "Customer",
              value: filterController.selectedCustomer,
              options: baseDataController.filteredData.map((data) => data.client).toList(),
              icon: Icons.person_outline,
            );
          }),

          // Task Number Filter
          const SizedBox(height: 16),
          _buildTextField(
            context,
            title: "Task Number",
            value: filterController.selectedTaskNumber,
            hint: "Task Number",
            icon: Icons.task,
          ),

          // Status Filter
          const SizedBox(height: 16),
          _buildDropdown(
            context,
            title: "Status",
            value: filterController.selectedStatus,
            options: ["Pending", "Completed", "In Progress"],
            icon: Icons.check_circle_outline,
          ),

          // Severity Filter
          const SizedBox(height: 16),
          _buildDropdown(
            context,
            title: "Severity",
            value: filterController.selectedSeverity,
            options: ["High", "Medium", "Low"],
            icon: Icons.priority_high,
          ),

          const SizedBox(height: 24),

          // Apply and Reset Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: filterController.resetFilters,
                  icon: const Icon(Icons.refresh, color: Colors.red),
                  label: const Text("Reset"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Trigger filter application
                    filterController.applyFilters();
                    Navigator.pop(context); // Close the modal
                  },
                  icon: const Icon(Icons.filter_alt),
                  label: const Text("Apply"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Custom Dropdown Builder
  Widget _buildDropdown(
      BuildContext context, {
        required String title,
        required RxString value,
        required List<String> options,
        required IconData icon,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<String>(
          value: value.value.isEmpty ? null : value.value,
          items: options
              .map((option) => DropdownMenuItem(
            value: option,
            child: Text(option),
          ))
              .toList(),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.blue),
            border: const OutlineInputBorder(),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          onChanged: (newValue) {
            value.value = newValue ?? '';
          },
        )),
      ],
    );
  }

  // Custom TextField Builder
  Widget _buildTextField(
      BuildContext context, {
        required String title,
        required RxString value,
        required String hint,
        required IconData icon,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(() => TextField(
          controller: TextEditingController(text: value.value),
          onChanged: (newValue) {
            value.value = newValue;
          },
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.blue),
            border: const OutlineInputBorder(),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        )),
      ],
    );
  }
}