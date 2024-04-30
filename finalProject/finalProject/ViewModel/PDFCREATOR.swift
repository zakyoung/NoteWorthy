//
//  PDFCREATOR.swift
//  finalProject
//
//  Created by Zak Young on 4/11/24.
//

import Foundation
import UIKit
import PencilKit
import PDFKit

func createPDF(from canvasViews: Note, background: Papers, images: [ImageData], texts: [TextData])->URL{
    var allDrawings: [Canvas] = []
    let noteDrawings = canvasViews.drawings
    // Here we are dropping the last one since the last page will always be blank.
    for drawin in noteDrawings.dropLast(1){
        allDrawings.append(drawin)
    }
    let pdfDocument = PDFDocument()
    //https://forums.developer.apple.com/forums/thread/717692
    //https://medium.com/@edenmomchilov/create-and-share-a-swiftui-generated-pdf-using-imagerenderer-549b6422d078
    for (index, canvas) in allDrawings.enumerated() {
        let thumbnailRect = CGRect(x: 0, y: 0, width: 800, height: 1000) // Size of the drawing view
        let drawing = canvas.thumbnailFromDrawing(thumbnailRect: thumbnailRect, background: background, images: images.filter({$0.pageNum == index}), texts: texts.filter({$0.pageNum == index}))
        let pdfPage = PDFPage(image: drawing!)
        pdfPage!.setBounds(CGRect(origin: CGPoint.zero, size: canvas.canvasView.bounds.size), for: .mediaBox)
        pdfDocument.insert(pdfPage!, at: index) 
    }
    let tempFolder = FileManager.default.temporaryDirectory // pdf will be stored in temp directory called tempFolder
    let fileName = canvasViews.name
    let fileURL = tempFolder.appendingPathComponent(fileName + ".pdf") // then we append the fileName to the temp directory
    if let data = pdfDocument.dataRepresentation() {
        do {
            try data.write(to: fileURL)  // yea so here Writing to the tempFolder and then returning the url so that it can be accessed easily by the share link
            return fileURL
        } catch {
            print("Error saving PDF: \(error)")
        }
    }
    return fileURL
}
