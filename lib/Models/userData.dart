// ignore_for_file: file_names

class UserData {
  final String collectionName;
  final String name;
  final String description;
  final String imgUrl;
  final int price;

  UserData(
    this.name,
    this.imgUrl,
    this.description,
    this.price,
    this.collectionName,
  );
}

class AuditoriumCanteenData {
  final String name;
  final String description;
  final String imgUrl;

  AuditoriumCanteenData(this.name, this.imgUrl, this.description);
}
