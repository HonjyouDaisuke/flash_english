import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/presentation/providers/unit_scores_provider.dart';
import 'package:flash_english/presentation/providers/units_provider.dart';
import 'package:flash_english/presentation/widgets/unit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitSelectPage extends ConsumerWidget {
  final int categoryNo;
  final units = List.generate(10, (index) => index + 1);
  UnitSelectPage({super.key, required this.categoryNo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitsAsync = ref.watch(unitsProvider(categoryNo));
    final scoresAsync = ref.watch(unitScoresProvider(categoryNo));
    return Scaffold(
      appBar: AppBar(title: const Text('ユニット選択')),
      body: unitsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 40,
              ),
              const SizedBox(height: 8),
              Text('ユニット取得でエラーが発生しました: $error'),
            ],
          ),
        ),
        data: (units) {
          return scoresAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text('スコア取得でエラーが発生しました: $error'),
                ],
              ),
            ),
            data: (scores) {
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
                  final unitScore = scores.cast<UnitScore?>().firstWhere(
                        (e) => e?.unitNo == unit.unitNo,
                        orElse: () => null,
                      );

                  final stars = unitScore?.stars ?? 0;
                  final achievedAt = unitScore?.achievedAt ?? '-';

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
            },
          );
        },
      ),
    );
  }
}
