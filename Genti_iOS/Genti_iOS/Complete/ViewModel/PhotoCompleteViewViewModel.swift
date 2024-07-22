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
        var showAlert: AlertType? = nil {
            didSet {
                self.reportContent = ""
            }
        }
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
            showRatingView()
        case .reportButtonTap:
            presentReportAlert()
        case .imageTap:
            navigateToPhotoExpandView()
//        case .ratingViewSkipButtonTap:
//            dismissRatingView()
//        case .ratingViewSubmitButtonTap:
//            submitRating()
//        case .ratingViewStarTap(let rating):
//            updateRating(rating)
        case .viewWillAppear:
            Task {
                do {
                    let image = await imageRepository.load(from: photoInfo.imageUrlString)
                    await MainActor.run {
                        state.image = image
                    }
                }
                
            }
        case .downloadButtonTap:
            Task {
                do {
                    if await imageRepository.writeToPhotoAlbum(image: state.image) {
                        hapticRepository.notification(type: .success)
                    } else {
                        hapticRepository.notification(type: .error)
                    }
                }
            }
        case .ratingActionIsDone:
            self.router.dismissSheet()
        }
    }

    private func showRatingView() {
        state.showRatingView = true
    }

    private func presentReportAlert() {
        state.showAlert = .report(
            action: { [weak self] in
                self?.submitReport()
            },
            placeholder: "",
            text: .init(
                get: { [weak self] in self?.state.reportContent ?? "" },
                set: { [weak self] newText in self?.state.reportContent = newText }
            )
        )
    }

    private func submitReport() {
        Task {
            do {
                await MainActor.run {
                    state.isLoading = true
                }
                _ = try await userRepository.reportPhoto(id: self.photoInfo.id, content: self.state.reportContent)
                await MainActor.run {
                    state.isLoading = false
                    state.showAlert = .reportComplete
                }
            } catch {
                
            }
        }
    }

    private func navigateToPhotoExpandView() {
        guard let image = state.image else { return }
        self.router.routeTo(.photoDetail(image: image))
    }

    private func dismissRatingView() {
        router.dismissSheet()
    }

    private func submitRating() {
        Task {
            state.isLoading = true
            try await Task.sleep(nanoseconds: 1_000_000_000)
            state.isLoading = false
            router.dismissSheet()
        }
    }

    private func updateRating(_ rating: Int) {
//        state.rating = rating
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
