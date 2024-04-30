//
//  Note.swift
//  finalProject
//
//  Created by Zak Young on 4/1/24.
//

import SwiftUI

import SwiftUI
import PencilKit
import UIKit
struct NoteView: View {
    @EnvironmentObject var appHandler: AppHandler
    @Binding var close: Bool
    @State private var showDropdown = false
    @State var showPageSelection: Bool = false
    @State var showTextInsertSelection: Bool = false
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Button(action: {
                    appHandler.selectedTextBlob = nil
                        appHandler.currentNoteSaving()
                        appHandler.saveNotes()
                        appHandler.saveToolBar()
                    close = false}, label: {
                    Text("Close")
                        .foregroundStyle(.white)
                })
                .padding(10)
                .background(.blue)
                .cornerRadius(5)
                .padding(.leading,20)
                Spacer()
            }
            .frame(height: 30)
            .padding(0)
            HStack{
                Spacer()
                ToolBar(showDropdownBackground: $showDropdown, showPageSelection: $showPageSelection, showTextInsertSelection: $showTextInsertSelection, close: $close)
                    .border(Color(UIColor.systemGray4), width: 2)
                    .background(Color(UIColor.systemGray6))
                    .frame(width: 600, height: 200)
                    .padding(.trailing,40)
                Spacer()
            }
            .padding(0)
            NoteMainContent()
            .background(Color(UIColor.systemGray5))
            .overlay(
                Group{
                    if showTextInsertSelection{
                        SelectPagesText(openView: $showTextInsertSelection)
                            .frame(width: 400, height: 450)
                            .background(Color(UIColor.systemGray4))
                            .cornerRadius(5)
                            .padding()
                            .offset(y: -250)
                            .offset(x: 0)
                    }
                }
            )
        }
            .background(Color(UIColor.systemGray5))
            .overlay(
                Group {
                               if showDropdown {
                                   DropDownMenu(showDropdown: $showDropdown)
                                       .frame(width: 400, height: 450)
                                       .background(Color(UIColor.systemGray6))
                                       .cornerRadius(5)
                                       .padding()
                                       .offset(y: 175)
                                       .offset(x: -175)

                               }
                           }, alignment: .topTrailing
                        )
            .overlay(
                Group{
                    if showPageSelection{
                        SelectPages()
                            .frame(width: 400, height: 450)
                            .background(Color(UIColor.systemGray4))
                            .cornerRadius(5)
                            .padding()
                            .offset(y: -160)
                            .offset(x: 0)
                    }
                }
            )
    }
}
