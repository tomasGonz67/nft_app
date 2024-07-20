import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Scaffold(
    appBar:AppBar(
      title:Text('My NFT App'),
      centerTitle:true,
    ),
    body: Center(
      child:Text('Welcome to my NFT App '),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child:Text('To Market Place')
        ),
  ),

));

