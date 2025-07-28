import Dependencies
@preconcurrency import FirebaseFirestore
import Foundation
import SharedModels
import UserDefaultsClient

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
            updateUser: { try await session.updateUser(for: $0, with: $1) },
            deleteUser: { try await session.deleteUser(uid: $0) },
            getAppConfig: { try await session.getAppConfig() },
            createWorkplace: { try await session.createWorkplace(with: $0) }
        )
    }
}

extension UserStoreClient {
    actor Session {
        func saveUserToStore(withUser user: AppUser) async throws {
            do {
                let reference = Firestore.firestore().collection(CollectionID.users.rawValue).document(user.id)
                try reference.setData(from: user)
            } catch {
                throw mapError(error)
            }
        }
        
        func getUserFromStore(for uid: String) async throws -> AppUser {
            do {
                let reference = Firestore.firestore().collection(CollectionID.users.rawValue).document(uid)
                let documentSnapshot = try await reference.getDocument()
                
                printLog(for: reference, snapshot: documentSnapshot)
                
                let user = try documentSnapshot.data(as: AppUser.self)
                return user
            } catch {
                throw mapError(error)
            }
        }
        
        func updateUser(for uid: String, with fields: SendableDictionary) async throws {
            do {
                let reference = Firestore.firestore().collection(CollectionID.users.rawValue).document(uid)
                
                printLog(for: reference, fields: fields)
                
                try await reference.updateData(fields.dictionary)
            } catch {
                throw mapError(error)
            }
        }
        
        func deleteUser(uid: String) async throws {
            do {
                let reference = Firestore.firestore().collection(CollectionID.users.rawValue).document(uid)
                
                printLog(for: reference)
                
                try await reference.delete()
            } catch {
                throw mapError(error)
            }
        }
        
        func getAppConfig() async throws -> AppConfig {
            do {
                let reference = Firestore.firestore().collection(CollectionID.appConfig.rawValue).document(DocumentID.settings.rawValue)
                let documentSnapshot = try await reference.getDocument()
                
                printLog(for: reference, snapshot: documentSnapshot)
                
                let appConfig = try documentSnapshot.data(as: AppConfig.self)
                return appConfig
            } catch {
                throw mapError(error)
            }
        }
        
        func createWorkplace(with workplace: Workplace) async throws {
            do {
                let id = workplace.id
                let reference = Firestore.firestore().collection(CollectionID.workplaces.rawValue).document(id)
                try reference.setData(from: workplace)
            } catch {
                throw mapError(error)
            }
        }
    }
}

// MARK: Error
extension UserStoreClient.Session {
    private func mapError(_ error: Error) -> AppError {
        if let nsError = error as NSError?, nsError.domain == FirestoreErrorDomain, let code = FirestoreErrorCode.Code(rawValue: nsError.code) {
            switch code {
            case .permissionDenied:
                return .apiError(.permissionDenied)
                
            case .unavailable:
                return .apiError(.storeTimeout)
                
            case .notFound:
                return .apiError(.dataNotFound)
                
            case .resourceExhausted:
                return .apiError(.rateLimited)
                
            default:
                return .apiError(.unknown(error.localizedDescription))
            }
        }
        
        return .apiError(.unknown(error.localizedDescription))
    }
}

// MARK: Log
extension UserStoreClient.Session {
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
