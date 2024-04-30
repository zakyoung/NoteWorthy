//
//  NoteMainContent.swift
//  finalProject
//
//  Created by Zak Young on 4/24/24.
//


import SwiftUI

struct NoteMainContent: View {
    @EnvironmentObject var appHandler: AppHandler
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 25) {
                Text(appHandler.currentWorkingNote!.name)
                    .font(.custom("TimesNewRomanPSMT", fixedSize: 34))
                    .padding(.leading, 20)
                ForEach(appHandler.currentWorkingNote!.drawings, id: \.id) { canvas in
                    GeometryReader { proxy in
                        //https://www.hackingwithswift.com/books/ios-swiftui/understanding-frames-and-coordinates-inside-geometryreader
                        ZStack{
                            canvas
                                .frame(width: 800, height: 1000)
                            ForEach(appHandler.imagesForPage(pageNum: canvas.pageNumber)){ imageDat in // Using the imagesForPage funciton to add an image on top of the page in the location with the size
                                DraggableResizing(image: imageDat, size: CGSize(width: imageDat.width, height: imageDat.height), position: CGPoint(x: imageDat.x, y: imageDat.y), prox: proxy)
                            }
                            ForEach(appHandler.textForPage(pageNum: canvas.pageNumber)){ textDat in // Using the textForPage function to add text on top of the canvas
                                DraggableResizingText(text: textDat, size: CGSize(width: textDat.width, height: textDat.height), position: CGPoint(x: textDat.x, y: textDat.y), prox: proxy)
                            }
                        }
                        .frame(width: 800, height: 1000)
                        .coordinateSpace(name: "note")

                    }
                    .frame(width: 800, height: 1000)
                    .padding(.horizontal, (UIScreen.main.bounds.width - 800) / 2)
                }
            }
            .padding(.horizontal, 100)
        }
    }
}
