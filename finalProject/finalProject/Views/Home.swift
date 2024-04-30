//
//  Home.swift
//  finalProject
//
//  Created by Zak Young on 4/4/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var appHandler: AppHandler
    //These are for the 4 alerts
    @State private var showingSubjectAlert = false
    @State private var showingNewNoteAlert = false
    @State private var renameAlertShowing = false
    @State private var newSubjectCreator: Bool = false
    // This is the name that any of the changes will be written to temporarily
    @State private var name = ""
    // When this is true the navigation split view goes away and we only show the note view.
    @State private var displayNoteView = false
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    var body: some View {
        if displayNoteView == false{
            NavigationSplitView{
                    Button{
                        appHandler.selectedSubject = nil
                    }
                label: {
                    HStack{
                    Image(systemName: "note.text")
                            .resizable()
                            .frame(width: 17,height:17)
                            .padding(.leading, 20)
                    Text("All Notes")
                            .padding(.leading, 7)
                    Spacer()
                    }
                }
                .frame(height: 50)
                .background(appHandler.selectedSubject == nil ? Color(red: 0.90, green: 0.90, blue: 0.90) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                HStack{
                    Text("Subjects")
                    Spacer()
                    Button{
                        showingSubjectAlert.toggle()
                    }
                label: {
                    HStack{
                        Spacer()
                        Image(systemName: "plus")
                    }
                }
                    
                    Spacer()
                }
                .alert("Enter the subject name", isPresented: $showingSubjectAlert) {
                    TextField("Enter the subject name", text: $name)
                    Button("OK", action: {appHandler.allSubjects.insert(Subject(name: name), at: 0)
                                            name = ""})
                    .disabled(name.isEmpty)
                } message: {
                    Text("A new subject will be created")
                }
                .padding()
                HomeSubjects()
            } detail: {
                HomeTop(showingNewNoteAlert: $showingNewNoteAlert,name: $name, displayNoteView: $displayNoteView)
                Picker("Sort By", selection: $appHandler.sortMethods) {
                        ForEach(SortBy.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(appHandler.notesForSubject(subject: appHandler.selectedSubject, sortBy: appHandler.sortMethods), id: \.id) { note in
                                NotePreview(note: note)
                                    .onTapGesture {
                                        appHandler.currentWorkingNote = note
                                        appHandler.selectedTool = .pen
                                        appHandler.setToolBar()
                                        displayNoteView = true
                                    }
                                    .contextMenu{
                                        Button("Rename") {
                                            appHandler.currentWorkingNote = note
                                            renameAlertShowing = true
                                        }
                                        Button("Change Subject"){
                                            appHandler.currentWorkingNote = note
                                            newSubjectCreator = true
                                        }
                                        if !note.favorited{
                                            Button("Favorite") {
                                                appHandler.currentWorkingNote = note
                                                appHandler.favoriteNote(unfavorite: false)}
                                        }
                                        else{
                                            Button("Unfavorite") {
                                                appHandler.currentWorkingNote = note
                                                appHandler.favoriteNote(unfavorite: true)}
                                        }
                                        Button(role: .destructive){appHandler.removeNote(noteID: note.id)} label: {Text("Delete")}
                                    }
                                    .alert("Rename your note", isPresented: $renameAlertShowing) {
                                        TextField("Enter the note name", text: $name)
                                        Button("Set Name", action: {
                                            appHandler.renameNote(givenName: name)
                                            name = ""

                                            })
                                        .disabled(name.isEmpty)
                                    } message: {
                                        Text("Type in the new name for your note")
                                    }
                            }
                        }
                            .padding()
                    }
                    .alert("Assign new Subject", isPresented: $newSubjectCreator) {
                        TextField("Enter Subject Name", text: $name)
                        Button("Set Subject", action: {
                            appHandler.createSubjectIfNonExistent(subjectName: name)
                            name = ""
                            })
                        .disabled(name.isEmpty)
                    } message: {
                        Text("Enter the name of the subject or a new subject")
                    }
            }
        }
        
        if displayNoteView == true{
            withAnimation{
                NoteView(close: $displayNoteView)
            }.transition(.scale)
        }
    }
}

#Preview {
    Home()
        .environmentObject(AppHandler())
}
 
