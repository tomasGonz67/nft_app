import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/web3dart.dart';
import 'package:audioplayers/audioplayers.dart'; // Import for audio playback
import 'package:path_provider/path_provider.dart'; // Import for file saving
import 'dart:typed_data';
import 'dart:io'; // Import for File class
import 'web3.dart'; // Make sure this points to your web3.dart file
import 'ibm_watson_service.dart'; // Import the IBM Watson service

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(), // Updated to show both screens
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('NFT Minting & Text-to-Speech'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Mint NFT'),
              Tab(text: 'Text-to-Speech'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MintNFTScreen(),
            TextToSpeechScreen(),
          ],
        ),
      ),
    );
  }
}

class MintNFTScreen extends StatefulWidget {
  @override
  _MintNFTScreenState createState() => _MintNFTScreenState();
}

class _MintNFTScreenState extends State<MintNFTScreen> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController(); // Controller for amount
  late Web3Service _web3Service;
  final String rpcUrl = "https://sepolia.infura.io/v3/5d7babfd42864f0ba6a7eb3f8005e7c8";
  final String privateKey = dotenv.env['PRIVATE_KEY'] ?? '';
  final String contractAddress = "0xE968381315b2F9Ba1F9336702151DD0bcc24F3e7";

  @override
  void initState() {
    super.initState();
    _web3Service = Web3Service(rpcUrl, privateKey);
  }

  void _mintNFT() async {
    final address = EthereumAddress.fromHex(_addressController.text);
    final amount = BigInt.parse(_amountController.text); // Convert amount from text

    try {
      final result = await _web3Service.mintNFT(contractAddress, address, amount);
      print("Minting transaction hash: $result");
    } catch (e) {
      print("Error minting NFT: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mint NFT')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Recipient Address',
              ),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _mintNFT,
              child: Text('Mint NFT'),
            ),
          ],
        ),
      ),
    );
  }
}

class TextToSpeechScreen extends StatefulWidget {
  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final _textController = TextEditingController();
  final IBMWatsonService _ibmWatsonService = IBMWatsonService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _convertTextToSpeech() async {
    final text = _textController.text;
    try {
      final response = await _ibmWatsonService.synthesizeSpeech(text);
      final Uint8List audioData = response.bodyBytes;

      // Play the audio data
      await _audioPlayer.playBytes(audioData);
      print('Audio data received and playing.');

      // Optionally, save the audio data
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/output.mp3';
      final file = File(filePath);
      await file.writeAsBytes(audioData);
      print('Audio file saved to $filePath.');
    } catch (e) {
      print("Error getting speech: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('IBM Watson Text-to-Speech')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter text to convert to speech',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertTextToSpeech,
              child: Text('Convert Text to Speech'),
            ),
          ],
        ),
      ),
    );
  }
}
