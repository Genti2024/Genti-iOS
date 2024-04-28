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
    @Published var referenceImage: Image? = nil
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
}
