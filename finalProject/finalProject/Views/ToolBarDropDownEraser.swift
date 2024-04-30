//
//  ToolBarDropDownEraser.swift
//  finalProject
//
//  Created by Zak Young on 4/1/24.
//

import SwiftUI

struct ToolBarDropDownEraser: View {
    @EnvironmentObject var appHandler : AppHandler
    private var toolWidthBinding: Binding<CGFloat> {
        Binding<CGFloat>(
            get: {
                return self.appHandler.eraserTool.width
            },
            set: { newValue in
                self.appHandler.eraserTool.width = newValue
                self.appHandler.selectedTool = .eraser
                self.appHandler.setToolBar()
            }
        )
    }
    var body: some View {
        HStack(spacing: 20){
            Button(action: {
                appHandler.eraserTool.eraserType = .vector
                appHandler.selectedTool = .eraser
                appHandler.setToolBar()
            }){
                HStack{
                    Image(systemName: "eraser.fill")
                        .foregroundColor(Color.white)
                    Text("Whole")
                        .foregroundColor(Color.white)
                }
                .padding(5)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(appHandler.eraserTool.eraserType == .vector ? Color.yellow : Color.clear, lineWidth: 2)
            )
            .padding(.leading, 10)
            Button(action: {
                appHandler.eraserTool.eraserType = .bitmap
                appHandler.selectedTool = .eraser
                appHandler.setToolBar()
            }){
                HStack{
                    Image(systemName: "eraser.line.dashed.fill")
                        .foregroundStyle(Color.white)
                    Text("Partial")
                        .foregroundColor(Color.white)
                }
                .padding(5)
                .background(Color.green)
                .cornerRadius(8)
            }
            .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(appHandler.eraserTool.eraserType != .vector ? Color.yellow : Color.clear, lineWidth: 2)
            )
            Spacer()
            if appHandler.eraserTool.eraserType == .bitmap{
                Slider(value: toolWidthBinding, in: 1...100, step: 1)
                    .frame(width: 200)
                    .padding()
            }
        }
    }
}

