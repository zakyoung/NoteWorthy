//
//  EraserTool.swift
//  finalProject
//
//  Created by Zak Young on 4/14/24.
//

import Foundation
import PencilKit
struct EraserTool: Codable{
    var width: CGFloat
    var eraserType: PKEraserTool.EraserType
    enum CodingKeys: String, CodingKey {
        case width = "width"
        case eraserType = "eraserType"
    }
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(width, forKey: .width)
        if eraserType == .bitmap {
            try container.encode(0, forKey: .eraserType)
        }
        else{
            try container.encode(1, forKey: .eraserType)
        }
    }
    init(from decoder: Decoder) throws {
        let baseValues = try decoder.container(keyedBy: CodingKeys.self)
        width = try baseValues.decode(CGFloat.self, forKey: .width)
        let temp  = try baseValues.decode(CGFloat.self, forKey: .eraserType)
        if temp == 0{
            eraserType = .bitmap
        }
        else{
            eraserType = .vector
        }
    }
    init(w: CGFloat, et: PKEraserTool.EraserType){
        width = w
        eraserType = et
    }
}
