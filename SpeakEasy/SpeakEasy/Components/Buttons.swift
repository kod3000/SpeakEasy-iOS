//
//  Component.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//

import SwiftUI

struct Btn: View {
    var title: String
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray)
                .frame(height: 60)
                .cornerRadius(10)
                .padding(5)
            Text(title).foregroundColor(.white)
        }
    }
}
