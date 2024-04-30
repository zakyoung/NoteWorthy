//
//  Papers.swift
//  finalProject
//
//  Created by Zak Young on 4/15/24.
//

import Foundation
enum Papers : String, Codable, CaseIterable, Identifiable{
    case NONE = "none"
    case COLLEGERULED = "College Ruled"
    case LINEDPAPER = "Lined Paper"
    case GRAPHPAPER = "Graph Paper"
    var id: Self { self }
}
