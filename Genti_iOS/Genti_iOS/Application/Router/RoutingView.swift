//
//  RoutingView.swift
//  Genti_iOS
//
//  Created by uiskim on 6/16/24.
//

import SwiftUI

struct RoutingView<Content: View, Destination: Route>: View {
    @State var router: Router<Destination>
    private let rootContent: (Router<Destination>) -> Content
    private let hasProgress: Bool
    private var totalPage: Int = 3
    
    public init(_ router: Router<Destination>, hasProgress: Bool = false , @ViewBuilder content: @escaping (Router<Destination>) -> Content) {
        self.router = router
        self.hasProgress = hasProgress
        self.rootContent = content
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            rootContent(router)
                .navigationDestination(for: Destination.self) { route in
                    router.view(from: route)
                }
        }
        .overlay {
            if hasProgress && self.router.path.count < totalPage {
                VStack {
                    VStack(spacing: 0) {
                        HStack {
                            Image(.backNew)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .background(.black.opacity(0.001))
                                .onTapGesture {
                                    if self.router.path.isEmpty {
                                        self.router.dismissSheet()
                                    } else {
                                        self.router.dismiss()
                                    }
                                }
                            
                            Spacer()
                            
                            Text("사진 만들기")
                                .pretendard(.subtitle1_18_bold)
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Text("\(self.router.path.count+1)/\(self.totalPage)")
                                .pretendard(.subtitle1_18_bold)
                                .foregroundStyle(.gentiGreenNew)
                        }
                        .frame(height: 44)
                        .padding(.horizontal, 16)
                        .background(.geintiBackground)
                        
                        ProgressView(value: Float(self.router.path.count+1), total: Float(self.totalPage))
                            .frame(maxWidth: .infinity)
                            .frame(height: 3)
                            .background(.gray5)
                            .tint(.gentiGreen)
                        
                    }

                    Spacer()
                }
                .animation(.easeInOut, value: self.router.path.count)
            }

        }
        .fullScreenCover(item: $router.presentingFullScreenCover) { route in
            router.view(from: route)
        }
    }
}
