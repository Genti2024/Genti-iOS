//
//  ImageGenerateRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import Foundation
import Photos

protocol ImageGenerateRepository {
    func getS3Key(from phAsset: PHAsset?) async throws -> String?
    func getS3Key(from phAssets: [PHAsset]) async throws -> [String]
    func requestGenerateImage(prompt: String, poseURL: String?, faceURLs: [String], angle: PhotoAngle, coverage: PhotoFrame, ratio: PhotoRatio) async throws
}
