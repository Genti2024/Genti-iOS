//
//  ImageGenerateRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import UIKit
import Photos

final class ImageGenerateRepositoryImpl: ImageGenerateRepository {
    
    let requsetService: RequestService
    let imageDataTransferService: ImageDataTransferService
    let uploadService: UploadService
    
    init(requsetService: RequestService, imageDataTransferService: ImageDataTransferService, uploadService: UploadService) {
        self.requsetService = requsetService
        self.imageDataTransferService = imageDataTransferService
        self.uploadService = uploadService
    }
    
    func getS3Key(from uiImage: UIImage) async throws -> String {
        let fileName = UUID().uuidString + ".JPG"
        let response: GetUploadImageUrlDTO = try await self.requsetService.fetchResponse(for: GeneratorRouter.getPresignedUrl(fileName: fileName, imageType: .verify))
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else { throw GentiError.clientError(code: "이미지변환오류", message: "다른이미지를사용해주세요") }
        guard let s3Key = try await self.uploadService.upload(s3Key: response.s3Key, imageData: imageData, presignedURLString: response.url) else { throw GentiError.clientError(code: "S3Key", message: "S3Key가 nil입니다")}
        return s3Key
    }
    
    func getS3Key(from phAsset: PHAsset?) async throws -> String? {
        guard let phAsset = phAsset else { return nil }
        let fileName = phAsset.value(forKey: "filename") as! String
        let response: GetUploadImageUrlDTO = try await self.requsetService.fetchResponse(for: GeneratorRouter.getPresignedUrl(fileName: fileName, imageType: .request))
        return try await uploadS3(dto: response, phAsset: phAsset)
    }
    
    func getS3Key(from phAssets: [PHAsset]) async throws -> [String] {
        let fileNames = phAssets.map { $0.value(forKey: "filename") as! String }
        let responses: [GetUploadImageUrlDTO] = try await self.requsetService.fetchResponse(for: GeneratorRouter.getPresignedUrls(fileNames: fileNames))
        
        async let firstFaceImage = uploadS3(dto: responses[0], phAsset: phAssets[0])
        async let secondFaceImage = uploadS3(dto: responses[1], phAsset: phAssets[1])
        async let thirdFaceImage = uploadS3(dto: responses[2], phAsset: phAssets[2])
        
        return try await [firstFaceImage, secondFaceImage, thirdFaceImage].compactMap{$0}
    }
    
    func uploadS3(dto: GetUploadImageUrlDTO, phAsset: PHAsset) async throws -> String? {
        let imageData = try await self.imageDataTransferService.requestImageData(for: phAsset)
        return try await self.uploadService.upload(s3Key: dto.s3Key, imageData: imageData, presignedURLString: dto.url)
    }
    
    func requestGenerateImage(prompt: String, poseURL: String?, faceURLs: [String], angle: PhotoAngle, coverage: PhotoFrame, ratio: PhotoRatio) async throws {
        try await requsetService.fetchResponse(for: GeneratorRouter.requestImage(prompt: prompt, poseURL: poseURL, faceURLs: faceURLs, angle: angle, coverage: coverage, ratio: ratio))
    }
    
    func verificationImage(faceURL: String) async throws {
        try await requsetService.fetchResponse(for: GeneratorRouter.verificationUser(faceURL: faceURL))
    }
    
}
