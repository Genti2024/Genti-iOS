//
//  ImageGenerateRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import Foundation
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
    
    func getS3Key(from phAsset: PHAsset?) async throws -> String? {
        guard let phAsset = phAsset else { return nil }
        do {
            let fileName = phAsset.value(forKey: "filename") as! String
            let response: GetUploadImageUrlDTO = try await self.requsetService.fetchResponse(for: GeneratorRouter.getPresignedUrl(fileName: fileName))
            let imageData = try await imageDataTransferService.requestImageData(for: phAsset)
            return try await uploadService.upload(s3Key: response.s3Key, imageData: imageData, presignedURLString: response.url)
        } catch(let error) {
            
            throw GentiError.uploadFail(code: "AWS", message: "AWS에 한장 업로드 실패\(error.localizedDescription)")
        }
    }
    
    func getS3Key(from phAssets: [PHAsset]) async throws -> [String] {
        do {
            let fileNames = phAssets.map { $0.value(forKey: "filename") as! String }
            let responses: [GetUploadImageUrlDTO] = try await self.requsetService.fetchResponse(for: GeneratorRouter.getPresignedUrls(fileNames: fileNames))
            return try await withThrowingTaskGroup(of: String?.self) { group in
                for (dto, phAsset) in Array(zip(responses, phAssets)) {
                    group.addTask {
                        let imageData = try await self.imageDataTransferService.requestImageData(for: phAsset)
                        return try await self.uploadService.upload(s3Key: dto.s3Key, imageData: imageData, presignedURLString: dto.url)
                    }
                }
                
                return try await group
                    .reduce(into: [String?](), {$0.append($1)})
                    .compactMap{$0}
            }
        } catch(let error) {
            throw GentiError.uploadFail(code: "AWS", message: "AWS에 여러 장 업로드 실패 \(error.localizedDescription)")
        }
    }
    
    func requestGenerateImage(prompt: String, poseURL: String?, faceURLs: [String], angle: PhotoAngle, coverage: PhotoFrame, ratio: PhotoRatio) async throws {
        try await requsetService.fetchResponse(for: GeneratorRouter.requestImage(prompt: prompt, poseURL: poseURL, faceURLs: faceURLs, angle: angle, coverage: coverage, ratio: ratio))
    }
}
