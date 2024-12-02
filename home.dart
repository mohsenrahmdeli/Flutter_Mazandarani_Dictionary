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
      _noResults = results.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 22, 6, 241),
        title: const Text(
          'مترجم مازندرانی',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Titr',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Image.asset(
                'assets/images/2.png',
                width: 150,
                height: 150,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textDirection: TextDirection.rtl,
                  controller: _searchController,
                  decoration: InputDecoration(
                    fillColor: Colors.red,
                    hintText: 'لطفا حرف یا کلمه مورد نظر را بنویسید',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: const TextStyle(color: Colors.black38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onChanged: _searchWords,
                ),
              ),
              Expanded(
                child: _noResults
                    ? Center(
                        child: Column(
                        children: [
                          Image.asset(
                            'assets/images/2.gif',
                            width: 350,
                            height: 350,
                          ),
                          const Text(
                            'نتیجه‌ای یافت نشد',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ))
                    : ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final word = _searchResults[index];
                          return ListTile(
                            title: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'کلمه : ${word.word}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'تلفظ : ${word.read}',
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'معنی : ${word.mean}',
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
