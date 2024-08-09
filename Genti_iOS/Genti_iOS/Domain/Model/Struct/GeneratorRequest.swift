//
//  GeneratorRequest.swift
//  Genti
//
//  Created by uiskim on 6/2/24.
//

import Foundation

struct GeneratorRequest {
    var prompt: String
    var posePictureUrl: String?
    var facePictureUrlList: [String]
    var cameraAngle: String
    var shotCoverage: String
}
