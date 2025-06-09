import 'package:board_game_rick_morty/domain/entities/character_entity.dart';

class Character extends CharacterEntity {
  const Character({
    required super.id,
    required super.name,
    required super.species,
    required super.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'image': image,
    };
  }
}
