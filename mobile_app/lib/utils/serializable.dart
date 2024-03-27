/// Defines the type of JSON object.
typedef Json = Map<String, dynamic>;

/// Defines a contract for a data object that can be serialized to JSON.
abstract class Serializable<T> {
  /// Serialize the object to JSON.
  ///
  /// Returns a JSON object.
  Json toJson();
}
