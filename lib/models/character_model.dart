class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final String url;
  final String created;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.url,
    required this.created,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',
      url: json['url'] ?? '',
      created: json['created'] ?? '',
    );
  }
}

class CharactersResponse {
  final List<Character> results;
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  CharactersResponse({
    required this.results,
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory CharactersResponse.fromJson(Map<String, dynamic> json) {
    return CharactersResponse(
      results: (json['results'] as List)
          .map((item) => Character.fromJson(item))
          .toList(),
      count: json['info']['count'] ?? 0,
      pages: json['info']['pages'] ?? 0,
      next: json['info']['next'],
      prev: json['info']['prev'],
    );
  }
}

