import 'package:flash_english/domain/entities/unit.dart';
import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/presentation/providers/get_unit_score_usecase_provider.dart';
import 'package:flash_english/presentation/providers/get_units_usecase_provider.dart';
import 'package:flash_english/presentation/widgets/unit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitSelectPage extends ConsumerWidget {
  final int categoryId;
  final units = List.generate(10, (index) => index + 1);
  UnitSelectPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreUseCase = ref.watch(getUnitScoreUseCaseProvider);
    final unitUseCase = ref.watch(getUnitsUseCaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ユニット選択')),
      body: FutureBuilder(
          future: Future.wait(
              [unitUseCase(categoryId), scoreUseCase.getAllAPI(categoryId)]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final units = snapshot.data![0] as List<Unit>;
            final scores = snapshot.data![1] as List<UnitScore>;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: units.length,
              itemBuilder: (context, index) {
                final unit = units[index];
                // unitId に一致するスコアを探す
                final unitScore =
                    scores.where((e) => e.unitId == unit.unitId).isNotEmpty
                        ? scores.firstWhere((e) => e.unitId == unit.unitId)
                        : null;
                int stars = unitScore == null ? 0 : unitScore.stars;
                String achievedAt =
                    unitScore == null ? "-" : unitScore.achievedAt;
                return UnitCard(
                  categoryId: categoryId,
                  unitId: unit.unitId,
                  unitName: unit.unitName,
                  unitDesc: unit.unitDescription,
                  stars: stars,
                  dateText: achievedAt,
                );
              },
            );
          }),
    );
  }
}
