class Photo {
  int? id;
  String? photo_name;
  String? name_book;
  String? author_book;
  String? book_publisher;
  String? book_year;

  Photo(this.id, this.photo_name, this.name_book, this.author_book,
      this.book_publisher, this.book_year);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "photo_name": photo_name,
      "name_book": name_book,
      "author_book": author_book,
      "book_publisher": book_publisher,
      "book_year": book_year,
    };
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    photo_name = map["photo_name"];
    name_book = map["name_book"];
    author_book = map["author_book"];
    book_publisher = map["book_publisher"];
    book_year = map["book_year"];
  }
}
