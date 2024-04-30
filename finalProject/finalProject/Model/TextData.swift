//
//  TextData.swift
//  finalProject
//
//  Created by Zak Young on 4/24/24.
//

import Foundation
import UIKit
struct TextData: Identifiable, Codable, Equatable {
    var text: String
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
    var pageNum: Int
    var fontSize: Int
    var color: UIColor
    var id: UUID = UUID()
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case x = "x"
        case y = "y"
        case width = "width"
        case height = "height"
        case pageNum = "pageNum"
        case id = "id"
        case fontSize = "fontSize"
        case color = "color"
    }
    
    init(text: String, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, pageNum: Int, fontSize: Int, color: UIColor, id: UUID) {
        self.text = text
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.pageNum = pageNum
        self.fontSize = fontSize
        self.color = color
        self.id = id
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(pageNum, forKey: .pageNum)
        try container.encode(id, forKey: .id)
        try container.encode(fontSize, forKey: .fontSize)
        let colorDataRaw = encodeColorHelper(li: [color])
        let mainColor2 = colorDataRaw[0]
        try container.encode(mainColor2, forKey: .color)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decode(String.self, forKey: .text)
        x = try values.decode(CGFloat.self, forKey: .x)
        y = try values.decode(CGFloat.self, forKey: .y)
        width = try values.decode(CGFloat.self, forKey: .width)
        height = try values.decode(CGFloat.self, forKey: .height)
        pageNum = try values.decode(Int.self, forKey: .pageNum)
        id = try values.decode(UUID.self, forKey: .id)
        fontSize = try values.decode(Int.self, forKey: .fontSize)
        let c1 = try values.decodeIfPresent([CGFloat].self, forKey: .color)
        if c1 != nil{
            color = decodeColorHelper(li: [c1!])[0]
        }
        else{
            color = UIColor.black
        }
    }
    static func == (lhs: TextData, rhs: TextData) -> Bool {
        lhs.id == rhs.id
    }
}
