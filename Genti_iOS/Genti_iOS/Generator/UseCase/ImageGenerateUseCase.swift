//
//  ImageGenerateUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import Foundation

protocol ImageGenerateUseCase {
    func requestImage(from userData: RequestImageData) async throws
}
