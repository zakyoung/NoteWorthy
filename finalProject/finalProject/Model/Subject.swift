//
//  Subject.swift
//  finalProject
//
//  Created by Zak Young on 3/11/24.
//

import Foundation
import UIKit
struct Subject: Identifiable, Codable, Equatable, Hashable{
    var name: String
    var id = UUID()
    var mainColor: UIColor?
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case mainColor = "mainColor"
    }
    init(name: String) {
        self.mainColor = getRandomColor()
        self.name = name
    }
    static func == (lhs: Subject, rhs: Subject) -> Bool {
        return lhs.name == rhs.name
    }
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        if mainColor != nil{
            let colorDataRaw = encodeColorHelper(li: [mainColor!])
            let mainColor2 = colorDataRaw[0]
            try container.encode(mainColor2, forKey: .mainColor)
        }
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
    init(from decoder: Decoder) throws{
        let baseValues = try decoder.container(keyedBy: CodingKeys.self)
        let mainColors = try baseValues.decodeIfPresent([CGFloat].self, forKey: .mainColor)
        if mainColors != nil{
            mainColor = decodeColorHelper(li: [mainColors!])[0]
        }
        name = try baseValues.decode(String.self, forKey: .name)
        id = try baseValues.decode(UUID.self, forKey: .id)
    }
}
func getRandomColor() -> UIColor {
     //https://stackoverflow.com/questions/29779128/how-to-make-a-random-color-with-swift
    let red:CGFloat = CGFloat(Double.random(in: 0.0...1.0))
     let green:CGFloat = CGFloat(Double.random(in: 0.0...1.0))
     let blue:CGFloat = CGFloat(Double.random(in: 0.0...1.0))
     return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
}
