//
//  Utility.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 20.05.2021.
//

import SwiftUI

class Utility {
    static var shared = Utility()
    
    func convertImageToBase64String (image: UIImage?) -> String {
        return image!.jpegData(compressionQuality: 0.1)!.base64EncodedString()
    }
    
    func base64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
}
