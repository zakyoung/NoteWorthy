//
//  ImageData.swift
//  finalProject
//
//  Created by Zak Young on 4/21/24.
import Foundation
import SwiftUI


struct ImageData: Identifiable, Codable, Equatable {
    var image: UIImage
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
    var pageNum: Int
    var id: UUID = UUID()
    
    enum CodingKeys: String, CodingKey {
        case image = "image"
        case x = "x"
        case y = "y"
        case width = "width"
        case height = "height"
        case pageNum = "pageNum"
        case id = "id"
    }
    
    init(image: UIImage, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, pageNum: Int) {
        self.image = image
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.pageNum = pageNum
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let uiEncode = image.base64
        try container.encode(uiEncode, forKey: .image)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(pageNum, forKey: .pageNum)
        try container.encode(id, forKey: .id)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let imageLocal = try values.decode(String.self, forKey: .image)
        image = imageLocal.imageFromBase64!
        x = try values.decode(CGFloat.self, forKey: .x)
        y = try values.decode(CGFloat.self, forKey: .y)
        width = try values.decode(CGFloat.self, forKey: .width)
        height = try values.decode(CGFloat.self, forKey: .height)
        pageNum = try values.decode(Int.self, forKey: .pageNum)
        id = try values.decode(UUID.self, forKey: .id)
    }

    static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        lhs.id == rhs.id
    }
}

 // https://www.hackingwithswift.com/forums/swiftui/encode-image-uiimage-to-base64/10103
extension UIImage {
    var base64: String? { // Encoding the image to a string
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}

extension String {
    var imageFromBase64: UIImage? { // used to decode the string back to an image
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

