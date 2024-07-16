import Foundation
import FirebaseFirestore

struct DataService {
    let database = Firestore.firestore()
    
    private init() {}
    
    static let dataService = DataService()
    
    func getAdoptions(completion: @escaping ([AnimalAdoption]?) -> Void) {
        database.collection(Constants.adoptionsCollectionName).getDocuments {data, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            guard let documents = data?.documents else {
                print("No documents found")
                return
            }
            
            var fetchedAdoptions = [AnimalAdoption]()
            for document in documents {
                let data = document.data()
                do {
                    let adoption = try JSONDecoder().decode(AnimalAdoption.self, from: data)
                    fetchedAdoptions.append(adoption)
                } catch {
                    print("Failed to decode adoption: \(error)")
                    return
                }
            }
            
            completion(fetchedAdoptions)
        }
    }
    
    func saveAdoption(_ adoption: AnimalAdoption, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection(Constants.adoptionsCollectionName)
        
        do {
            let adoptionData = try JSONEncoder().encodeToDictionary(adoption)
            var documentReference: DocumentReference? = nil
            documentReference = collection.addDocument(data: adoptionData) { error in
                if let err = error {
                    print("Error adding document: \(err)")
                    completion(false)
                } else {
                    print("Document added with ID: \(documentReference?.documentID ?? "No ID")")
                    completion(true)
                }
            }
        } catch {
            print("Failed to encode adoption: \(error)")
            completion(false)
        }
    }
    
    func loadUser(byID userID: String, completion: @escaping (AppUser?) -> Void) {
        let userRef = database.collection("users").document(userID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                do {
                    let user = try JSONDecoder().decode(AppUser.self, from: data)
                    completion(user)
                } catch {
                    print("Failed to decode user: \(error)")
                    completion(nil)
                }
            } else {
                print("User does not exist or an error occurred: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
    
    func saveUser(_ user: AppUser, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection(Constants.adoptionsCollectionName)
        
        do {
            let adoptionData = try JSONEncoder().encodeToDictionary(user)
            var documentReference: DocumentReference? = nil
            documentReference = collection.addDocument(data: adoptionData) { error in
                if let err = error {
                    print("Error adding document: \(err)")
                    completion(false)
                } else {
                    print("Document added with ID: \(documentReference?.documentID ?? "No ID")")
                    completion(true)
                }
            }
        } catch {
            print("Failed to encode adoption: \(error)")
            completion(false)
        }
    }
}
