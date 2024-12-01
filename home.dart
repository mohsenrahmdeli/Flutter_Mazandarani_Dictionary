import 'package:flutter/material.dart';
import 'db_Helper.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<WordModel> _searchResults = [];
  bool _noResults = false;

  void _searchWords(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _noResults = false;
      });
      return;
    }

    final results = await DatabaseHelper().searchWords(query);
    setState(() {
      _searchResults = results;
      _noResults = results.isEmpty; // اگر نتایجی وجود ندارد، پرچم تنظیم می‌شود
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dictionary')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textDirection: TextDirection.rtl,
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'جستجو',
                border: OutlineInputBorder(),
              ),
              onChanged: _searchWords, // جستجو با هر تغییر در متن
            ),
          ),
          Expanded(
            child: _noResults
                ? const Center(child: Text('نتیجه‌ای یافت نشد'))
                : ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey, // خط جداکننده بین آیتم‌ها
                      thickness: 1,
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final word = _searchResults[index];
                      return ListTile(
                        title: Align(
                            alignment: Alignment.centerRight,
                            child: Text(word.word)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'تلفظ : ${word.read}',
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              'معنی : ${word.mean}',
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
