//
//  ToolbarTools.swift
//  finalProject
//
//  Created by Zak Young on 3/26/24.
//
import Foundation
import PencilKit

struct ToolBarTools{
    var pencil: PKInkingTool
    var pen: PKInkingTool
    var highlighter: PKInkingTool
    var eraser: PKEraserTool
    var lasso: PKLassoTool
    
    init(pencil: PencilTool, pen: PenTool, highlighter: HighlighterTool, eraser: EraserTool, lasso: PKLassoTool) {
        self.pencil = PKInkingTool(.pencil, color: pencil.mainColor, width: pencil.width)
        self.pen = PKInkingTool(.pen, color: pen.mainColor, width: pen.width)
        self.highlighter = PKInkingTool(.marker, color: highlighter.mainColor, width: highlighter.width)
        self.eraser = PKEraserTool(eraser.eraserType, width: eraser.width)
        self.lasso = lasso
    }
}
struct ToolBarToolsEncodables: Codable {
    var pencil : PencilTool
    var pen : PenTool
    var highlighter : HighlighterTool
    var eraser : EraserTool
    enum CodingKeys: String, CodingKey {
        case pencil = "pencil"
        case pen = "pen"
        case highlighter = "highlighter"
        case eraser = "eraser"
    }
}
protocol DrawingTool {
    var mainColor: UIColor { get set }
    var favorites: [UIColor] { get set }
    var width: CGFloat { get set }
}
func encodeColorHelper(li: [UIColor])->[[CGFloat]]{
    var fin:[[CGFloat]] = []
    for color in li{
        let colorDataRaw = color.rgba
        let mainColor = [colorDataRaw.red, colorDataRaw.green, colorDataRaw.blue, colorDataRaw.alpha]
        fin.append(mainColor)
    }
    return fin
}
func decodeColorHelper(li:[[CGFloat]]) -> [UIColor]{
    var fin: [UIColor] = []
    for color in li{
        let col = UIColor(red: color[0], green: color[1], blue: color[2], alpha: color[3])
        fin.append(col)
    }
    return fin
}

extension UIColor {//TODO
    //https://www.hackingwithswift.com/example-code/uicolor/how-to-read-the-red-green-blue-and-alpha-color-components-from-a-uicolor
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}
