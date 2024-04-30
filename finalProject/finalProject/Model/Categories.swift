//
//  Categories.swift
//  finalProject
//
//  Created by Zak Young on 3/27/24.
//

import Foundation

enum Categories : String, CaseIterable {
    case ALLNOTES = "All Notes"
    case RECENTS = "Recently Viewed"
    case FAVORITES = "Favorites"
}

enum SortBy : String, CaseIterable , Identifiable{
    case RECENTS = "Recents"
    case FAVORITES = "Favorites"
    case ALPH = "A -> Z"
    case REVERSEALPH = "Z -> A"
    case DATECREATED = "Earliest"
    var id: Self { self }
}

enum toolsE{
    case pencil
    case pen
    case highlighter
    case eraser
    case lasso
    case photo
    case text
}
