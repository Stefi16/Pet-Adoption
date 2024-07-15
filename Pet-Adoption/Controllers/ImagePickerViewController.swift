//
//  ImagePickerViewController.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 27.06.24.
//

import UIKit

protocol ImagePickerProtocol {
    func passImageData(_ image: UIImage?)
}

class ImagePickerViewController: UIViewController {
    
    let picker = UIImagePickerController();
    var delegate: ImagePickerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: "Select Source", message: "Choose an option to select a photo", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                self?.picker.sourceType = .camera
                
                if let picker = self?.picker {
                    self?.present(picker, animated: true, completion: nil)
                }
            }
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                
                self?.picker.sourceType = .savedPhotosAlbum
                self?.picker.allowsEditing = false
                
                if let picker = self?.picker {
                    self?.present(picker, animated: true, completion: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        delegate?.passImageData(info[UIImagePickerController.InfoKey.originalImage] as? UIImage)
        picker.dismiss(animated: true, completion: nil)
    }
}
