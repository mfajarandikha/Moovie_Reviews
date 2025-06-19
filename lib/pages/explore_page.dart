import 'package:flutter/material.dart';
import 'genre_result_page.dart';

const genres = [
  {'id': 28, 'name': 'Action'},
  {'id': 35, 'name': 'Comedy'},
  {'id': 18, 'name': 'Drama'},
  {'id': 27, 'name': 'Horror'},
  {'id': 10749, 'name': 'Romance'},
  {'id': 16, 'name': 'Animation'},
  {'id': 878, 'name': 'Science Fiction'},
];

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filteredGenres = genres.where((genre) {
      return genre['name'].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Explore', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search genre...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[850],
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => query = value);
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.4,
                    children: filteredGenres.map((genre) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FilteredResultPage(
                                genreId: genre['id'] as int,
                                title: genre['name'] as String,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          genre['name'] as String,
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],

            ),

          ],
        ),
      ),
    );
  }
}
