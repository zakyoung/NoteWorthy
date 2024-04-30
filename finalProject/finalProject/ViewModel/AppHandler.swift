//
//  AppHandler.swift
//  finalProject
//
//  Created by Zak Young on 3/11/24.
//

import Foundation
import SwiftUI
import PencilKit
import PhotosUI
class AppHandler: ObservableObject{
    @Published var allNotes: [Note] = []
    @Published var allSubjects: [Subject] = []
    @Published var selectedSubject: Subject?
    @Published var sortMethods: SortBy = .RECENTS
    @Published var favorites: [Note] = []
    @Published var toolBarTools : ToolBarTools? = nil
    @Published var selectedTool: toolsE = .pen
    @Published var pencilTool = PencilTool(mainColor1: UIColor.black, favorites1: [UIColor.black,UIColor.lightGray,UIColor.darkGray], width1: 10) // Storing the tools in this fashion so they are easiliy modifiable.
    @Published var penTool = PenTool(mainColor1: UIColor.black, favorites1: [UIColor.black, UIColor.red,UIColor.gray,UIColor.green], width1: 10)
    @Published var highlighterTool = HighlighterTool(mainColor1: UIColor.yellow, favorites1: [UIColor.yellow,UIColor.red,UIColor.brown], width1: 50)
    @Published var eraserTool = EraserTool(w: 10, et: .bitmap)
    @Published var currentWorkingNote: Note? = nil
    @Published var currentWorkingNotePDF: URL? = nil
    @Published var backgroundDidChange: Bool = false
    @Published var selectedItems = [PhotosPickerItem]()
    @Published var selectedImages = [ImageData]()
    @Published var selectedTextBlob: TextData? = nil
    let notesUrlPersisted: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("notes.json")
    }()
    
    let subjectsUrlPersisted: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("subjects.json")
    }()
    let toolbarUrlPersisted: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("toolbar.json")
    }()
    init(){
        loadToolBar()
        establishToolBar()
        loadNotes()
        loadSubjects()
        favorites = favoriteNotes()
    }
    func establishToolBar(){
        if toolBarTools != nil{
            toolBarTools = ToolBarTools(pencil: pencilTool, pen: penTool, highlighter: highlighterTool, eraser: eraserTool, lasso: toolBarTools!.lasso)
        }
        else{
            toolBarTools = ToolBarTools(pencil: pencilTool, pen: penTool, highlighter: highlighterTool, eraser: eraserTool, lasso: PKLassoTool())
        }
    }
    func setToolBarForCanvas(tool: PKTool){
        for canvas in currentWorkingNote!.drawings{
            canvas.canvasView.tool = tool
        }
    }
    func setToolBar(){
        establishToolBar() // Need to make sure that the tool bar exists before trying to set the tools
        if selectedTool == .pen{
            setToolBarForCanvas(tool: toolBarTools!.pen)
        }
        else if selectedTool == .pencil{
            setToolBarForCanvas(tool: toolBarTools!.pencil)
        }
        else if selectedTool == .highlighter{
            setToolBarForCanvas(tool: toolBarTools!.highlighter)
        }
        else if selectedTool == .eraser {
            setToolBarForCanvas(tool: toolBarTools!.eraser)
        }
        else if selectedTool == .lasso{
            setToolBarForCanvas(tool: toolBarTools!.lasso)
        }
    }
    func getTool(tool: toolsE)->DrawingTool{
        if tool == .pen{
            return penTool
        }
        else if tool == .pencil{
            return pencilTool
        }
        else if tool == .highlighter{
            return highlighterTool
        }
        else{
            return penTool // Default to the pen tool just as a catch all
        }
    }
    func updateTool(tool: toolsE, mainColor: UIColor?, favorites: [UIColor]?, width: CGFloat?){
        // This is a very important function that will update the tool specified
        // We need to store the tool representations in ToolbarTools object and then from there we modify those and set
        // The tools to the proper location
        if tool == .pen{
            penTool.mainColor = mainColor ?? penTool.mainColor
            penTool.width = width ?? penTool.width
            penTool.favorites = favorites ?? penTool.favorites
        }
        else if tool == .pencil{
            pencilTool.mainColor = mainColor ?? pencilTool.mainColor
            pencilTool.width = width ?? pencilTool.width
            pencilTool.favorites = favorites ?? pencilTool.favorites
        }
        else if tool == .highlighter{
            highlighterTool.mainColor = mainColor ?? highlighterTool.mainColor
            highlighterTool.width = width ?? highlighterTool.width
            highlighterTool.favorites = favorites ?? highlighterTool.favorites
        }
    }
    func deleteColor(tool: toolsE, color: UIColor){
        // allows us to delete from favorites in the tool bar
        if tool == .pen{
            penTool.favorites.removeAll { $0 == color }
        }
        else if tool == .pencil{
            pencilTool.favorites.removeAll { $0 == color }
        }
        else if tool == .highlighter{
            highlighterTool.favorites.removeAll { $0 == color }
        }
    }
    func addNewPage(){
        let cv = Canvas(pageNumber: currentWorkingNote!.drawings.count)
        currentWorkingNote?.drawings.append(cv)
        // Need to reset tool bar after every added page due to the fact that we need to have the tool for the page be whatever the current tool is
        setToolBar()
    }
    func setCurrentNote(noteID: UUID){
        for note in allNotes{
            if note.id == noteID{
                currentWorkingNote = note
            }
        }
    }
    func checkLastPage(){
        // We use this function to be able to auto add a new last page if the last page is not empty
        if !currentWorkingNote!.drawings.last!.canvasView.drawing.strokes.isEmpty{
            addNewPage()
        }

    }
    func currentNoteSaving() {
        // We use this after we close currentWorkingNote to add the updated version of the note back to the array and replaces the old one if it exists.
        guard currentWorkingNote != nil else {
            return
        }
        currentWorkingNote!.dateLastModified = Date()
        if let index = allNotes.firstIndex(where: { $0.id == currentWorkingNote!.id }) {
            allNotes[index] = currentWorkingNote!
        }
    }
    func createNewNote(noteName: String, subject: Subject?){
        var newNote: Note
        if subject != nil{
            newNote = Note(name: noteName, dateCreated: Date(), dateLastModified: Date(), drawings: [Canvas(pageNumber: 0)], subject: subject, favorited: false,currentBackground: .NONE, imageData: [], textData: [])
        }
        else{
            newNote = Note(name: noteName, dateCreated: Date(), dateLastModified: Date(), drawings: [Canvas(pageNumber: 0)], favorited: false,currentBackground: .NONE, imageData: [], textData: [])
        }
        allNotes.insert(newNote, at: 0)
        setCurrentNote(noteID: allNotes.first!.id)
        setToolBar()
    }
    func removeNote(noteID: UUID) {
        allNotes.removeAll { note in
            note.id == noteID
        }
    }
    func favoriteNote(unfavorite: Bool){
        currentWorkingNote!.favorited = !unfavorite
        currentNoteSaving()
    }
    func renameNote(givenName: String) {
        currentWorkingNote!.name = givenName
        currentNoteSaving()
    }
    func changeBackgroundNote(background: Papers) {
        currentWorkingNote!.currentBackground = background
        currentNoteSaving()
        backgroundDidChange = true
    }
    func selectNewSubject(subjectGiven: Subject?){
        currentWorkingNote?.subject = subjectGiven
        currentNoteSaving()
    }
    func createSubjectIfNonExistent(subjectName: String){
        if let index = allSubjects.firstIndex(where: { $0.name == subjectName}) {
            currentWorkingNote!.subject = allSubjects[index]
            currentNoteSaving()
        }
        else{
            let sub = Subject(name: subjectName)
            allSubjects.append(sub)
            currentWorkingNote!.subject = sub
            currentNoteSaving()
        }
    }
    func deleteSubject(subject: Subject){
        allSubjects.removeAll(){subjectF in
            subjectF.id == subject.id
        }
        allNotes.removeAll { note in
            note.subject == subject
        }
    }
    func getNote(noteID: UUID) -> Note? {
        let note = allNotes.first { $0.id == noteID }
        return note
    }
    func setImages(){
        for im in selectedImages{
            currentWorkingNote!.imageData = currentWorkingNote!.imageData + [im] // adding the new image data types to the model
        }
        selectedItems = [PhotosPickerItem]() // reset selected items after we get all of the images
    }
    func updateImageForCurrentWorkingNote(imageID: UUID, height: CGFloat, width: CGFloat, x: CGFloat, y:CGFloat){
        // mainly used for when the user moves the image around or resizes it
        if let index = currentWorkingNote!.imageData.firstIndex(where: {$0.id == imageID}) {
            let old1 = currentWorkingNote!.imageData[index]
            let new1 = ImageData(image: old1.image, x: x, y: y, width: width, height: height, pageNum: old1.pageNum)
            currentWorkingNote!.imageData[index] = new1
        }
    }
    func updateTextForCurrentWorkingNote(textID: UUID, height: CGFloat, width: CGFloat, x: CGFloat, y: CGFloat, text: String?){
        // This is used for when the user moves there typed text around.
        if let index = currentWorkingNote!.textData.firstIndex(where: {$0.id == textID}){
            let old1 = currentWorkingNote!.textData[index]
            let new1 = TextData(text: text != nil ? text! : old1.text, x: x, y: y, width: width, height: height, pageNum: old1.pageNum, fontSize: old1.fontSize, color: old1.color, id: old1.id)
            currentWorkingNote!.textData[index] = new1
            selectedTextBlob = new1
        }
    }
    func updateColorForText(textID: UUID, color: UIColor){
        if let index = currentWorkingNote!.textData.firstIndex(where: {$0.id == textID}){
            let old1 = currentWorkingNote!.textData[index]
            let new1 = TextData(text: old1.text, x: old1.x, y: old1.y, width: old1.width, height: old1.height, pageNum: old1.pageNum, fontSize: old1.fontSize, color: color, id: old1.id)
            currentWorkingNote!.textData[index] = new1
        }    }
    func updateSizeForText(textID: UUID, fontSize: Int){
        if let index = currentWorkingNote!.textData.firstIndex(where: {$0.id == textID}){
            let old1 = currentWorkingNote!.textData[index]
            let new1 = TextData(text: old1.text, x: old1.x, y: old1.y, width: old1.width, height: old1.height, pageNum: old1.pageNum, fontSize: fontSize, color: old1.color, id: old1.id)
            currentWorkingNote!.textData[index] = new1
            selectedTextBlob = new1
        }
    }
    func imagesForPage(pageNum: Int) -> [ImageData]{
        // used so we can easily get the images that correspond to a page and since they are of ImageData type they also have size and location
        var fin: [ImageData] = []
        for im in currentWorkingNote!.imageData{
            if im.pageNum == pageNum{
                fin.append(im)
            }
        }
        return fin
    }
    func textForPage(pageNum: Int) -> [TextData]{
        // used so we can easily get the text that is associated with a page
        var fin: [TextData] = []
        for im in currentWorkingNote!.textData{
            if im.pageNum == pageNum{
                fin.append(im)
            }
        }
        return fin
    }
    func deleteImageFromCurrentWorkingNote(imageID: UUID){
        currentWorkingNote!.imageData.removeAll(where: {$0.id == imageID})
    }
    func deleteTextFromCurrentWorkingNote(textID: UUID){
        currentWorkingNote!.textData.removeAll(where: {$0.id == textID})
    }
    func createTextData(text: String, pageNumber: Int){
        currentWorkingNote!.textData.append(TextData(text: text, x: 400, y: 500, width: 200, height: 10, pageNum: pageNumber, fontSize: 24, color: UIColor.black, id: UUID()))
    }
}
