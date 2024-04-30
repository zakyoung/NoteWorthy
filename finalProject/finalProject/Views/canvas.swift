import SwiftUI
import PencilKit

struct Canvas: UIViewRepresentable, Identifiable, Equatable {
    @EnvironmentObject var appHandler: AppHandler
    let id = UUID()
    var canvasView = PKCanvasView()
    var changeCount = 0
    var pageNumber: Int
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .pencilOnly // Not allowing finger drawing.
        canvasView.delegate = context.coordinator
        canvasView.contentSize = CGSize(width: 800, height: 1000)
        canvasView.isScrollEnabled = false
        canvasView.backgroundColor = UIColor.white
        if appHandler.currentWorkingNote!.currentBackground != .NONE{
            setupBackground()
        }
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if appHandler.backgroundDidChange{
            setupBackground()
            DispatchQueue.main.async {
                        self.appHandler.backgroundDidChange = false
                    }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func setupBackground() {
        guard let contentView1 = canvasView.subviews.first else { return }
        contentView1.subviews.forEach { subview in
            if subview is UIImageView && subview.tag == 1{ // Using tag = 1 so we only remove background
                subview.removeFromSuperview()
            }
        }
        let loc = appHandler.currentWorkingNote!.currentBackground
        let imageView = UIImageView(image: loc == .NONE ? UIImage(named: "white") : UIImage(named: loc.rawValue)) // Default to white background here
            imageView.frame = CGRect(x: 0, y: 0, width: canvasView.contentSize.width, height: canvasView.contentSize.height)
            canvasView.isOpaque = false
            canvasView.backgroundColor = UIColor.clear
            //https://stackoverflow.com/questions/59707784/swiftui-how-to-fix-attributegraph-cycle-detected-through-attribute-when-calli
            DispatchQueue.main.async {
                canvasView.becomeFirstResponder()
            }
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.tag = 1 // TAG 1 for background or 2 for placed image that way we dont remove the images only the background on a background change.
            let contentView = canvasView.subviews[0]
            contentView.addSubview(imageView)
            contentView.sendSubviewToBack(imageView)
    }
    func textImage(text: TextData) -> UIImage{
        // Here we are creating the text view just so we can use the image renderer to get an image of the text.
        var textView: some View {
            Text(text.text)
                .font(.system(size: CGFloat(text.fontSize), weight: .bold, design: .rounded))
                .foregroundStyle(Color(text.color))
                .frame(width: text.width, height: text.height)
                .fixedSize(horizontal: false, vertical: true)
        }
        //https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image
        let renderer = ImageRenderer(content: textView)
        return renderer.uiImage!
    }
    func thumbnailFromDrawing(thumbnailRect: CGRect, background: Papers, images: [ImageData], texts: [TextData]) -> UIImage? {
        // We use this thumbnail for exporting each of the pages to a pdf but also for the thumbnail displayed on the home screen
        let loc = background
        let drawing = canvasView.drawing
        let image = drawing.image(from: thumbnailRect, scale: 1.0) // getting the drawing data image
        var currentImage = compositeTwoImages(top: image, bottom: (background == .NONE ? UIImage(named: "white") : UIImage(named: loc.rawValue)!)!, img1Size: CGSize(width: 800, height: 1000), img2Size: CGSize(width: 800, height: 1000), img1Origin: CGPoint.zero, img2Origin: CGPoint.zero)
        for im in images.filter({$0.pageNum == pageNumber}){
                currentImage = compositeTwoImages(top: im.image, bottom: currentImage!, img1Size: CGSize(width: 800, height: 1000), img2Size: CGSize(width: im.width, height: im.height),img1Origin: CGPoint.zero, img2Origin: CGPoint(x: im.x-im.width/2, y: im.y-im.height/2))// So the reasoning behind subtracting the width and the height / 2 is that when we are moving it on the canvas we are dealing with the center as the coordinate however when we are calling the thumnail generation we are dealing with the upper left corner.
            }
        for txt in texts.filter({$0.pageNum == pageNumber}){
            let img = textImage(text: txt)
            currentImage = compositeTwoImages(top: img, bottom: currentImage!, img1Size: CGSize(width: 800, height: 1000), img2Size: CGSize(width: txt.width, height: txt.height), img1Origin: CGPoint.zero, img2Origin: CGPoint(x: txt.x-txt.width/2, y: txt.y-txt.height/2))
        }
            return currentImage
        }
    static func == (lhs: Canvas, rhs: Canvas) -> Bool {
        return lhs.canvasView.drawing == rhs.canvasView.drawing
    }
}

extension Canvas {
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: Canvas

        init(_ parent: Canvas) {
            self.parent = parent
        }
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // Here everytime after the canvasView has change we call to check the last page and if it isnt empty a new page willbe added
            self.parent.appHandler.checkLastPage()
            if self.parent.changeCount >= 20{ // This is how we are implementing auto saving where every 20 strokes we will save the note
                self.parent.appHandler.currentNoteSaving()
                self.parent.changeCount = 0
            }
            else{
                self.parent.changeCount += 1
            }
        }
    }
}

func compositeTwoImages(top: UIImage, bottom: UIImage, img1Size: CGSize, img2Size: CGSize, img1Origin: CGPoint, img2Origin: CGPoint) -> UIImage? {
    // https://stackoverflow.com/questions/1309757/blend-two-uiimages-based-on-alpha-transparency-of-top-image
    // This functin will combine two images into one.
    UIGraphicsBeginImageContextWithOptions(img1Size, false, 0.0)
    bottom.draw(in: CGRect(origin: img1Origin, size: img1Size))
    top.draw(in: CGRect(origin: img2Origin, size: img2Size))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}
