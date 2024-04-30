//
//  ToolBarDropDown.swift
//  finalProject
//
//  Created by Zak Young on 3/26/24.
//

import SwiftUI

struct ToolBarDropDown: View {
    var toolGiven : toolsE?
    @EnvironmentObject var appHandler : AppHandler
    @State private var newColorChoice: Color = Color.yellow
    private var toolWidthBinding: Binding<CGFloat> { // Using a custom binding to get the values for the colors and width that should be included in the dropdown
           Binding<CGFloat>(
               get: {
                   switch self.appHandler.selectedTool {
                   case .pen:
                       return self.appHandler.penTool.width
                   case .pencil:
                       return self.appHandler.pencilTool.width
                   case .highlighter:
                       return self.appHandler.highlighterTool.width
                   default:
                       return 0
                   }
               },
               set: { newValue in
                   switch self.appHandler.selectedTool {
                   case .pen:
                       self.appHandler.penTool.width = newValue
                   case .pencil:
                       self.appHandler.pencilTool.width = newValue
                   case .highlighter:
                       self.appHandler.highlighterTool.width = newValue
                   default:
                       break
                   }
                   self.appHandler.setToolBar()
               }
           )
       }
    var body: some View {
        HStack(spacing: 10) {
            ScrollView(.horizontal){
                HStack{
                    ColorPicker("", selection: $newColorChoice, supportsOpacity: true) // Opacity with the Color picker is allowed
                        .labelsHidden()
                        .frame(width: 35, height: 40)
                        .onChange(of: newColorChoice){ oldVal, newVal in
                            // When there is a new color changed we need to update the tool to refelct this for the canvases
                            appHandler.updateTool(tool: toolGiven!, mainColor: UIColor(newVal), favorites: appHandler.getTool(tool: toolGiven!).favorites, width: nil)
                            appHandler.setToolBar()
                        }
                        .contextMenu(ContextMenu(menuItems: {
                            Button("Add to favorites") {
                                let favs = appHandler.getTool(tool: toolGiven!).favorites + [UIColor(newColorChoice)]
                                appHandler.updateTool(tool: toolGiven!, mainColor: UIColor(newColorChoice), favorites: favs, width: nil)
                                appHandler.setToolBar()
                            }
                        }))
                    ForEach(appHandler.getTool(tool: toolGiven!).favorites, id: \.self){ fav in
                        Button(action: {
                            appHandler.updateTool(tool: toolGiven!, mainColor: fav, favorites: nil, width: nil)
                            appHandler.setToolBar()
                        }) {
                            if fav == appHandler.getTool(tool: toolGiven!).mainColor{
                                Circle()
                                    .foregroundStyle(Color(fav))
                                    .frame(width: 30,height: 40)
                                    .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                    )
                                    .overlay(
                                    Circle()
                                        .stroke(Color.blue, lineWidth: 2)
                                    )
                            }
                            else{
                                Circle()
                                    .foregroundStyle(Color(fav))
                                    .frame(width: 30,height: 40)
                            }
                            
                        }
                        .contextMenu {
                            Button(action: {
                                appHandler.deleteColor(tool: toolGiven!, color: fav)
                            }) {
                                Label("Delete Favorite", systemImage: "trash")
                                    .background(Color.red)
                            }
                        }
                    }
                }
            }
            .padding(.leading, -10)
            Spacer()
            Slider(value: toolWidthBinding, in: 1...100, step: 1)
                .frame(width: 200)
                .padding()
            }
                .padding()
                .cornerRadius(10)
                .shadow(radius: 5)
    }
}
