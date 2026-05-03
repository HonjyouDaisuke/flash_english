import 'package:flash_english/presentation/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategorySelectPage extends ConsumerWidget {
  const CategorySelectPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final categoriesAsync = ref.watch(
      categoriesProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'カテゴリー選択',
        ),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (
          error,
          stack,
        ) =>
            Center(
          child: Text(
            'エラー: $error',
          ),
        ),
        data: (categories) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categories.map(
                (category) {
                  return Padding(
                    padding: const EdgeInsets.all(
                      8,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(
                          '/training/category/unit?categoryId=${category.categoryNo}',
                        );
                      },
                      child: Text(
                        category.categoryName,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          );
        },
      ),
    );
  }
}
