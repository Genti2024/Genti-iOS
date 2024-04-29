//
//  GeneratorViewModel.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import Combine

final class GeneratorViewModel: ObservableObject {
    // firstView
    @Published var photoDescription: String = ""
    @Published var referenceImage: ImageAsset? = nil
    @Published var showPhotoPicker: Bool = false
    
    var descriptionIsEmpty: Bool {
        return !photoDescription.isEmpty
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    lazy var textEditorLimit: Binding<String> = .init {
        return self.photoDescription
    } set: {
        self.photoDescription = String($0.prefix(20))
    }
    
    func setImageAsset(asset: ImageAsset) {
        self.referenceImage = asset
    }
    
    func removeReferenceImage() {
        self.referenceImage = nil
    }
    
    
    // secondView
    @Published var selectedAngle: PhotoAngle? = nil
    @Published var selectedFrame: PhotoFrame? = nil
    
    var angleAndFrameSelected: Bool {
        return selectedAngle != nil && selectedFrame != nil
    }
}
