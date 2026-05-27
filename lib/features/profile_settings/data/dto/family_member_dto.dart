import '../../../../core_import.dart';

class FamilyMemberDto {
  final String? id;
  final String name;
  final String relationship;
  final String ageRange;
  final String healthNotes;

  const FamilyMemberDto({
    this.id,
    required this.name,
    required this.relationship,
    required this.ageRange,
    required this.healthNotes,
  });

  factory FamilyMemberDto.fromFirestore(
      Map<String, dynamic> data, String id) {
    return FamilyMemberDto(
      id: id,
      name: data['name'] as String? ?? '',
      relationship: data['relationship'] as String? ?? '',
      ageRange: data['ageRange'] as String? ?? '',
      healthNotes: data['healthNotes'] as String? ?? '',
    );
  }

  factory FamilyMemberDto.fromEntity(FamilyMemberEntity entity) {
    return FamilyMemberDto(
      id: entity.id,
      name: entity.name,
      relationship: entity.relationship,
      ageRange: entity.ageRange,
      healthNotes: entity.healthNotes,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'relationship': relationship,
        'ageRange': ageRange,
        'healthNotes': healthNotes,
        'createdAt': FieldValue.serverTimestamp(),
      };

  FamilyMemberEntity toEntity() => FamilyMemberEntity(
        id: id,
        name: name,
        relationship: relationship,
        ageRange: ageRange,
        healthNotes: healthNotes,
      );
}
