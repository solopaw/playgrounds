//
//  UIImageExtensions.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Returns a copy of the image scaled to size.
    ///
    /// - Parameter size: The size to scale the image to.
    ///
    /// - localizationKey: UIImage.scaledImage(size:)
    func scaledImage(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    // Returns an image for text.
    public static func image(text: String) -> UIImage {
        let defaultSize = CGSize(width: 23, height: 27) // default size for emoji with our chosen font and font size
        let textColor: UIColor =  #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        let fontName: FontName = .avenirNext
        let fontSize: Int = 20
        
        let font = UIFont(name: fontName.rawValue, size: CGFloat(fontSize)) ?? UIFont.systemFont(ofSize: CGFloat(fontSize))
        
        let sourceCharacter = text as NSString
        let attributes: [NSAttributedString.Key: Any] = [.font : font, .foregroundColor: textColor]
        var textSize = sourceCharacter.size(withAttributes: attributes)
        if textSize.width < 1 || textSize.height < 1 {
            textSize = defaultSize
        }
        UIGraphicsBeginImageContextWithOptions(textSize, false, 0.0)
        
        sourceCharacter.draw(in: CGRect(x:0, y:0, width:textSize.width,  height:textSize.height), withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    // Returns the memory allocation for the image in bytes.
    var memorySize: Int {
        guard let image = self.cgImage else { return 0 }
        return image.height * image.bytesPerRow
     }
}
