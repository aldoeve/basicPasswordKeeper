/// Use with FurinaGenorator to find locations in the list.
enum Requirements{
  specialChars(0),
  upperCase(1),
  lowerCase(2),
  number(3);

  final int i;
  
  const Requirements(this.i);
}