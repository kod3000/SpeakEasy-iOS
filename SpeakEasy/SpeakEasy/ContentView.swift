//
//  ContentView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/19/24.
//

import SwiftUI

struct SelectLocalFileView: View {
    var body: some View {
        NavigationLink(destination: ListView()) {
            Text("Select Local File")
        }
    }
}
struct SelectUrlView: View {
    var body: some View {
        NavigationLink(destination: ListView()) {
            Text("Select URL")
        }
    }
}

struct LastUsedView: View {
    var body: some View {
        NavigationLink(destination: ListView()) {
            Text("See last viewed files")
        }
    }
}

// ListView to display last used items
struct ListView: View {
    var body: some View {
        List {
            Text("Document PDF 1")
            Text("Document PDF 2")
            Text("Document PDF 3")
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                SelectLocalFileView()
                LastUsedView() 
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
