class Item {
  final int? id;
  final String word;
  final String phonetic;
  final String definition;
  final int lastSearch;
  final int fav;

  Item({
    this.id,
    required this.word,
    required this.phonetic,
    required this.definition,
    required this.lastSearch,
    required this.fav,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'phonetic': phonetic,
      'definition': definition,
      'last_search': lastSearch,
      'fav': fav,
    };
  }
}
