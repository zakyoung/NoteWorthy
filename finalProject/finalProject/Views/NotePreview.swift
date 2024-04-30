//
//  NotePreview.swift
//  finalProject
//
//  Created by Zak Young on 4/8/24.
//

import SwiftUI

struct NotePreview: View {
    @EnvironmentObject var appHandler: AppHandler
    var note: Note
    var body: some View {
        ZStack{
            VStack{
                if (note.drawings.first?.canvasView) != nil {
                    let thumbnailRect = CGRect(x: 0, y: 0, width: 800, height: 1000)
                    if let largeContentImage = note.drawings.first?.thumbnailFromDrawing(thumbnailRect: thumbnailRect, background: note.currentBackground,images: note.imageData, texts: note.textData) {
                        ZStack(alignment: .bottomLeading) {
                            Image(uiImage: largeContentImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: thumbnailRect.width / 3, height: thumbnailRect.height / 3)
                            VStack{
                                Spacer()
                                HStack{
                                    VStack{
                                        HStack{
                                            ScrollView(.horizontal){
                                                Text(((appHandler.getNote(noteID: note.id)?.name != nil) ? appHandler.getNote(noteID: note.id)?.name : note.name)!)
                                                    .font(.title)
                                                    .padding(.leading,10)
                                            }
                                            Spacer()
                                        }
                                        HStack{
                                            Text(note.dateCreated.formatted(date: .abbreviated, time: .omitted))
                                                .foregroundStyle(Color(red: 0.4, green: 0.4, blue: 0.4))
                                                .padding(.leading,10)
                                                .padding(.bottom, 4)
                                            Spacer()
                                        }
                                    }
                                }
                                .frame(width: thumbnailRect.width / 3)
                                .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                            }
                        }
                    } else {
                        VStack{
                            Text(note.name)
                                .font(.title)
                            Text(note.dateCreated.formatted())
                        }
                    }
                }
            }
            .border(Color(red: 0.93, green: 0.93, blue: 0.93), width: 5)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color(red: 0.93, green: 0.93, blue: 0.93), radius: 20)
        }
    }
}
