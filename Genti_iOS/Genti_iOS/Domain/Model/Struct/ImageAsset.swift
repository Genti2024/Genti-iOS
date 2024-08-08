//
//  ImageAsset.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import PhotosUI

struct ImageAsset: Identifiable {
    var id: String = UUID().uuidString
    var asset: PHAsset
    var assetIndex: Int = -1
}
