import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  final int id;
  final String name;
  final String species;
  final String image;

  const CharacterEntity ({
    required this.id,
    required this.name,
    required this.species,
    required this.image,
});

@override
List<Object?> get props => [
    id,
    name,
    species,
    image,
  ];
}
