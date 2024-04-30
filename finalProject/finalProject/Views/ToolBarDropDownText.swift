//
//  ToolBarDropDownText.swift
//  finalProject
//
//  Created by Zak Young on 4/24/24.
//


import SwiftUI

struct ToolBarDropDownText: View {
    @EnvironmentObject var appHandler : AppHandler
    @State private var newColorChoice: Color = Color.black
    // https://developer.apple.com/tutorials/swiftui-concepts/defining-the-source-of-truth-using-a-custom-binding
    private var toolWidthBinding: Binding<CGFloat> {
        Binding<CGFloat>(
            get: {
                guard let fontSize = self.appHandler.selectedTextBlob?.fontSize else {
                    return 12
                }
                return CGFloat(fontSize)
            },
            set: { newValue in
                if let id = self.appHandler.selectedTextBlob?.id {
                    self.appHandler.updateSizeForText(textID: id, fontSize: Int(newValue))
                }
            }
        )
    }
    var body: some View {
        HStack(spacing: 20){
            ColorPicker("", selection: $newColorChoice, supportsOpacity: false)
                .labelsHidden()
                .frame(width: 35, height: 40)
                .onChange(of: newColorChoice){ oldVal, newVal in
                    appHandler.updateColorForText(textID: appHandler.selectedTextBlob!.id, color: UIColor(newColorChoice))
                }
                .padding(6)
            Spacer()
            Slider(value: toolWidthBinding, in: 8...60, step: 1)
                .frame(width: 200)
                .padding()
        }
    }
}

