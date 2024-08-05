//
//  CustomToastModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 8/5/24.
//

import SwiftUI

struct CustomToastModifier: ViewModifier {
    @Binding var toastType: ToastType?
    
    func body(content: Content) -> some View {
        content
            .overlay {
                VStack {
                    Spacer()
                    if let type = toastType {
                        Text(type.message)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .transition(.opacity)
                            .padding(.bottom, 32)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation {
                                        toastType = nil
                                    }
                                }
                            }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: toastType)
    }
}

extension View {
    func customToast(toastType: Binding<ToastType?>) -> some View {
        self.modifier(CustomToastModifier(toastType: toastType))
    }
}
