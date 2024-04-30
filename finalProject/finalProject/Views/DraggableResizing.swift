//
//  DraggableResizing.swift
//  finalProject
//
//  Created by Zak Young on 4/22/24.
//

import SwiftUI

struct DraggableResizing: View {
    // https://www.hackingwithswift.com/books/ios-swiftui/moving-views-with-draggesture-and-offset
    //https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui
    @EnvironmentObject var appHandler: AppHandler
    var image: ImageData
    @State var size: CGSize
    @State var position: CGPoint
    @State private var resizingAllowed = false
    var prox: GeometryProxy
    var dist: CGFloat = 20
    @State var deleteOptionPresented: Bool = false
    var moveView: some Gesture {
        DragGesture()
            .onChanged { value in
                if resizingAllowed {
                    DispatchQueue.main.async { // faster wehn async
                        var xLoc = value.location.x - size.width / 2 //treating the image as if it was measuring based on top left corner
                        var yLoc = value.location.y - size.height / 2
                        if xLoc < 0 { // So we dont exceed the bounds of the canvas
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
            }
            .onEnded{ value in
                appHandler.updateImageForCurrentWorkingNote(imageID: image.id, height: self.size.height, width: self.size.width, x: self.position.x, y: self.position.y)
            }
    }
    var body: some View {
            ZStack {
                Image(uiImage: image.image)
                    .resizable()
                    .frame(width: size.width, height: size.height)
                    .border(resizingAllowed ? Color.blue : Color.clear, width: 2)
                    .position(position)
                    .onTapGesture {
                        resizingAllowed.toggle()
                        deleteOptionPresented = false
                    }
                if deleteOptionPresented{
                    VStack {
                        Button(role: .destructive) {
                            appHandler.deleteImageFromCurrentWorkingNote(imageID: image.id)
                        } label: {
                            Text("Delete Image")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                    .position(x: position.x, y: position.y - (size.height / 2 + 30))
                }
                if resizingAllowed{
                    // position.x-size.width/2 is because we start at the center and we want the x coordinate to be in the top left
                    // position.y-size.height/2 is because we start in the center and we need to go up by size.height/2
                    MoverPoint(pointLocation: CGPoint(x: (position.x - size.width / 2) - dist, y: (position.y - size.height / 2)-dist), forPoint: .topLeft , size: $size, image: image, position: $position)
                    MoverPoint(pointLocation: CGPoint(x: (position.x + size.width / 2) + dist, y: (position.y - size.height / 2)-dist), forPoint: .topRight, size: $size, image: image, position: $position)
                    MoverPoint(pointLocation: CGPoint(x: (position.x - size.width / 2) - dist, y: (position.y + size.height / 2)+dist), forPoint: .bottomLeft, size: $size, image: image, position: $position)
                    MoverPoint(pointLocation: CGPoint(x: (position.x + size.width / 2) + dist, y: (position.y + size.height / 2)+dist), forPoint: .bottomRight, size: $size, image: image, position: $position)
                }
            }
            .gesture(
                moveView
            )
            .onLongPressGesture(perform: {deleteOptionPresented.toggle()})

    }
}

struct MoverPoint: View {
    @EnvironmentObject var appHandler: AppHandler
    var pointLocation: CGPoint
    var forPoint: pointPlacement
    @Binding var size: CGSize
    var image: ImageData
    @Binding var position: CGPoint
    var body: some View {
        Circle()
            .frame(width: 30, height: 30)
            .foregroundColor(.blue)
            .position(pointLocation) // So this is the position the point will show up relative to the image
            .gesture(resizeGesture())
    }
    func resizeGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                DispatchQueue.main.async {
                    let scale: CGFloat = 0.2 // Allows for slowing of how quickly the image will be resized because we were having issues with it being too fast
                let scaledWidth = value.translation.width * scale
                let scaledHeight = value.translation.height * scale
                var tempWidth = size.width // temp vars so that we do not go negative size or too big size
                var tempHeight = size.height
                    switch forPoint {
                    case .topLeft:
                        tempWidth -= scaledWidth // Left needs to decrease image width and height when dragging left
                        tempHeight -= scaledHeight
                    case .topRight:
                        tempWidth += scaledWidth // When going right increase the width and when going left decrease
                        tempHeight -= scaledHeight
                    case .bottomLeft:
                        tempWidth -= scaledWidth
                        tempHeight += scaledHeight
                    case .bottomRight:
                        tempWidth += scaledWidth
                        tempHeight += scaledHeight
                    }
                    // we dont want the image to become too big or too small so we result to defaults if they try too
                    if tempWidth < 50{
                        size.width = 50
                    }
                    else if tempWidth > 800{
                        size.width = 800
                    }
                    else{
                        size.width = tempWidth
                    }
                    if tempHeight < 50{
                        size.width = 50
                    }
                    else if tempHeight > 1000{
                        size.height = 1000
                    }
                    else{
                        size.height = tempHeight
                    }
                }
            }
            .onEnded{ value in
                appHandler.updateImageForCurrentWorkingNote(imageID: image.id, height: size.height, width: size.width, x: position.x, y: position.y)
            }
    }
}
enum pointPlacement{
    case topRight
    case bottomRight
    case topLeft
    case bottomLeft
}

