import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/movie_service.dart';
import '../blocs/movie/movie_bloc.dart';
import 'movie_recommendation_screen.dart';

class MoodSelectionScreen extends StatelessWidget {
  const MoodSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'name': 'Fun', 'image': 'assets/Fun.png'},
      {'name': 'Tensed', 'image': 'assets/Tensed.png'},
      {'name': 'Scared', 'image': 'assets/Scared.png'},
      {'name': 'Nostalgic', 'image': 'assets/Nostalgic.png'},
      {'name': 'Passionate', 'image': 'assets/Passionate.png'},
      {'name': 'Intruiged', 'image': 'assets/Intruiged.png'},
      {'name': 'Angry', 'image': 'assets/Angry.png'},
      {'name': 'Excited', 'image': 'assets/Excited.png'},
      {'name': 'Sad', 'image': 'assets/Sad.png'},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/Logo.png',
                  height: 60,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Choose your mood',
                  style: TextStyle(
                    color: Colors.deepPurple[200],
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: moods.length,
                  itemBuilder: (context, index) {
                    return MoodItem(
                      name: moods[index]['name']!,
                      imagePath: moods[index]['image']!,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => MovieBloc(MovieService()),
                              child: MovieRecommendationScreen(
                                selectedMood: moods[index]['name']!,
                              ),
                            ),
                          ),
                        );
                      },
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

class MoodItem extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback onTap;

  const MoodItem({
    super.key,
    required this.name,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.deepPurple[200]!,
                width: 2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: Colors.deepPurple[200],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
