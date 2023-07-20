import 'dart:io';
import 'dart:typed_data';
import 'main.dart';
import 'photo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'convert_utility.dart';
import 'dbManager.dart';

class detailBook extends StatefulWidget {
  final int id;

  detailBook({Key? key, required this.id}) : super(key: key);

  @override
  State<detailBook> createState() => _detailBookState();
}

class _detailBookState extends State<detailBook> {
  Photo? photo;
  late dbManager dbmanager;

  @override
  void initState() {
    super.initState();
    dbmanager = dbManager();
    dbmanager.getPhoto(widget.id).then((photo) {
      setState(() {
        this.photo = photo;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles del libro"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (photo != null) ...[
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (photo != null) ...[
                        Container(
                          width: 300,
                          height: 420,
                          child:
                              Utility.ImageFromBase64String(photo!.photo_name!),
                        ),
                        Text("Nombre: " + photo!.name_book!),
                        Text("Autor: " + photo!.author_book!),
                        Text("Editorial: " + photo!.book_publisher!),
                        Text("Año: " + photo!.book_year!),
                      ],
                    ],
                  ),
                ),
              )
            ],
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
