//
//  Trip+CoreDataClass.swift
//  Travelogue
//
//  Created by Megan Wilson on 11/18/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Trip)
public class Trip: NSManagedObject {
    var entries: [Entry]? {
        return self.rawEntries?.array as? [Entry]
    }
    
    convenience init?(title: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext
            else {
                return nil
            }
        
        self.init(entity: Trip.entity(), insertInto: context)
        self.tripTitle = title
    }
}
