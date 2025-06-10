import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  final int id;
  final String name;
  final String species;
  final String image;
  final String? status;

  const CharacterEntity ({
    required this.id,
    required this.name,
    required this.species,
    required this.image,
    required this.status,
});

@override
List<Object?> get props => [
    id,
    name,
    species,
    image,
    status,
  ];
}
