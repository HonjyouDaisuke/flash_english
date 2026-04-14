import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnitSelectPage extends StatelessWidget {
  final int categoryId;
  final units = List.generate(10, (index) => index + 1);
  UnitSelectPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ユニット選択')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // ← 横5列
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3.0,
        ),
        itemCount: units.length,
        itemBuilder: (context, index) {
          final unitId = units[index];

          return InkWell(
            onTap: () {
              context.push(
                '/training/category/unit/training?categoryId=$categoryId&unitId=$unitId',
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Center(
                child: Text(
                  'ユニット$unitId',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
