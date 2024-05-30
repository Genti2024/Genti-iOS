//
//  LoginView.swift
//  Genti
//
//  Created by uiskim on 4/14/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
            ZStack {
                // Background Color
                Image("Login_Asset")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                // Content
                GeometryReader(content: {
                    geometry in
                    VStack(spacing: 55) {
                        VStack(spacing: 30) {
                            Image("Genti_LOGO")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 94)
                            
                            Text("내 마음대로 표현하는\n하나뿐인 AI사진")
                                .multilineTextAlignment(.center)
                                .bold()
                                .font(.system(size: 20))
                            
                        } //:VSTACK

                        VStack(alignment: .center, spacing: 10) {
                            NavigationLink {
                                GentiTabView()
                            } label: {
                                Image("Kakao_Login")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 45)
                            }



                            
                            Image("Apple_Login")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 44)
                        } //:VSTACK
                    } //:VSTACK
                    .position(
                        x: geometry.size.width*0.5,
                        y: geometry.size.height*0.58
                    )
                })
            } //:ZSTACK
    }
}

#Preview {
    LoginView()
}
