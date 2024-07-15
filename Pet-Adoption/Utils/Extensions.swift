//
//  Extensions.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 20.06.24.
//

import UIKit

extension UIViewController {
    func showAlert(message: String, title: String = "Warning") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addRoundedCorners(to view: UIView, corners: UIRectCorner) {
        view.layer.cornerRadius = 20.0
        view.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decode(T.self, from: data)
    }
}

extension JSONEncoder {
    func encodeToDictionary<T: Encodable>(_ value: T) throws -> [String: Any] {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = json as? [String: Any] else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to dictionary"])
        }
        return dictionary
    }
}

extension String {
    func capitalizeFirstLetter() -> String {
        guard let firstCharacter = self.first else { return self }
        return firstCharacter.uppercased() + self.dropFirst()
    }
}

extension UITextField {
    var isFieldValid: Bool {
        return self.layer.borderColor != UIColor.red.cgColor
    }
}

extension Date {
    var formattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateString = dateFormatter.string(from: self)
        let fractionalSeconds = String(format: "%.6f", self.timeIntervalSince1970.truncatingRemainder(dividingBy: 1))

        return "\(dateString)\(fractionalSeconds.suffix(7))"
    }
}
