import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFEAC5),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              SystemNavigator.pop();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: Image.asset(
                'assets/images/exit.png',
              ),
            ),
          ),
          shadowColor: Colors.redAccent,
          surfaceTintColor: Colors.redAccent,
          backgroundColor: const Color(0xFFFFDBB5),
          title: const Text(
            'مترجم مازِرونی',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Maryam',
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
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
                      focusColor: Colors.red,
                      hintText: 'لطفا حرف یا کلمه مورد نظر را بنویسید',
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: const TextStyle(
                        color: Colors.black38,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
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
                                width: 250,
                                height: 250,
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
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            indent: 5,
                            endIndent: 5,
                            color: Colors.white,
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
                                    fontFamily: 'Yekan',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        word.read,
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'Yekan',
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'تلفظ : ',
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'Yekan',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    'معنی : ${word.mean}',
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Yekan',
                                      fontSize: 12,
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
      ),
    );
  }
}
