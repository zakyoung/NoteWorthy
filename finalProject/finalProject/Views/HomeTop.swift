//
//  HomeTop.swift
//  finalProject
//
//  Created by Zak Young on 4/14/24.
//

import SwiftUI

struct HomeTop: View {
    @EnvironmentObject var appHandler: AppHandler
    @Binding var showingNewNoteAlert: Bool
    @Binding var name: String
    @Binding var displayNoteView: Bool
    var body: some View {
        HStack(alignment: .center){
                Spacer()
            Text((appHandler.selectedSubject != nil) ? appHandler.selectedSubject!.name : "All Notes")
                    .padding(.leading,45) // 45 becahce the width of the plus is 25 with 20 in trailing padding
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button{
                    showingNewNoteAlert.toggle()
        
                }
            label: {
                HStack{
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width:25, height:25)
                        .padding(.trailing,20)
                }
            }
            }
        .alert("Register a new note", isPresented: $showingNewNoteAlert) {
            TextField("Enter the note name", text: $name)
            Button("OK", action: {
                appHandler.createNewNote(noteName: name,subject: appHandler.selectedSubject)
                name = ""
                displayNoteView = true
                })
            .disabled(name.isEmpty)
        } message: {
            Text("A new note will be created")
        }
    }
}
