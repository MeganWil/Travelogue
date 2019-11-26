//
//  Entry+CoreDataClass.swift
//  Travelogue
//
//  Created by Megan Wilson on 11/18/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Entry)
public class Entry: NSManagedObject {
    var date: Date?{
        get {
            return rawDate as Date?
        }
        set {
            rawDate = newValue as NSDate?
        }
    }
    
    var image: UIImage? {
        get {
            if let imageData = picture as Data? {
                return UIImage(data: imageData)
            }
            else {
                return nil
            }
        }
        set {
            if let image = newValue {
                picture = convertImage(image: image)
            }
        }
    }
    
    func convertImage(image: UIImage) -> NSData? {
        if (image.imageOrientation == .up) {
            return image.pngData() as NSData?
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size), blendMode: .copy, alpha: 1.0)
        
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        guard let unwrappedCopy = copy
            else {
                return image.pngData() as NSData?
            }
        return unwrappedCopy.pngData() as NSData?
    }
    
    convenience init?(entryTitle :String, text: String?, date:Date, image: UIImage?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext
            else {
                return nil
            }
        self.init(entity:Entry.entity(), insertInto: context)
        self.entryTitle = entryTitle
        self.text = text
        self.date = date
        
        if let image = image {
            self.picture = convertImage(image: image)
        }
    }
    
    func update(entryTitle: String?, text: String?, date: Date?, image: UIImage?){
        self.entryTitle = entryTitle
        self.date = date
        self.text = text
        
        if let image = image {
            self.picture = convertImage(image: image)
        }
    }

}
