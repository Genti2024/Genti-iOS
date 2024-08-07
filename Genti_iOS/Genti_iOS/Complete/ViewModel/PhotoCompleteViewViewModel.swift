//
//  PhotoCompleteViewViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/7/24.
//

import SwiftUI

@Observable
final class PhotoCompleteViewViewModel: ViewModel {

    var photoInfo: CompletePhotoEntity
    var router: Router<MainRoute>
    var state: State
    
    let imageRepository: ImageRepository
    let hapticRepository: HapticRepository
    let userRepository: UserRepository
    
    init(photoInfo: CompletePhotoEntity, router: Router<MainRoute>, imageRepository: ImageRepository, hapticRepository: HapticRepository, userRepository: UserRepository) {
        self.photoInfo = photoInfo
        self.router = router
        self.imageRepository = imageRepository
        self.hapticRepository = hapticRepository
        self.userRepository = userRepository
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
    }

    func sendAction(_ input: Input) {
        switch input {
        case .goToMainButtonTap:
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
        }
    }
    
    @MainActor
    func downloadImage() async {
        do {
            if await imageRepository.writeToPhotoAlbum(image: state.image) {
                hapticRepository.notification(type: .success)
                state.showToast = .success
            } else {
                hapticRepository.notification(type: .error)
                state.showToast = .failure
            }
        }
    }
    
    @MainActor
    func setImage() async {
        do {
            let image = await imageRepository.load(from: photoInfo.imageUrlString)
            state.image = image
            NotificationCenter.default.post(name: Notification.Name(rawValue: "profileReload"), object: nil)
        }
    }

    private func presentReportAlert() {
        state.showAlert = .report(
            action: { Task { await self.submitReport() } },
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
            try await userRepository.reportPhoto(responseId: self.photoInfo.responseId, content: self.state.reportContent)
            state.reportContent = ""
            state.isLoading = false
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
