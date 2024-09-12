//
//  PhotoCompleteViewViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/7/24.
//

import SwiftUI
import SDWebImageSwiftUI

@Observable
final class CompletedPhotoViewModel: ViewModel {

    var photoInfo: CompletedPhotoEntity
    var router: Router<MainRoute>
    var state: State
    
    let completedPhotoUseCase: CompletedPhotoUseCase
    
    init(photoInfo: CompletedPhotoEntity, router: Router<MainRoute>, completedPhotoUseCase: CompletedPhotoUseCase) {
        self.photoInfo = photoInfo
        self.router = router
        self.completedPhotoUseCase = completedPhotoUseCase
        self.state = .init(imageUrl: photoInfo.imageUrlString)
    }

    struct State {
        var imageUrl: String
        var image: UIImage? = nil
        var reportContent: String = ""
        var isLoading: Bool = false
        var showRatingView: Bool = false
        var showAlert: AlertType? = nil
        var showToast: ToastType? = nil
    }

    enum Input {
        case viewWillAppear
        case goToMainButtonTap
        case reportButtonTap
        case imageTap
        case downloadButtonTap
        case ratingActionIsDone
        case shareButtonTap
        case imageLoad(UIImage)
    }

    func sendAction(_ input: Input) {
        switch input {
        case .goToMainButtonTap:
            EventLogManager.shared.logEvent(.clickButton(page: .compltedPhoto, buttonName: "gomain"))
            self.state.showRatingView = true
        case .reportButtonTap:
            presentReportAlert()
        case .imageTap:
            EventLogManager.shared.logEvent(.enlargePhoto)
            self.router.routeTo(.photoDetail(imageUrl: self.state.imageUrl))
        case .downloadButtonTap:
            Task { await downloadImage() }
        case .ratingActionIsDone:
            if true {
                self.router.dismissSheet()
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "openChat"), object: nil)
            }
        case .shareButtonTap:
            EventLogManager.shared.addUserPropertyCount(to: .shareButtonTap)
            EventLogManager.shared.logEvent(.clickButton(page: .compltedPhoto, buttonName: "picshare"))
        case .imageLoad(let image):
            self.state.image = image
        case .viewWillAppear:
            EventLogManager.shared.logEvent(.seeCompletePhoto)
        }
    }
    
    @MainActor
    func downloadImage() async {
        do {
            
            if await completedPhotoUseCase.downloadImage(to: state.image) {
                EventLogManager.shared.logEvent(.clickButton(page: .compltedPhoto, buttonName: "picdownload"))
                state.showToast = .success
            } else {
                state.showToast = .failure
            }
        }
    }

    private func presentReportAlert() {
        state.showAlert = .report(
            action: { Task { await self.submitReport() } },
            cancelAction: { self.state.reportContent = "" },
            placeholder: "",
            text: .init(
                get: { [weak self] in self?.state.reportContent ?? "" },
                set: { [weak self] newText in self?.state.reportContent = newText }
            )
        )
    }

    @MainActor
    func submitReport() async {
        do {
            state.isLoading = true
            try await completedPhotoUseCase.reportPhoto(responseId: photoInfo.responseId, content: state.reportContent)
            state.reportContent = ""
            state.isLoading = false
            EventLogManager.shared.logEvent(.reportPhoto)
            state.showAlert = .reportComplete(action: { self.router.dismissSheet() })
        } catch(let error) {
            state.reportContent = ""
            state.isLoading = false
            guard let error = error as? GentiError else {
                state.showAlert = .reportUnknownedError(error: error, action: { self.router.dismissSheet() })
                return
            }
            state.showAlert = .reportGentiError(error: error, action: { self.router.dismissSheet() })
        }
    }
    
    var getImage: Image {
        if let image = self.state.image {
            return Image(uiImage: image)
        }
        return Image(uiImage: UIImage(resource: .camera))
    }
    
    var disabled: Bool {
        if let _ = self.state.image {
            return false
        }
        return true
    }
}
