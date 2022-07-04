class Person implements Comparable {
  final int id;
  final String firstName;
  final String lastName;

  const Person({
    this.id,
    this.firstName,
    this.lastName,
  });

  String get fullName => '$firstName $lastName';

  Person.fromRow(Map<String, Object> row)
      : id = row['ID'],
        firstName = row['FIRST_NAME'],
        lastName = row['LAST_NAME'];

  @override
  int compareTo(covariant Person other) => other.id.compareTo(id);

  @override
  bool operator ==(covariant Person other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Person(id: $id, firstName: $firstName, lastName: $lastName)';
}
