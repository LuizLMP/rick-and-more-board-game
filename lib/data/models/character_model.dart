import 'package:board_game_rick_morty/domain/entities/character_entity.dart';

class Character extends CharacterEntity {
  const Character({
    required int id,
    required String name,
    required String species,
    required String image,
    String? status,
  }) : super(
          id: id,
          name: name,
          species: species,
          image: image,
          status: status,
        );

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      image: json['image'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'image': image,
      'status': status,
    };
  }
}
