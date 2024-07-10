//
//  OnboardingView.swift
//  Genti_iOS
//
//  Created by uiskim on 7/8/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Image(.gentiLOGO)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: viewModel.setLogoWidth, height: viewModel.setLogoHight)
                .padding(.top, viewModel.setLogoTopPadding)
            
            Spacer()
            
            if viewModel.isFirstStep {
                
                VStack(spacing: 16) {
                    Image(.onboarding11)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 178)
                        
                    
                    Image(.onboarding12)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 178)
                    
                    Image(.onboarding13)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 178)
                        
                    
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
            
            Text(viewModel.setButtonTitle)
                .pretendard(.headline1)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.green1)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.horizontal, 27)
                .padding(.bottom, 18)
                .padding(.top, 18)
                .asButton {
                    viewModel.sendAction(.nextButtonTap)
                }

        }
        .frame(maxWidth: .infinity)
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
