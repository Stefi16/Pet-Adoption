//
//  UploadImageService.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 15.07.24.
//

import Foundation
import FirebaseStorage

struct UploadImageService {
    private let storage = Storage.storage()
    
    var storageRef: StorageReference {
        return storage.reference()
    }
    
    private init() {}
    
    static let reference = UploadImageService()
    
    func uploadImage(image: Data?, adoptionId: String, completion: @escaping (String?) -> Void) {
        guard let safeImage = image else {
            completion(nil)
            return
        }
        
        let adoptionRef = storageRef.child("adoption_picture/\(adoptionId).jpg")
        let task = adoptionRef.putData(safeImage)
        
        var safeUrl: String?
        task.observe(.success) { snapshot in
            adoptionRef.downloadURL { url, err in
                safeUrl = url?.absoluteString
            }
            completion(safeUrl)
        }
        
        task.observe(.failure) { _ in
            completion(nil)
        }
    }
}
