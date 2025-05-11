import Swift

/// An attached member macro that generates a fluent builder
/// for creating update dictionaries.
///
/// Attach this to a struct to add:
/// - A nested `DictionaryBuilder` struct (e.g., if your struct is MyType, it's MyType.DictionaryBuilder).
/// - An instance method `dictionaryBuilder() -> DictionaryBuilder` on the original struct.
///
/// The builder allows chaining calls like:
/// `instance.dictionaryBuilder().propertyName(value).anotherProperty(value).dictionary`
@attached(member, names: named(DictionaryBuilder), named(dictionaryBuilder))
public macro DictionaryBuilder() = #externalMacro(module: "SharedMacros", type: "DictionaryBuilder")

