import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/presentation/providers/get_unit_score_usecase_provider.dart';
import 'package:flash_english/presentation/widgets/unit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitSelectPage extends ConsumerWidget {
  final int categoryId;
  final units = List.generate(10, (index) => index + 1);
  UnitSelectPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useCase = ref.watch(getUnitScoreUseCaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ユニット選択')),
      body: FutureBuilder<List<UnitScore>?>(
          future: useCase.getAllAPI(categoryId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final scores = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // ← 横5列
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: units.length,
              itemBuilder: (context, index) {
                final unitId = units[index];
                // unitId に一致するスコアを探す
                final unitScore =
                    scores.where((e) => e.unitId == unitId).isNotEmpty
                        ? scores.firstWhere((e) => e.unitId == unitId)
                        : null;
                int stars = unitScore == null ? 0 : unitScore.stars;
                String achievedAt =
                    unitScore == null ? "-" : unitScore.achievedAt;
                return UnitCard(
                  categoryId: categoryId,
                  unitId: unitId,
                  stars: stars,
                  dateText: achievedAt,
                );
              },
            );
          }),
    );
  }
}
