import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'web3.dart'; // Make sure this points to your web3.dart file

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MintNFTScreen(),
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