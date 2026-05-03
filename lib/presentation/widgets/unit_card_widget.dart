import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnitCard extends StatelessWidget {
  final int categoryNo;
  final int unitNo;
  final String unitName;
  final String unitDesc;
  final int stars;
  final String dateText;

  const UnitCard({
    super.key,
    required this.categoryNo,
    required this.unitNo,
    required this.unitName,
    required this.unitDesc,
    required this.stars,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          '/training/category/unit/training?categoryNo=$categoryNo&unitNo=$unitNo',
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                unitName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final star = stars;
                  return Icon(
                    i < star ? Icons.star : Icons.star_border,
                    color: i < star ? Colors.amber : Colors.grey,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 6),
              Text(
                dateText,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
