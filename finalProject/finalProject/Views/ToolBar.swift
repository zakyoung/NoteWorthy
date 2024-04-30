//
//  ToolBar.swift
//  finalProject
//
//  Created by Zak Young on 3/26/24.
//

import SwiftUI
import PencilKit
import PhotosUI

struct ToolBar: View {
    @EnvironmentObject var appHandler : AppHandler
    @Environment(\.undoManager) private var undoManager // this is the undo manager that we utilize to be able to undo and redo drawing changes. However this does not impact images or textBlobs
    @State private var bgColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1) // Background color for the tool bar
    @State private var penColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    @State private var showDropdown = true
    @State private var selectedBackground: Papers = .NONE
    @Binding var showDropdownBackground: Bool
    @Binding var showPageSelection: Bool
    @Binding var showTextInsertSelection: Bool
    @Binding var close: Bool
    @State private var showingDeleteAlert = false
    var toolBarHeight: CGFloat = 50.0
    var toolBarWidth: CGFloat = 655.0
    var buttonWidth: CGFloat = 30.0;
    var buttonHeight: CGFloat = 30.0;
    var paddingSpacing: CGFloat = 10
    private func commitChanges() { // We use this private functin to be able to commit the changes to the text blob that was modified.
        if appHandler.selectedTextBlob != nil{
            let font = UIFont.systemFont(ofSize: CGFloat(appHandler.selectedTextBlob!.fontSize), weight: .bold)
            let characterSize = appHandler.selectedTextBlob!.text.sizeUsingFont(usingFont: font)
            let maxWidth: CGFloat = 780
            let numberOfLines = ceil(characterSize.width / maxWidth)
            let width = min(maxWidth, characterSize.width) + 10
            let height = (characterSize.height * numberOfLines) + 10
            appHandler.updateTextForCurrentWorkingNote(textID: appHandler.selectedTextBlob!.id, height: height, width: width, x: appHandler.selectedTextBlob!.x, y: appHandler.selectedTextBlob!.y, text: appHandler.selectedTextBlob!.text)
            appHandler.selectedTextBlob = nil
        }
    }
    var body: some View {
        VStack(spacing: 0){
            HStack{
                VStack{
                    VStack{
                        Button(action: {
                            self.commitChanges()
                            appHandler.selectedTool = .pen
                            appHandler.setToolBar()
                        }) {
                            Image("customPen")
                                .resizable()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(Color(appHandler.penTool.mainColor))
                        }
                    }
                    .frame(width: buttonWidth , height: buttonHeight)
                    .padding(paddingSpacing)
                    .background(appHandler.selectedTool == .pen ? Color.gray.opacity(0.25) : Color.clear)
                    
                }
                
                VStack{
                    Button(action: {
                        self.commitChanges()
                        appHandler.selectedTool = .pencil
                        appHandler.setToolBar()
                    }) {
                        Image("Pencil")
                            .resizable()
                            .frame(width: buttonWidth, height: buttonHeight)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.yellow, Color.gray, Color.pink)
                    }
                    
                }
                .frame(width: buttonWidth , height: buttonHeight)
                .padding(paddingSpacing)
                .background(appHandler.selectedTool == .pencil ? Color.gray.opacity(0.25) : Color.clear)
                
                VStack{
                    Button(action: {
                        self.commitChanges()
                        appHandler.selectedTool = .highlighter
                        appHandler.setToolBar()
                    }) {
                        Image("highlighter")
                            .resizable()
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(Color.yellow)
                            .frame(width: buttonWidth, height: buttonHeight)
                    }
                }
                .frame(width: buttonWidth , height: buttonHeight)
                .padding(paddingSpacing)
                .background(appHandler.selectedTool == .highlighter ? Color.gray.opacity(0.25): Color.clear)
                
                VStack{
                    Image("customEraser")
                        .resizable()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color(red: 1.00, green: 0.08, blue: 0.58))
                    
                        .frame(width: buttonWidth, height: buttonHeight)
                        .onTapGesture {
                            self.commitChanges()
                            appHandler.selectedTool = .eraser
                            appHandler.setToolBar()
                        }
                }
                .frame(width: buttonWidth , height: buttonHeight)
                .padding(paddingSpacing)
                .background(appHandler.selectedTool == .eraser ? Color.gray.opacity(0.25) : Color.clear)
                VStack{
                    //https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-select-pictures-using-photospicker
                    PhotosPicker(selection: $appHandler.selectedItems, matching: .images)
                    {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: buttonWidth-5, height: buttonHeight-5)
                            .padding(paddingSpacing)
                            .background(appHandler.selectedTool == .photo ? Color.gray.opacity(0.25) : Color.clear)
                    }
                        .onChange(of: appHandler.selectedItems) {
                                showPageSelection.toggle()
                        }
                }
                VStack{
                    Image(systemName: "textformat") // when not in use use eraser.line.dashed
                        .resizable()
                        .frame(width: buttonWidth, height: buttonHeight)
                        .onTapGesture {
                            if appHandler.selectedTool != .text && appHandler.selectedTextBlob == nil{
                                appHandler.selectedTool = .text
                                showTextInsertSelection.toggle()
                            }
                            else{
                                appHandler.selectedTool = .pen
                                self.commitChanges()
                                appHandler.selectedTextBlob = nil
                                showTextInsertSelection = false
                            }
                        }
                }
                .frame(width: buttonWidth, height: buttonHeight)
                .padding(paddingSpacing)
                .background(appHandler.selectedTool == .text ? Color.gray.opacity(0.25) : Color.clear)
                
                VStack{
                    Image(systemName: "lasso")
                        .resizable()
                        .frame(width: buttonWidth, height: buttonHeight)
                        .onTapGesture {
                            self.commitChanges()
                            appHandler.selectedTool = .lasso
                            appHandler.setToolBar()
                        }
                }
                .frame(width: buttonWidth , height: buttonHeight)
                .padding(paddingSpacing)
                .background(appHandler.selectedTool == .lasso ? Color.gray.opacity(0.25) : Color.clear)
                Spacer()
                Image(systemName: "arrow.uturn.backward")
                    .resizable()
                    .frame(width: buttonWidth-5, height: buttonHeight-5)
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)
                    .onTapGesture {
                        undoManager?.undo()
                    }
                Image(systemName: "arrow.uturn.forward")
                    .resizable()
                    .frame(width: buttonWidth-5, height: buttonHeight-5)
                    .foregroundColor(.blue)
                    .padding(.trailing, 8)
                    .onTapGesture {
                        undoManager?.redo()
                    }
                Menu {
                    if let pdf = appHandler.currentWorkingNotePDF {
                            ShareLink(item: pdf) {
                                Label(
                                    title: { Text("Share PDF") },
                                    icon: {Image(systemName: "square.and.arrow.up").resizable()
                                    }
                                )
                            }
                        }
                    Button(action: {
                        showDropdownBackground.toggle()
                    }) {
                        Label(
                            title: { Text("Change Background") },
                            icon: {
                                Image(systemName: "photo.artframe")
                            }
                        )
                    }
                    Button(action: {
                        appHandler.favoriteNote(unfavorite: appHandler.currentWorkingNote!.favorited)
                    }) {
                        Label(
                            title: { Text(appHandler.currentWorkingNote!.favorited ? "Unfavorite Note" : "Favorite Note")},
                            icon: {
                                Image(systemName: appHandler.currentWorkingNote!.favorited ? "star.fill" : "star")
                            }
                        )
                    }
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label(
                            title: { Text("Delete Note") },
                            icon: { Image(systemName: "trash") }
                        )
                    }
                } label:
                {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: buttonWidth, height: buttonHeight)
                        .padding(.trailing, 10)
                        .foregroundColor(.blue)
                }
            }
            .onTapGesture {
               appHandler.currentWorkingNotePDF = createPDF(from: appHandler.currentWorkingNote!, background:
                                                                appHandler.currentWorkingNote!.currentBackground, images: appHandler.currentWorkingNote!.imageData, texts:appHandler.currentWorkingNote!.textData )
            }
            .frame(width: toolBarWidth, height: toolBarHeight)
            .alert("Are you sure you want to delete this note?", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    appHandler.removeNote(noteID: appHandler.currentWorkingNote!.id)
                    appHandler.saveNotes()
                    appHandler.saveToolBar()
                    close = false
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This cannot be undone")
            }
            if showDropdown{
                if (appHandler.selectedTool == .pen || appHandler.selectedTool == .pencil || appHandler.selectedTool == .highlighter) {
                    ToolBarDropDown(toolGiven: appHandler.selectedTool)
                        .frame(width: toolBarWidth, height: toolBarHeight)
                        .border(Color(UIColor.systemGray4), width: 2)
                        .background(Color(UIColor.systemGray6))
                        .padding(.bottom, 2)
                }
                else if (appHandler.selectedTool == .eraser){
                    ToolBarDropDownEraser()
                        .frame(width: toolBarWidth, height: toolBarHeight)
                        .border(Color(UIColor.systemGray4), width: 2)
                        .background(Color(UIColor.systemGray6))
                        .padding(.bottom, 2)
                }
                else if (appHandler.selectedTool == .text && appHandler.selectedTextBlob != nil){
                    ToolBarDropDownText()
                        .frame(width: toolBarWidth, height: toolBarHeight)
                        .border(Color(UIColor.systemGray4), width: 2)
                        .background(Color(UIColor.systemGray6))
                        .padding(.bottom, 2)
                }
            }
        }
    }
}
