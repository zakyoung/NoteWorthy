//
//  DraggableResizingText.swift
//  finalProject
//
//  Created by Zak Young on 4/24/24.
//

import SwiftUI
struct DraggableResizingText: View {
    // https://www.hackingwithswift.com/books/ios-swiftui/moving-views-with-draggesture-and-offset
    //https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui
    @EnvironmentObject var appHandler: AppHandler
    var text: TextData
    @State var size: CGSize
    @State var position: CGPoint
    @State private var editingText: String = ""
    var prox: GeometryProxy
    var dist: CGFloat = 20
    @State var deleteOptionPresented: Bool = false
    private func commitChanges() {
        let font = UIFont.systemFont(ofSize: CGFloat(appHandler.selectedTextBlob != nil ? appHandler.selectedTextBlob!.fontSize : text.fontSize), weight: .bold)
        let characterSize = editingText.sizeUsingFont(usingFont: font)
        let maxWidth: CGFloat = 780
        let numberOfLines = ceil(characterSize.width / maxWidth)
        size.width = min(maxWidth, characterSize.width) + 10
        size.height = (characterSize.height * numberOfLines) + 10 // This is making the height dynamic based on the number of lines
        var xLoc = position.x - size.width / 2 // Identical to the DraggableResizngCode for how e calculate the upper left corner of the text and how we set defaults
        var yLoc = position.y - size.height / 2
        if xLoc < 0 {
            xLoc = 0
        } else if xLoc > prox.size.width - size.width {
            xLoc = prox.size.width - size.width
        }

        if yLoc < 0 {
            yLoc = 0
        } else if yLoc > prox.size.height - size.height {
            yLoc = prox.size.height - size.height
        }
        position = CGPoint(x: xLoc + size.width / 2, y: yLoc + size.height / 2)
        appHandler.updateTextForCurrentWorkingNote(textID: text.id, height: size.height, width: size.width, x: position.x, y: position.y, text: editingText)
    }

    func moveView() -> some Gesture {
        DragGesture()
            .onChanged { value in
                    DispatchQueue.main.async {
                        var xLoc = value.location.x - size.width / 2 //treating it as if it was measuring based on top left corner
                        var yLoc = value.location.y - size.height / 2
                        if xLoc < 0 {
                            xLoc = 0
                        }
                        //since xLoc is in the top left corner we need to check if that position - the width of the photo will be greater than the size of the canvas
                        else if xLoc > prox.size.width - size.width { // subtracting size.width because we want to make sure placing the image there will not extend beyond the boundary
                            xLoc = prox.size.width - size.width
                        }
                        if yLoc < 0 {
                            yLoc = 0
                        }
                        else if yLoc > prox.size.height - size.height {
                            yLoc = prox.size.height - size.height
                        }
                        self.position = CGPoint(x: xLoc + size.width / 2, y: yLoc + size.height / 2) // Yo so here we are ust adding back the width and the height we got rid of when doing xLoc and yLoc so that we are positining based on the center rather than the top left corner again
                    }
            }
            .onEnded{ value in
                appHandler.updateTextForCurrentWorkingNote(textID: text.id, height: self.size.height, width: self.size.width, x: self.position.x, y: self.position.y, text: nil)
                appHandler.selectedTextBlob = nil
            }
    }
    var body: some View {
            ZStack {
                if (appHandler.selectedTextBlob != nil && appHandler.selectedTextBlob!.id == text.id){
                    TextField("", text: $editingText, onCommit: {
                        commitChanges()
                        appHandler.selectedTextBlob = nil
                    })
                    .onChange(of: editingText) { oldState, newState in
                        // https://developer.apple.com/documentation/swiftui/view/onchange(of:initial:_:)-4psgg
                        commitChanges()
                    }
                    .font(.system(size: CGFloat(text.fontSize), weight: .bold, design: .rounded))
                    .foregroundStyle(Color(text.color))
                    .frame(width: text.width, height: size.height + 20)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 3)
                    )
                    .position(position)
                        .onTapGesture{
                            commitChanges()
                        }
                } else {
                    Text(text.text)
                        .font(.system(size: CGFloat(text.fontSize), weight: .bold, design: .rounded))
                        .foregroundStyle(Color(text.color))
                        .frame(width: size.width, height: size.height)
                        .position(position)
                        .onTapGesture{
                            editingText = text.text
                            appHandler.selectedTool = .text
                            appHandler.selectedTextBlob = text
                        }
                }
            }
            .gesture((appHandler.selectedTextBlob != nil && appHandler.selectedTextBlob!.id == text.id) ? nil : moveView())
    }
}

extension String
{
    //https://stackoverflow.com/questions/64452647/how-we-can-get-and-read-size-of-a-text-with-geometryreader-in-swiftui
   func sizeUsingFont(usingFont font: UIFont) -> CGSize
    {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
