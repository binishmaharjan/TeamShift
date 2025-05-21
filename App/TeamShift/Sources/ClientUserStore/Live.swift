import ClientUserDefaults
import Dependencies
@preconcurrency import FirebaseFirestore
import Foundation
import SharedModels

// MARK: Dependency (liveValue)
extension UserStoreClient: DependencyKey {
    public static let liveValue = UserStoreClient.live()
}

extension UserStoreClient {
    public static func live() -> UserStoreClient {
        let session = Session()
        
        return UserStoreClient(
            saveUser: { try await session.saveUserToStore(withUser: $0) },
            getUser: { try await session.getUserFromStore(for: $0) },
            updateUser: { try await session.updateUser(for: $0, with: $1) }
        )
    }
}

extension UserStoreClient {
    actor Session {
        func saveUserToStore(withUser user: AppUser) async throws {
            do {
                let reference = Firestore.firestore().collection(Collection.users.rawValue).document(user.id)
                try reference.setData(from: user)
            } catch {
                throw UserStoreError(from: error)
            }
        }
        
        func getUserFromStore(for uid: String) async throws -> AppUser {
            do {
                let reference = Firestore.firestore().collection(Collection.users.rawValue).document(uid)
                let documentSnapshot = try await reference.getDocument()
                
                printLog(for: reference, snapshot: documentSnapshot)
                
                let user = try documentSnapshot.data(as: AppUser.self)
                return user
            } catch {
                throw UserStoreError(from: error)
            }
        }
        
        func updateUser(for uid: String, with fields: SendableDictionary) async throws {
            do {
                let reference = Firestore.firestore().collection(Collection.users.rawValue).document(uid)
                
                printLog(for: reference, fields: fields)
                
                try await reference.updateData(fields.dictionary)
            } catch {
                throw UserStoreError(from: error)
            }
        }
        
        // MARK: Log
        private func printLog(for reference: DocumentReference, fields: SendableDictionary? = nil, snapshot: DocumentSnapshot? = nil) {
            print("\n--- ℹ️ DOCUMENT DETAILS ---")
            print("➡️ Path: \(reference.path)")
            print("➡️ Request: ")
            if let fields {
                printCleanDictionary(fields.dictionary)
            } else {
                print("Empty Request Fields")
            }
            print("➡️ Response: ")
            if let snapshot, let rawData = snapshot.data() {
                printCleanDictionary(rawData)
            } else {
                print("No Snapshot or RawData")
            }
            print("-----------------------------------\n")
        }
        
        /// Converts a Firestore-specific value (like Timestamp, GeoPoint, DocumentReference)
        /// into a JSON-compatible representation. Recursively handles arrays and dictionaries.
        private func convertFirestoreValueToJsonCompatible(_ value: Any) -> Any {
            if let timestamp = value as? FirebaseFirestore.Timestamp {
                // Convert FIRTimestamp to an ISO 8601 String for readability in JSON
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                return dateFormatter.string(from: timestamp.dateValue())
            } else if let geoPoint = value as? GeoPoint {
                // Convert GeoPoint to a dictionary representation
                return ["latitude": geoPoint.latitude, "longitude": geoPoint.longitude]
            } else if let documentReference = value as? DocumentReference {
                // Convert DocumentReference to its string path
                return documentReference.path
            } else if let array = value as? [Any] {
                // Recursively convert elements in an array
                return array.map { convertFirestoreValueToJsonCompatible($0) }
            } else if let dict = value as? [String: Any] {
                // Recursively convert values in a dictionary
                return dict.mapValues { convertFirestoreValueToJsonCompatible($0) }
            }
            // If it's a basic type (String, Int, Bool, Double, etc.), return as is
            return value
        }

        /// Prints a dictionary in a clean, indented JSON-like format,
        /// converting Firestore-specific types to JSON-compatible representations.
        private func printCleanDictionary(_ dictionary: [String: Any]) {
            // Preprocess the dictionary to make all its values JSON-serializable
            let jsonCompatibleDictionary = dictionary.mapValues { convertFirestoreValueToJsonCompatible($0) }

            do {
                // Convert the JSON-compatible dictionary to Data with pretty printing and sorted keys
                let jsonData = try JSONSerialization.data(withJSONObject: jsonCompatibleDictionary, options: [.prettyPrinted, .sortedKeys])
                
                // Convert the JSON Data to a String
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print("Error: Failed to convert JSON data to string for clean printing.")
                }
            } catch {
                print("Error: Could not create JSON data for clean printing: \(error.localizedDescription)")
                print("--- Fallback to raw dictionary print (less clean) ---")
                print(dictionary) // Fallback in case of unexpected errors
                print("-----------------------------------------------------")
            }
        }
    }
}
