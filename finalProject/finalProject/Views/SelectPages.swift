//
//  SelectPages.swift
//  finalProject
//
//  Created by Zak Young on 4/21/24.
//

import SwiftUI

struct SelectPages: View {
    @EnvironmentObject var appHandler: AppHandler
    @State var selectedPage: Int = 0
    var body: some View {
        VStack{
            Text("Select a page for the image")
                .font(.title)
            ScrollView {
                VStack {
                    ForEach(Array(appHandler.currentWorkingNote!.drawings.enumerated()), id: \.element.id) { index, page in
                        let thumbnailRect = CGRect(x: 0, y: 0, width: 800, height: 1000)
                        let largeContentImage = page.thumbnailFromDrawing(thumbnailRect: thumbnailRect, background: appHandler.currentWorkingNote!.currentBackground,images: appHandler.currentWorkingNote!.imageData, texts: appHandler.currentWorkingNote!.textData)
                        Image(uiImage: largeContentImage!)
                            .resizable()
                            .scaledToFit()
                            .frame(width:  thumbnailRect.width / 3, height:  thumbnailRect.height / 3)
                            .border(Color(red: 0.93, green: 0.93, blue: 0.93), width: 5)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color(red: 0.93, green: 0.93, blue: 0.93), radius: 20)
                            .padding(.bottom)
                            .onTapGesture {
                                Task {
                                    self.selectedPage = index
                                    appHandler.selectedImages.removeAll()
                                    for item in appHandler.selectedItems {
                                        if let image = try? await item.loadTransferable(type: Data.self) {
                                            if let uiImage = UIImage(data: image) {
                                                // Here we want to keep the same images scale but we want it to be less than the max size of 500x500 when adding it for the first time
                                                let width = uiImage.size.width // original heights and widths
                                                let height = uiImage.size.height
                                                var scaleFactor = 1.0
                                                let maxSize = 500.0 // dont want the height or width to exceed this right away but we give them the ability to resize the image later
                                                if width > maxSize || height > maxSize {
                                                    let widthFactor = maxSize / width // this tells us the factor we need to reduce the width by to get it under 500
                                                    let heightFactor = maxSize / height
                                                    scaleFactor = min(widthFactor, heightFactor) // Taking the smallest scaling factor to make sure both the height and width will be < 500
                                                }
                                                let scaledWidth = width * scaleFactor // scaling the width and height down
                                                let scaledHeight = height * scaleFactor
                                                // start location is 400, 500 because that is the halfway point
                                                appHandler.selectedImages.append(ImageData(image: uiImage, x: 400, y: 500, width: scaledWidth, height: scaledHeight, pageNum: selectedPage))
                                            }
                                        }
                                    }
                                    appHandler.setImages() // Need to reset the images on the pages after we add a new image.
                                }
                            }
                    }
                }
            }
        } 
    }
}

