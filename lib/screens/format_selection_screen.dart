import 'package:flutter/material.dart';
import '../models/barcode_format.dart';
import '../log/log_wrapper.dart';

class FormatSelectionScreen extends StatefulWidget {
  final BarcodeFormatData currentFormat;
  final Function(BarcodeFormatData) onFormatSelected;

  const FormatSelectionScreen({
    super.key,
    required this.currentFormat,
    required this.onFormatSelected,
  });

  @override
  State<FormatSelectionScreen> createState() => _FormatSelectionScreenState();
}

class _FormatSelectionScreenState extends State<FormatSelectionScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<String> get _categories => ['All', ...BarcodeFormats.categories];

  List<BarcodeFormatData> get _filteredFormats {
    List<BarcodeFormatData> formats = BarcodeFormats.allFormats;

    // Filter by category
    if (_selectedCategory != 'All') {
      formats = formats.where((f) => f.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      formats = formats.where((f) => 
        f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        f.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return formats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Barcode Format'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Search and filter section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search field
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search formats...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                // Category filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Format list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFormats.length,
              itemBuilder: (context, index) {
                final format = _filteredFormats[index];
                final isSelected = format.format == widget.currentFormat.format;
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected 
                          ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                          : null,
                      ),
                      child: Icon(
                        _getFormatIcon(format.category),
                        color: isSelected 
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      ),
                    ),
                    title: Text(
                      format.name,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Theme.of(context).primaryColor : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(format.description),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                format.characterType.description,
                                style: const TextStyle(fontSize: 11, color: Colors.blue),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                format.lengthInfo,
                                style: const TextStyle(fontSize: 11, color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: isSelected 
                      ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                      : const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      logInfo('バーコード形式を選択しました: ${format.name}');
                      widget.onFormatSelected(format);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFormatIcon(String category) {
    switch (category) {
      case '1D Barcodes':
        return Icons.linear_scale;
      case '2D Barcodes':
        return Icons.qr_code;
      case 'GS1 DataBar':
        return Icons.inventory;
      default:
        return Icons.barcode_reader;
    }
  }
}