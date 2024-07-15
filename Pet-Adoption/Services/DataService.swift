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
}
