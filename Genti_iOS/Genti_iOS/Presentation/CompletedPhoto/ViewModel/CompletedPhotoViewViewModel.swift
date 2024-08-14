//
//  PhotoCompleteViewViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/7/24.
//

import SwiftUI

@Observable
final class CompletedPhotoViewViewModel: ViewModel {

    var photoInfo: CompletedPhotoEntity
    var router: Router<MainRoute>
    var state: State
    
    let completedPhotoUseCase: CompletedPhotoUseCase
    
    init(photoInfo: CompletedPhotoEntity, router: Router<MainRoute>, completedPhotoUseCase: CompletedPhotoUseCase) {
        self.photoInfo = photoInfo
        self.router = router
        self.completedPhotoUseCase = completedPhotoUseCase
        self.state = .init()
    }

    struct State {
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
    }

    func sendAction(_ input: Input) {
        switch input {
        case .goToMainButtonTap:
            EventLogManager.shared.logEvent(.clickButton(pageName: "picdone", buttonName: "gomain"))
            self.state.showRatingView = true
        case .reportButtonTap:
            presentReportAlert()
        case .imageTap:
            navigateToPhotoExpandView()
        case .viewWillAppear:
            Task { await setImage() }
        case .downloadButtonTap:
            Task { await downloadImage() }
        case .ratingActionIsDone:
            self.router.dismissSheet()
        case .shareButtonTap:
            EventLogManager.shared.addUserPropertyCount(to: .shareButtonTap)
            EventLogManager.shared.logEvent(.clickButton(pageName: "picdone", buttonName: "picshare"))
        }
    }
    
    @MainActor
    func downloadImage() async {
        do {
            if await completedPhotoUseCase.downloadImage(to: state.image) {
                EventLogManager.shared.logEvent(.clickButton(pageName: "picdone", buttonName: "picdownload"))
                state.showToast = .success
            } else {
                state.showToast = .failure
            }
        }
    }
    
    @MainActor
    func setImage() async {
        do {
            let completedPhoto = await completedPhotoUseCase.loadImage(url: photoInfo.imageUrlString)
            state.image = completedPhoto
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

    private func navigateToPhotoExpandView() {
        guard let image = state.image else { return }
        EventLogManager.shared.logEvent(.enlargePhoto)
        self.router.routeTo(.photoDetail(image: image))
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
