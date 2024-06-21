//
//  Extensions.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 20.06.24.
//

import UIKit

extension UIViewController {
    func showAlert(message: String, title: String = "Warning") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decode(T.self, from: data)
    }
}
