import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC2079B4JR68lVU6hdCf14in24Y3sZRhhQ",
      appId: "1:884773953282:android:50714ed944162c0249ec1b",
      messagingSenderId: "884773953282",
      projectId: "deaf-and-mute",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FeedbackScreen(),
    );
  }
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);
  static const String routeName = 'feedback-screen';

  @override
  // ignore: library_private_types_in_public_api
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  String _feedbackType = '';
  late String _feedbackText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'How was your experience?',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildEmojiButton('😊'),
                  _buildEmojiButton('😢'),
                  _buildEmojiButton('😐'),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 6,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Describe your feedback here',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please describe your feedback';
                  }
                  return null;
                },
                onSaved: (value) => _feedbackText = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitFeedback();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 196, 9, 21),
                  minimumSize: const Size(220, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: const Text(
                  'Send Feedback',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitFeedback() async {
    try {
      final collection = FirebaseFirestore.instance.collection('feedback');
      await collection.add({
        'type': _feedbackType,
        'text': _feedbackText,
        'timestamp': DateTime.now(),
      });
      if (kDebugMode) {
        print('Feedback submitted successfully!');
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully!'),
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        print('Failed to submit feedback: $error');
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit feedback'),
        ),
      );
    }
  }

  Widget _buildEmojiButton(String emoji) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _feedbackType = emoji;
        });
      },
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 44),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}