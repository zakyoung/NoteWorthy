//
//  Note.swift
//  finalProject
//
//  Created by Zak Young on 3/11/24.
//

import Foundation
import PencilKit
import SwiftUI
struct Note : Identifiable, Codable, Equatable{
    var name: String
    var dateCreated: Date
    var dateLastModified: Date
    var drawings: [Canvas]
    var subject: Subject?
    var favorited: Bool // true means it is favorited
    var id: UUID = UUID()
    var currentBackground: Papers
    var imageData: [ImageData]
    var textData: [TextData]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case dateCreated = "dateCreated"
        case dateLastModified = "dateLastModified"
        case drawings = "drawings"
        case subject = "subject"
        case favorited = "favorited"
        case currentBackground = "currentBackground"
        case imageData = "imageData"
        case textData = "textData"
    }
    init(name: String, dateCreated: Date, dateLastModified: Date, drawings: [Canvas], subject: Subject? = nil, favorited: Bool, currentBackground: Papers = .NONE, imageData: [ImageData] = [], textData: [TextData] = []) {
        self.name = name
        self.dateCreated = dateCreated
        self.dateLastModified = dateLastModified
        self.drawings = drawings
        self.subject = subject
        self.favorited = favorited
        self.currentBackground = currentBackground
        self.imageData = imageData
        self.textData = textData
    }
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateLastModified, forKey: .dateLastModified)
        let drawingsAll = drawings.map{$0.canvasView.drawing.dataRepresentation()}
        try container.encode(drawingsAll, forKey: .drawings)
        try container.encode(subject, forKey: .subject)
        try container.encode(favorited, forKey: .favorited)
        try container.encode(id, forKey: .id)
        try container.encode(currentBackground.rawValue, forKey: .currentBackground)
        try container.encode(imageData, forKey: .imageData)
        try container.encode(textData, forKey: .textData)
    }
        init(from decoder: Decoder) throws{
            let baseValues = try decoder.container(keyedBy: CodingKeys.self)
            name = try baseValues.decode(String.self, forKey: .name)
            dateCreated = try baseValues.decode(Date.self, forKey: .dateCreated)
            dateLastModified = try baseValues.decode(Date.self, forKey: .dateLastModified)
            let inter = try baseValues.decode([Data].self, forKey: .drawings)
            drawings = []
            imageData = try baseValues.decode([ImageData].self, forKey: .imageData)
            for (index, draw) in inter.enumerated(){
                let canv = Canvas(pageNumber: index)
                canv.canvasView.drawing = try PKDrawing(data: draw)
                drawings.append(canv)
            }
            subject = try baseValues.decodeIfPresent(Subject.self, forKey: .subject)
            favorited = try baseValues.decode(Bool.self, forKey: .favorited)
            id = try baseValues.decode(UUID.self, forKey: .id)
            let backgroundRawValue = try baseValues.decode(String.self, forKey: .currentBackground)
            let background = Papers(rawValue: backgroundRawValue)
            currentBackground = background!
            textData = try baseValues.decode([TextData].self, forKey: .textData)
        }
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id && lhs.drawings == rhs.drawings
    }
}
