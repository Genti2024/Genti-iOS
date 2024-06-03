//
//  APIService.swift
//  Genti
//
//  Created by uiskim on 6/2/24.
//

import Alamofire
import Foundation
import Photos

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchResponse<T: Decodable>(for endpoint: URLRequestConvertible) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            API.session.request(endpoint)
//                .validate(statusCode: 200..<300)
                .responseDecodable(of: APIResponse<T>.self) { res in
                    switch res.result {
                    case .success(let apiResponse):
                        // response의 success가 true일때
                        if apiResponse.success {
                            guard let response = apiResponse.response else {
                                // response의 success가 true인데 response가 null일 경우
                                continuation.resume(throwing: GentiError.serverError(code: "SERVER", message: "Success인데 response가 null입니다"))
                                return
                            }
                            continuation.resume(returning: response)
                        } else {
                            // response의 success가 failure일때
                            continuation.resume(throwing: GentiError.serverError(code: apiResponse.errorCode, message: apiResponse.errorMessage))
                        }
                    case .failure(let error):
                        continuation.resume(throwing: GentiError.clientError(code: "CLIENT", message: "API자체가 failure입니다 fetchResponse를 확인하세요\nstatus Code : \(res.response!.statusCode)\n\(error.localizedDescription)"))
                    }
                }
        }
    }

    // 전체 업로드 프로세스
    func uploadPHAssetToS3(phAsset: PHAsset) async throws -> String? {
        do {
            let fileName = phAsset.value(forKey: "filename") as! String
            let response: GetUploadImageUrlDTO = try await self.fetchResponse(for: GeneratorRouter.getPresignedUrl(fileName: fileName))
            let imageData = try await requestImageData(for: phAsset)
            return try await uploadImageDataToS3(s3Key: response.s3Key, imageData: imageData, presignedURLString: response.url)
        } catch {
            throw GentiError.uploadFail(code: "AWS", message: "AWS에 업로드 실패")
        }
    }
    
    func uploadPHAssetToS3(phAssets: [PHAsset]) async throws -> [String?] {
        do {
            let fileNames = phAssets.map { $0.value(forKey: "filename") as! String }
            
            let responses: [GetUploadImageUrlDTO] = try await self.fetchResponse(for: GeneratorRouter.getPresignedUrls(fileNames: fileNames))
            
            let zippedArray = Array(zip(responses, phAssets))
            
            return try await withThrowingTaskGroup(of: String?.self) { group in
                for (dto, phAsset) in zippedArray {
                    group.addTask {
                        let imageData = try await self.requestImageData(for: phAsset)
                        return try await self.uploadImageDataToS3(s3Key: dto.s3Key, imageData: imageData, presignedURLString: dto.url)
                    }
                }
                
                var uploadResults = [String?]()
                for try await result in group {
                    uploadResults.append(result)
                }
                return uploadResults
            }
            
        } catch {
            throw GentiError.uploadFail(code: "AWS", message: "AWS에 여러 장 업로드 실패")
        }
    }
    
    fileprivate func requestImageData(for asset: PHAsset) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            requestOptions.deliveryMode = .highQualityFormat
            
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: requestOptions) { (imageData, dataUTI, orientation, info) in
                if let imageData = imageData {
                    continuation.resume(returning: imageData)
                } else {
                    continuation.resume(throwing: GentiError.clientError(code: "Unwrapping", message: "UIImage to Data변환 실패"))
                }
            }
        }
    }

    // 이미지 데이터를 Presigned URL을 사용하여 S3에 업로드하는 함수
    fileprivate func uploadImageDataToS3(s3Key: String?, imageData: Data, presignedURLString: String?) async throws -> String? {
        guard let urlString = presignedURLString, let presignedURL = URL(string: urlString) else { throw GentiError.clientError(code: "Unwrapping", message: "URL변환 실패")}
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(imageData, to: presignedURL, method: .put)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success:
                        continuation.resume(returning: s3Key)
                    case .failure:
                        continuation.resume(throwing: GentiError.uploadFail(code: "AWS", message: "AWS에 업로드 실패"))
                    }
                }
        }
    }
}
