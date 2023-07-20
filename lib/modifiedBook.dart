import 'dart:io';
import 'dart:typed_data';
import 'main.dart';
import 'photo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'convert_utility.dart';
import 'dbManager.dart';

class modifiedBook extends StatefulWidget {
  final int? id;

  const modifiedBook({Key? key, this.id}) : super(key: key);

  @override
  State<modifiedBook> createState() => _modifiedBookState();
}

class _modifiedBookState extends State<modifiedBook> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPublisher = TextEditingController();
  TextEditingController controllerYear = TextEditingController();
  TextEditingController controllerAuthor = TextEditingController();

  Photo? photo;
  late dbManager dbmanager;
  late Future<File> imageFile;
  late Image image;
  late int? selectedId = null;

  final RegExp dataExp = RegExp('[a-zA-Z]');
  final RegExp yearExp = RegExp('[0-9]');

  String? name_book = '';
  String? book_publisher = '';
  String? book_year = '';
  String? author_book = '';

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late var dbHelper;
  late bool isUpdating;

  File? _image;

  @override
  void initState() {
    super.initState();
    dbmanager = dbManager();
    if (widget.id != null) {
      dbmanager.getPhoto(widget.id!).then((photo) {
        setState(() {
          controllerName.text = photo.name_book!;
          controllerAuthor.text = photo.author_book!;
          controllerPublisher.text = photo.book_publisher!;
          controllerYear.text = photo.book_year!;
          this.photo = photo;
        });
      });
    }
  }

  updateBook() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (widget.id != null && _image != null) {
        String imgString = Utility.base64String(_image!.readAsBytesSync());
        Photo photo = Photo(widget.id, imgString, name_book, author_book,
            book_publisher, book_year);
        dbmanager.update(photo);
      } else {
        _showSnackBar(context, "Agregue una imagen");
      }
      clearData();
    }
  }

  clearData() {
    controllerName.text = "";
    controllerPublisher.text = "";
    controllerYear.text = "";
    controllerAuthor.text = "";
    _image = null;
  }

  pickImageFromGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.gallery).then((imgFile) async {
      if (imgFile != null) {
        setState(() {
          _image = File(imgFile.path);
        });
        Uint8List? imageBytes = await imgFile.readAsBytes();
      }
    });
  }

  Widget form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            TextFormField(
              controller: controllerName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (val1) => val1!.isEmpty
                  ? 'Ingrese el nombre'
                  : dataExp.hasMatch(val1!) == false
                      ? "Solo se aceptan letras"
                      : null,
              onSaved: (val1) => name_book = val1!,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controllerAuthor,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Autor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (val2) => val2!.isEmpty
                  ? 'Ingrese el autor'
                  : dataExp.hasMatch(val2!) == false
                      ? "Solo se aceptan letras"
                      : null,
              onSaved: (val2) => author_book = val2!,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controllerPublisher,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Editorial',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (val3) => val3!.isEmpty
                  ? 'Ingrese la editorial'
                  : dataExp.hasMatch(val3!) == false
                      ? "Solo se acpetan letras"
                      : null,
              onSaved: (val3) => book_publisher = val3!,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controllerYear,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Año de edición',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (val4) => val4!.isEmpty
                  ? 'Ingrese el año de edición'
                  : yearExp.hasMatch(val4!) == false
                      ? "Solo se aceptan números"
                      : null,
              onSaved: (val) => book_year = val!,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      pickImageFromGallery();
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: Text("Imagen"),
                ),
                const SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text("Cancelar"),
                ),
                const SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    updateBook();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text("Aceptar"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _showSnackBar(BuildContext context, String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje.toUpperCase()),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modificar libro"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            if (_image == null && photo != null) ...[
              Container(
                width: 200,
                height: 320,
                child: Utility.ImageFromBase64String(photo!.photo_name!),
              ),
            ],
            Flexible(
              child: form(),
            )
          ],
        ),
      ),
    );
  }
}
