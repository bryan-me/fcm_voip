import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/filter_controller.dart';


class FilterBottomSheet extends StatelessWidget {
  final FilterController _controller = Get.put(FilterController());

  FilterBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Category Filter
          const Text(
            'Category',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Obx(() {
            return DropdownButton<String>(
              isExpanded: true,
              value: _controller.selectedCategory.value.isNotEmpty
                  ? _controller.selectedCategory.value
                  : null,
              hint: const Text('Select a category'),
              items: _controller.categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                _controller.selectedCategory.value = value ?? '';
              },
            );
          }),
          const SizedBox(height: 16),

          // State Filter
          const Text(
            'State',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Obx(() {
            return DropdownButton<String>(
              isExpanded: true,
              value: _controller.selectedState.value.isNotEmpty
                  ? _controller.selectedState.value
                  : null,
              hint: const Text('Select a state'),
              items: _controller.states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                _controller.selectedState.value = value ?? '';
              },
            );
          }),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Clear Filters
              TextButton(
                onPressed: () {
                  _controller.clearFilters();
                },
                child: const Text(
                  'Clear Filters',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              // Apply Filters
              ElevatedButton(
                onPressed: () {
                  // Apply filters and close the bottom sheet
                  Navigator.pop(context);
                  // You can call a method here to filter your data
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Function to display the filter bottom sheet
void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => FilterBottomSheet(),
  );
}