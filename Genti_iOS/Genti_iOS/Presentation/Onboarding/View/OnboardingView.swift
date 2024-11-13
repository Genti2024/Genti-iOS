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
        ZStack {
            if viewModel.state.step != .third {
                Color.geintiBackground
                    .ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                    .frame(height: 40)
                
                if viewModel.state.step == .first {
                    Image(.onboardingOne)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 424)
                } else if viewModel.state.step == .second {
                    Image(.onboardingTwo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 424)
                }
            }
            

            

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.snappy, value: viewModel.state.step)
        .background {
            ZStack {
                Color.geintiBackground
                    .ignoresSafeArea()
                if viewModel.state.step == .third {
                    Image(.aNew)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }

        }
        .overlay {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Image(.xmarkNew)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.6)
                        .frame(width: 14, height: 14)
                        .padding(7)
                        .padding(.trailing, 16)
                        .onTapGesture {
                            self.viewModel.sendAction(.xmarkTap)
                        }
                }
                
                VStack(spacing: 0) {
                    
                    Spacer()
                        .frame(height: 34)
                    
                    Text(viewModel.state.step.title)
                        .pretendard(.body_14_bold)
                        .foregroundStyle(.gentiGreenNew)
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Text(viewModel.state.step.subtitle)
                        .pretendard(.title1_24_bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                        .frame(height: 8)
                    
                    Text(viewModel.state.step.description)
                        .pretendard(.body_14_medium)
                        .foregroundStyle(.white.opacity(0.6))
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    ForEach(OnboardingStep.allCases, id: \.self) { step in
                        Circle()
                            .fill(viewModel.setPageControl(from: step))
                            .frame(width: viewModel.set(from: step), height: viewModel.set(from: step))
                    }
                }
                
                Spacer()
                    .frame(height: 48)
                
                GentiPrimaryButton(title: viewModel.state.step.setButtonTitle, isActive: true) {
                    viewModel.sendAction(.nextButtonTap)
                }
            }
        }
    }
}

#Preview {
    OnboardingView(viewModel: .init(router: .init()))
}
