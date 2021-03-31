//
//  PlaceModel.swift
//  Seyahat
//
//  Created by Macintosh HD on 24.01.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit

//singleton yapısı
 class PlaceModel {
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var PlaceLatitude = ""
    var PlaceLongitude = ""
    
    private init() {}
    
}
