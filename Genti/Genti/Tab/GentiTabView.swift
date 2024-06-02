//
//  GentiTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

enum GeneratorFlow: Hashable {
    case second, thrid
}

enum SettingFlow: Hashable {
    case setting, notion(urlString: String)
}

struct GentiTabView: View {

    @State private var currentTab: Tab = .home
    @State private var showCompleteView: Bool = false
    @State var generateFlow: [GeneratorFlow] = []
    @State var settingFlow: [SettingFlow] = []
    @State private var tabbarHidden: Bool = false
    @State private var selectedPost: Post? = nil
    @State private var completedImage: Post? = nil
    
    @StateObject var genteratorViewModel = GeneratorViewModel()
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(Tab.home)
                
                NavigationStack(path: $generateFlow) {
                    FirstGeneratorView(generateFlow: $generateFlow)
                        .navigationDestination(for: GeneratorFlow.self) { genType in
                            switch genType {
                            case .second:
                                SecondGeneratorView(generateFlow: $generateFlow)
                            case .thrid:
                                ThirdGeneratorView(generateFlow: $generateFlow)
                            }
                        }

                }
                .environmentObject(genteratorViewModel)
                .tag(Tab.generator)

                NavigationStack(path: $settingFlow) {
                    ProfileView(settingFlow: $settingFlow, imageTapped: { post in
                        self.selectedPost = post
                    })
                    .navigationDestination(for: SettingFlow.self) { setType in
                        switch setType {
                        case .setting:
                            SettingView(tabbarHidden: $tabbarHidden, settingFlow: $settingFlow)
                        case .notion(let urlString):
                            GentiWebView(settingFlow: $settingFlow, urlString: urlString)
                        }
                    }
                }

                .tag(Tab.profile)
            }
            
            if !tabbarHidden {
                CustomTabView(selectedTab: $currentTab)
            }
            
            if genteratorViewModel.isGenerating {
                ZStack {
                    // Background Color
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    // Content
                    ProgressView()
                        .tint(.gentiGreen)
                } //:ZSTACK

            }
            
        } //: ZSTACK
        .ignoresSafeArea(.keyboard)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PhotoMakeCompleted"))) { noti in
            if let imageName = noti.userInfo?["ImageName"] as? String {
                self.completedImage = .init(imageURL: imageName)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GeneratorCompleted"))) { _ in
            self.currentTab = .home
            self.showCompleteView.toggle()
        }
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(isPresented: $showCompleteView, onDismiss: {
            self.genteratorViewModel.reset()
            self.generateFlow.removeAll()
            self.currentTab = .home
        }, content: {
            GenerateRequestCompleteView()
        })
        .fullScreenCover(item: $selectedPost) { post in
            PostDetailView(imageUrl: post.imageURL)
        }
        .fullScreenCover(item: $completedImage) { image in
            PhotoCompleteView(imageName: image.imageURL)
        }
    }
}


#Preview {
    GentiTabView()
}
