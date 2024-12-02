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
  bool _isInitialState = true;

  final TextStyle _titleTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontFamily: 'Yekan',
    fontSize: 12,
  );

  final TextStyle _subtitleTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontFamily: 'Yekan',
    fontSize: 18,
  );

  void _showNoResultsDialog() {
    showDialog(
      barrierColor: Colors.redAccent.shade700,
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/2.gif',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 10),
            Text(
              'متاسفانه نتیجه‌ای یافت نشد !!!',
              textDirection: TextDirection.rtl,
              style: _subtitleTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              Navigator.of(context).pop();
            },
            child: const Text(
              'تلاش مجدد',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontFamily: 'Yekan',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _searchWords(String query) async {
    setState(() {
      _isInitialState = query.isEmpty;
    });

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

    if (_noResults) {
      _showNoResultsDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFEAC5),
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                _buildLogo(),
                _buildSearchBar(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isInitialState) {
      return Center(
        child: Text(
          'لطفاً کلمه‌ای برای جستجو وارد کنید',
          style: _subtitleTextStyle,
        ),
      );
    }
    return _buildResults();
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () => SystemNavigator.pop(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Image.asset(
            'assets/images/exit.png',
          ),
        ),
      ),
      shadowColor: Colors.redAccent,
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
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/2.png',
      width: 150,
      height: 150,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textDirection: TextDirection.rtl,
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'لطفا حرف یا کلمه مورد نظر را بنویسید',
          hintTextDirection: TextDirection.rtl,
          hintStyle: const TextStyle(color: Colors.black38),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onChanged: _searchWords,
      ),
    );
  }

  Widget _buildResults() {
    if (_noResults) {
      return const SizedBox();
    }
    return ListView.separated(
      separatorBuilder: (_, __) => const Divider(
        color: Colors.white,
        thickness: 1,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return _buildWordTile(_searchResults[index]);
      },
    );
  }

  Widget _buildWordTile(WordModel word) {
    return ListTile(
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'کلمه : ${word.word}',
          style: _titleTextStyle,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            height: 3.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                word.read,
                style: _subtitleTextStyle,
              ),
              Text(
                'تلفظ : ',
                style: _titleTextStyle,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
          const SizedBox(
            height: 3.0,
          ),
          Text(
            'معنی : ${word.mean}',
            style: _titleTextStyle,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
