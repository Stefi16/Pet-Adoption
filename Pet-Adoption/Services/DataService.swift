import Foundation
import FirebaseFirestore

class DataService {
    let database = Firestore.firestore()
    
    private init() {}
    
    static let dataService = DataService()
    
    var adoptions = [AnimalAdoption]()
    
    func getAdoptions(completion: @escaping ([AnimalAdoption]?) -> Void) {
        database.collection(Constants.adoptionsCollectionName).getDocuments { [weak self] data, error in
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
            
            self?.adoptions = fetchedAdoptions
            completion(fetchedAdoptions)
        }
    }
}
