// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../profile/profile_screen.dart';
import '../user/settings_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
  static const String routeName = 'gallery-screen';
}

class _GalleryScreenState extends State<GalleryScreen> {
    int _selectedIndex = 3;

  List<dynamic> books = [];
  List<dynamic> videos = [];
  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
    fetchVideos();
    fetchMovies();
  }

  Future<void> fetchBooks() async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=sign%20language'));
    if (response.statusCode == 200) {
      setState(() {
        books = json.decode(response.body)['items'];
      });
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> fetchVideos() async {
    const apiKey = 'AIzaSyCWLk9Z-W0Qp3aDZo_5Rk9i-WhU5vaJl44';
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=sign%20language&maxResults=15&key=$apiKey'));
    if (response.statusCode == 200) {
      setState(() {
        videos = json.decode(response.body)['items'];
      });
    } else {
      throw Exception('Failed to load videos');
    }
  }

  Future<void> fetchMovies() async {
    const apiKey = '37704a4f73816464227db09f4bb99bde';
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=sign%20language'));
    if (response.statusCode == 200) {
      final results = json.decode(response.body)['results'];
      // Filter out movies without posters
      final moviesWithPosters =
          results.where((movie) => movie['poster_path'] != null).toList();
      setState(() {
        movies = moviesWithPosters;
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: const Color.fromARGB(255, 144, 29, 29),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  labelColor: const Color.fromARGB(255, 144, 29, 29),
                  unselectedLabelColor: Colors.white,
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Books'),
                    Tab(text: 'Videos'),
                    Tab(text: 'Movies'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildAllPage(),
                    _buildBooksPage(),
                    _buildVideosPage(),
                    _buildMoviesPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color.fromARGB(255, 144, 29, 29),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                label: 'SOS',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.drive_file_move_rounded),
                label: 'Gallery',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: 2,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            onTap: (index) {
               _selectedIndex = index;

             // Check the selected index and navigate accordingly
             switch (_selectedIndex) {
               case 0:
                 // No need to navigate to SettingsScreen here, it will be displayed in the pages list
                 break;
               case 1:
                 Navigator.push(
                   context,
                   MaterialPageRoute(
         builder: (context) => const ProfileScreen(),
                   ),
                 );
                 break;
               case 2:
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => const GalleryScreen(),
                   ),
                 );
                 break;
               case 3:
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => const SettingsScreen(),
                   ),
                 );
                 break;
             }
           }),
        ),
      ),
    );
         }

  Widget _buildAllPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
          ),
          _buildBooksWidget(),
          _buildVideosWidget(),
          _buildMoviesWidget(),
        ],
      ),
    );
  }

  Widget _buildBooksWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Books:',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  final url = books[index]['volumeInfo']['infoLink'];
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          books[index]['volumeInfo']['imageLinks']['thumbnail'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        books[index]['volumeInfo']['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVideosWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Videos:',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.network(
                  videos[index]['snippet']['thumbnails']['default']['url']),
              title: Text(videos[index]['snippet']['title']),
              subtitle: Text(videos[index]['snippet']['description']),
              onTap: () async {
                final videoId = videos[index]['id']['videoId'];
                final url = 'https://www.youtube.com/watch?v=$videoId';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMoviesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Movies:',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.network(
                'https://image.tmdb.org/t/p/w185${movies[index]['poster_path']}',
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
              title: Text(movies[index]['title']),
              subtitle: Text(movies[index]['overview']),
              onTap: () async {
                final movieId = movies[index]['id'];
                final url = 'https://www.themoviedb.org/movie/$movieId';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBooksPage() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            final url = books[index]['volumeInfo']['infoLink'];
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    books[index]['volumeInfo']['imageLinks']['thumbnail'],
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  books[index]['volumeInfo']['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideosPage() {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
              videos[index]['snippet']['thumbnails']['default']['url']),
          title: Text(videos[index]['snippet']['title']),
          subtitle: Text(videos[index]['snippet']['description']),
          onTap: () async {
            final videoId = videos[index]['id']['videoId'];
            final url = 'https://www.youtube.com/watch?v=$videoId';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        );
      },
    );
  }

  Widget _buildMoviesPage() {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
            'https://image.tmdb.org/t/p/w185${movies[index]['poster_path']}',
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
          title: Text(movies[index]['title']),
          subtitle: Text(movies[index]['overview']),
          onTap: () async {
            final movieId = movies[index]['id'];
            final url = 'https://www.themoviedb.org/movie/$movieId';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        );
      },
    );
  }
}