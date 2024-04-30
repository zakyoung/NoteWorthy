//
//  AppHandlerFilters.swift
//  finalProject
//
//  Created by Zak Young on 3/11/24.
//

import Foundation

extension AppHandler{
    func notesForSubject(subject : Subject?, sortBy: SortBy) -> [Note] {
        var notes: [Note] = []
        if (subject != nil){
            for note in allNotes{
                if note.subject == subject{
                    notes.append(note)
                }
            }
        }
        else{
            notes = allNotes
        }
        if sortBy == .ALPH{
            notes = notes.sorted { $0.name < $1.name }
        }
        else if sortBy == .DATECREATED{
            notes = notes.sorted{$0.dateCreated < $1.dateCreated}
        }
        else if sortBy == .FAVORITES{
            notes = notes.filter{$0.favorited}
        }
        else if sortBy == .REVERSEALPH{
            notes = notes.sorted{$0.name > $1.name}
        }
        else{
            notes = notes.sorted{$0.dateLastModified > $1.dateLastModified}
        }
        return notes
    }
    
    func favoriteNotes() -> [Note]{
        var notes: [Note] = []
        for note in allNotes{
            if note.favorited{
                notes.append(note)
            }
        }
        return notes
    }
}
