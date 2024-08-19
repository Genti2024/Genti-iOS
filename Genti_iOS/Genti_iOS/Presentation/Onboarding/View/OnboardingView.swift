//
//  OnboardingView.swift
//  Genti_iOS
//
//  Created by uiskim on 7/8/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack {
            Image(.gentiLOGO)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: viewModel.state.step.setLogoWidth, height: viewModel.state.step.setLogoHight)
                .padding(.top, viewModel.state.step.setLogoTopPadding)
            
            Spacer()
            
            if viewModel.isFirstStep {
                VStack(spacing: 16) {
                    ForEach(viewModel.state.onboardingImage, id: \.self) {
                        Image($0)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 178)
                    }
                } //:VSTACK
                .transition(.move(edge: .leading))
            } else {
                Image(.onboardingSample)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 535)
                    .transition(.move(edge: .trailing))
            }

            
            Spacer()
            
            HStack(spacing: 15) {
                ForEach(OnboardingStep.allCases, id: \.self) { step in
                    Circle()
                        .fill(viewModel.setPageControl(from: step))
                        .frame(width: 9, height: 9)
                }
            }
            
            GentiPrimaryButton(title: viewModel.state.step.setButtonTitle, isActive: true) {
                viewModel.sendAction(.nextButtonTap)
            }
            .padding(.vertical, 18)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.snappy, value: viewModel.state.step)
        .background(alignment: .topTrailing) {
            ZStack {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                // Content
                if viewModel.isFirstStep {
                    Color.black.opacity(0.01)
                        .addXmark(top: 3, trailing: 20){
                            viewModel.sendAction(.xmarkTap)
                        }
                }
            } //:ZSTACK
        }
    }
}

#Preview {
    OnboardingView(viewModel: .init(router: .init()))
}
