//
//  PenTool.swift
//  finalProject
//
//  Created by Zak Young on 4/14/24.
//

import Foundation
import PencilKit

struct PenTool: DrawingTool,Codable{
    var mainColor: UIColor
    var favorites: [UIColor]
    var width: CGFloat
    enum CodingKeys: String, CodingKey {
        case mainColor = "mainColor"
        case favorites = "favorites"
        case width = "width"
    }
    init(mainColor1: UIColor,favorites1: [UIColor],width1: CGFloat){
        mainColor = mainColor1
        favorites = favorites1
        width = width1
    }
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        let colorDataRaw = encodeColorHelper(li: [mainColor])
        let mainColor2 = colorDataRaw[0]
        try container.encode(mainColor2, forKey: .mainColor)
        let favoritesData = encodeColorHelper(li:favorites)
        try container.encode(favoritesData, forKey: .favorites)
        try container.encode(width, forKey: .width)
    }
    init(from decoder: Decoder) throws{
        let baseValues = try decoder.container(keyedBy: CodingKeys.self)
        let mainColors = try baseValues.decode([CGFloat].self, forKey: .mainColor)
        mainColor = decodeColorHelper(li: [mainColors])[0]
        let favorite = try baseValues.decode([[CGFloat]].self,forKey:.favorites)
        favorites = decodeColorHelper(li: favorite)
        width = try baseValues.decode(CGFloat.self, forKey: .width)
    }
}
