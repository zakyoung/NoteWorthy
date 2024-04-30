//
//  SelectPagesText.swift
//  finalProject
//
//  Created by Zak Young on 4/24/24.
//

import SwiftUI

struct SelectPagesText: View {
    @EnvironmentObject var appHandler: AppHandler
    @State var selectedPage: Int = 0
    @Binding var openView: Bool
    var body: some View {
        VStack{
            Text("Select a page for the text")
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
                                    appHandler.createTextData(text: "Enter text here", pageNumber: index)
                                    openView = false
                                }
                            }
                    }
                }
            }
        }
    }
}

