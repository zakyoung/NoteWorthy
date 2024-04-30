//
//  AppHandlerLS.swift
//  finalProject
//
//  Created by Zak Young on 3/11/24.
//

import Foundation
import PencilKit

extension AppHandler{
    func convertDrawingToData(drawing: PKDrawing) -> Data {
        let data = drawing.dataRepresentation()
        return data
    }
    func loadNotes() {
        do {
            let content = try Data(contentsOf: notesUrlPersisted)
            let decoder = JSONDecoder()
            let localNotes = try decoder.decode([Note].self, from: content)
            allNotes = localNotes
        } catch {
            return
        }
    }
    
    func saveNotes() {
        do {
            let encoder = JSONEncoder()
            let content = try encoder.encode(allNotes)
            try content.write(to: notesUrlPersisted, options: .atomic)
        } catch {
            return
        }
    }
    func loadSubjects() {
        do {
            let content = try Data(contentsOf: subjectsUrlPersisted)
            let decoder = JSONDecoder()
            allSubjects = try decoder.decode([Subject].self, from: content)
        } catch {
            return
        }
    }
    
    func saveSubjects() {
        do {
            let encoder = JSONEncoder()
            let content = try encoder.encode(allSubjects)
            try content.write(to: subjectsUrlPersisted, options: .atomic)
        } catch {
            return
        }
    }
    func saveToolBar(){
        do {
            let saveable = ToolBarToolsEncodables(pencil: pencilTool, pen: penTool, highlighter: highlighterTool, eraser: eraserTool) // Encodable version we use when saving the tool bar
            let encoder = JSONEncoder()
            let content = try encoder.encode(saveable)
            try content.write(to: toolbarUrlPersisted, options: .atomic)
        } catch {
            return
        }
    }
        func loadToolBar() {
            do {
                let content = try Data(contentsOf: toolbarUrlPersisted)
                let decoder = JSONDecoder()
                let temp = try decoder.decode(ToolBarToolsEncodables.self, from: content)
                pencilTool = temp.pencil
                penTool = temp.pen
                highlighterTool = temp.highlighter
                eraserTool = temp.eraser
            } catch {
                return
            }
        }
}
