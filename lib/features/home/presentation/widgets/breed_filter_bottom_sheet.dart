import 'package:flutter/material.dart';
import 'package:animals_tasks/core/styling/app_colors.dart';

class BreedFilterBottomSheet extends StatefulWidget {
  final String? selectedBreedGroup;
  final Function(String?) onFilterApplied;

  const BreedFilterBottomSheet({
    super.key,
    this.selectedBreedGroup,
    required this.onFilterApplied,
  });

  @override
  State<BreedFilterBottomSheet> createState() => _BreedFilterBottomSheetState();
}

class _BreedFilterBottomSheetState extends State<BreedFilterBottomSheet> {
  String? _selectedBreedGroup;

  // Common breed groups from The Dog API
  final List<String> _breedGroups = [
    'All',
    'Herding',
    'Hound',
    'Non-Sporting',
    'Sporting',
    'Terrier',
    'Toy',
    'Working',
    'Mixed',
  ];

  @override
  void initState() {
    super.initState();
    _selectedBreedGroup = widget.selectedBreedGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter by Breed Group',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_selectedBreedGroup != null && _selectedBreedGroup != 'All')
                TextButton(
                  onPressed: () {
                    setState(() => _selectedBreedGroup = null);
                  },
                  child: const Text('Clear'),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Breed group list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _breedGroups.length,
              itemBuilder: (context, index) {
                final breedGroup = _breedGroups[index];
                final isSelected = _selectedBreedGroup == breedGroup ||
                    (_selectedBreedGroup == null && breedGroup == 'All');

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(
                    breedGroup,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedBreedGroup = breedGroup == 'All' ? null : breedGroup;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onFilterApplied(_selectedBreedGroup);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
