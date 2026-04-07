import 'package:flash_english/presentation/pages/training_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnitSelectPage extends StatelessWidget {
  final int categoryId;
  const UnitSelectPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Text('ユニット選択')),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.push(
                        '/training/category/unit/training?categoryId=1&unitId=1');
                  },
                  child: const Text('ユニット1'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('ユニット2'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('ユニット3'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
