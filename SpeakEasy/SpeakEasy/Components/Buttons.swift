//
//  Component.swift
//  SpeakEasy
//
//  Created by username on 3/20/24.
//

import SwiftUI

struct Btn: View {
    var title: String
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 68 / 255, green: 41 / 255, blue: 182 / 255))
                .frame(height: 60)
                .cornerRadius(10)
                .padding(5)
            Text(title).foregroundColor(.white)
        }
    }
}
