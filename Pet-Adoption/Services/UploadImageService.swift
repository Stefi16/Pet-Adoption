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
        
        let storageRef = Storage.storage().reference()
        let adoptionRef = storageRef.child("adoption_picture/\(adoptionId).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let task = adoptionRef.putData(safeImage, metadata: metadata) { metadata, error in
            guard error == nil else {
                completion(nil)
                return
            }
            
            adoptionRef.downloadURL { url, error in
                guard let downloadURL = url, error == nil else {
                    completion(nil)
                    return
                }
                completion(downloadURL.absoluteString)
            }
        }
        
        task.observe(.failure) { _ in
            completion(nil)
        }
    }
}
