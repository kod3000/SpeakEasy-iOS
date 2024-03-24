//
//  SplashScreen.swift
//  SpeakEasy
//
//  Created by username on 3/23/24.
//

import SwiftUI

struct SplashView: View {
  @State private var isActive = false

  var body: some View {
    if isActive {
      ContentView().background(Color.clear)
    } else {
      VStack {
        Spacer()
        Image("LogoEasy")
          .resizable()
          .scaledToFit()
          .frame(width: 200, height: 200)
        Spacer()
      }.background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
          // show the main view
          DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            withAnimation {
              self.isActive = true
            }
          }
        }
        .edgesIgnoringSafeArea(.all)
    }
  }
}

struct Preview_Previews: PreviewProvider {
  static var previews: some View {
    SplashView()
  }
}
