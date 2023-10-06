//
//  ContentView.swift
//  Asignment4_ReadAPIData
//
//  Created by Willie Green on 9/20/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TabView{
                APIView()
                    .tabItem {
                        Text("Rankings")
                    }

            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
