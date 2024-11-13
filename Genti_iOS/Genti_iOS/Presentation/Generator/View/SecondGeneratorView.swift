//
//  SecondGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

import PopupView

enum Ratio: CaseIterable {
    case garo, sero
    
    var title: String {
        switch self {
        case .garo:
            return "가로 사진"
        case .sero:
            return "세로 사진"
        }
    }
    
    var subtitle: String {
        switch self {
        case .garo:
            return "2:3 비율"
        case .sero:
            return "3:2 비율"
        }
    }
    
    var image: String {
        switch self {
        case .garo:
            return "garo"
        case .sero:
            return "sero"
        }
    }
}

struct SecondGeneratorView: View {
    @State var viewModel: SecondGeneratorViewModel
    
    var body: some View {
        ZStack {
            // Background Color
            Color.geintiBackground
                .ignoresSafeArea()
            // Content
            VStack(spacing: 30) {
                
                Text("사진 비율을 선택해주세요.")
                    .pretendard(.title2_20_bold)
                    .foregroundStyle(.white)
                
                HStack(spacing: 8) {
                    ForEach(Ratio.allCases, id: \.self) { ratio in
                        GentiBorderButton(title: ratio.title, isActive: self.viewModel.state.selectedRatio == ratio, selectedImageAssetName: ratio.image, nonSelectedImageAssetName: ratio.image, smallImage: false, subtitle: ratio.subtitle) {
                            viewModel.sendAction(.ratioTap(ratio))
                        }
                    }
                }
                
            } //:VSTACK
        } //:ZSTACK
        .overlay(alignment: .bottom) {
            nextButtonView()
        }
        .onAppear {
            self.viewModel.sendAction(.viewWillAppear)
        }
        .toolbar(.hidden, for: .navigationBar)

    }
    
    private func nextButtonView() -> some View {
        GentiPrimaryButton(title: "다음으로", isActive: viewModel.isActive) {
            viewModel.sendAction(.nextButtonTap)
        }
        .onTapGesture {
            if !viewModel.isActive {
                viewModel.sendAction(.disabledButtonTap)
            }
        }
    }
}

#Preview {
    SecondGeneratorView(viewModel: SecondGeneratorViewModel(requestImageData: .init(), router: .init(), userdefaultRepository: UserDefaultsRepositoryImpl()))
}


