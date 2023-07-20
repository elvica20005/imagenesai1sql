import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;



Future<List> getPeople() async {
  List people = [];
  QuerySnapshot querySnapshot = await db.collection('people').get();
  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    Map person = {
      "uid": doc.id,
      "name_book": data["name_book"],
      "author_book": data["author_book"],
      "book_year": data["book_year"],
      "book_publisher": data["book_publisher"],

    };

    people.add(person);
  }
  return people;
}

// Guardar un name en base de datos
Future<void> addPeople(String name_book, String author_book, String book_year, book_publisher) async {
  await db.collection("people").add({"name_book": name_book, "author_book": author_book, "book_year": book_year, "book_publisher": book_publisher});

}

// Actualizar un name en base de datos
Future<void> updatePeople(String uid, String name_book, String author_book, String book_year, book_publisher) async {
  await db.collection("people").doc(uid).set({"name_book": name_book, "author_book": author_book, "book_publisher": book_publisher});

}

// Borrar datos de Firebase
Future<void> deletePeople(String uid) async {
  await db.collection("people").doc(uid).delete();
}