import 'package:isar/isar.dart';

part 'news_collection.g.dart';

@collection
class NewsCollection {
  Id id = Isar.autoIncrement; 

  late String title;
  late String description;
  late String urlToImage;
}