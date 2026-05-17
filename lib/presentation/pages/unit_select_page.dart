import 'package:flash_english/domain/entities/unit.dart';
import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/presentation/providers/get_unit_score_usecase_provider.dart';
import 'package:flash_english/presentation/providers/get_units_usecase_provider.dart';
import 'package:flash_english/presentation/widgets/unit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitSelectPage extends ConsumerWidget {
  final int categoryNo;
  final units = List.generate(10, (index) => index + 1);
  UnitSelectPage({super.key, required this.categoryNo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreUseCase = ref.watch(getUnitScoreUseCaseProvider);
    final unitUseCase = ref.watch(getUnitsUseCaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ユニット選択')),
      body: FutureBuilder(
          future: Future.wait(
              [unitUseCase(categoryNo), scoreUseCase.getAllAPI(categoryNo)]),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(height: 8),
                    Text('エラーが発生しました: ${snapshot.error}'),
                  ],
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final units = snapshot.data![0] as List<Unit>;
            final scores = (snapshot.data![1] as List<UnitScore>?) ?? [];

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
                // unitNo に一致するスコアを探す
                final unitScore =
                    scores.where((e) => e.unitNo == unit.unitNo).isNotEmpty
                        ? scores.firstWhere((e) => e.unitNo == unit.unitNo)
                        : null;
                int stars = unitScore == null ? 0 : unitScore.stars;
                String achievedAt =
                    unitScore == null ? "-" : unitScore.achievedAt;
                return UnitCard(
                  categoryNo: categoryNo,
                  unitNo: unit.unitNo,
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
