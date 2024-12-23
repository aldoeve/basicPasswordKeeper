/// Error thrown when generator is in psudo mode but the phrase is null.
class GeneratorNullError implements Exception{
  static const String message = "Attempted to generate a psudo-Random password while the phrase is null";
  const GeneratorNullError();
  @override
  String toString() => message;
}