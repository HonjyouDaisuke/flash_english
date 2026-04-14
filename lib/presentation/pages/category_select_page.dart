import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategorySelectPage extends StatelessWidget {
  const CategorySelectPage({super.key});

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
                    context.push('/training/category/unit?categoryId=1');
                  },
                  child: const Text('中学１年生レベル'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('中学2年生レベル'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push('/training/shuffle');
                  },
                  child: const Text('シャッフル'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
