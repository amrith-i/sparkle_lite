import '../../../../core_import.dart';

class FamilyMemberEntity extends Equatable {
  final String? id;
  final String name;
  final String relationship; // Mother, Father, Son, Daughter, Spouse, Sibling, Other
  final String ageRange;    // e.g. "5–12", "55–64"
  final String healthNotes;

  const FamilyMemberEntity({
    this.id,
    required this.name,
    required this.relationship,
    required this.ageRange,
    required this.healthNotes,
  });

  @override
  List<Object?> get props => [id, name, relationship, ageRange, healthNotes];
}
