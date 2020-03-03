//
//  ImageFilter.swift
//  FaceFilter
//
//  Created by Manav on 03/03/20.
//  Copyright © 2020 Manav. All rights reserved.
//

import UIKit
import GPUImage
let serialQueue = DispatchQueue(label: "com.imagefilter")

enum ImageFilter: String, Identifiable, Hashable, CaseIterable {
    
    var id: ImageFilter { self }
    
    case `default` = "Default"
    case polkadot = "Polkadot"
    case vignette = "Vignette"
    case swirlDistortion = "Swirl Distortion"
    case solarize = "Solarize"
    case sketchFilter = "Sketch Filter"
    case zoomBlur = "Zoom Blur"
    case colorInversion = "Color Inversion"
    case emboss = "Emboss"
    case halftone = "Halftone"
    case haze = "Haze"
    case kuwahara = "Kuwahara"
    case luminance = "Luminance"
    case monochrome = "Monochrome"
    case pixellate = "Pixellate"
    case posterize = "Posterize"
    case sepia = "Sepia"
    case vibrance = "Vibrance"
    
    func performFilter(with image: UIImage, queue: DispatchQueue = serialQueue, completion: @escaping(UIImage?) -> ()) {
        queue.async {
            let pictureInput = PictureInput(image: image)
            let pictureOutput = PictureOutput()
            switch self {
            case .default:
                completion(image)
                return
                
            case .polkadot:
                pictureInput --> PolkaDot() --> pictureOutput
            case .vignette:
                pictureInput --> Vignette() --> pictureOutput
            case .swirlDistortion:
                pictureInput --> SwirlDistortion() --> pictureOutput
            case .solarize:
                pictureInput --> Solarize() --> pictureOutput
            case .sketchFilter:
                pictureInput --> SketchFilter() --> pictureOutput
            case .zoomBlur:
                pictureInput --> ZoomBlur() --> pictureOutput
            case .colorInversion:
                pictureInput --> ColorInversion() --> pictureOutput
            case .emboss:
                pictureInput --> EmbossFilter() --> pictureOutput
            case .halftone:
                pictureInput --> Halftone() --> pictureOutput
            case .haze:
                pictureInput --> Haze() --> pictureOutput
            case .kuwahara:
                pictureInput --> KuwaharaFilter() --> pictureOutput
            case .luminance:
                pictureInput --> Luminance() --> pictureOutput
            case .monochrome:
                pictureInput --> MonochromeFilter() --> pictureOutput
            case .pixellate:
                pictureInput --> Pixellate() --> pictureOutput
            case .posterize:
                pictureInput --> Posterize() --> pictureOutput
            case .sepia:
                pictureInput --> SepiaToneFilter() --> pictureOutput
            case .vibrance:
                pictureInput --> Vibrance() --> pictureOutput
            }
            
            pictureOutput.imageAvailableCallback = { image in
                let compressData = image.jpegData(compressionQuality: 0.5)
                let compressedImage = UIImage(data: compressData!)
                completion(compressedImage)
            }
            pictureInput.processImage(synchronously:true)
        }
    }
}
