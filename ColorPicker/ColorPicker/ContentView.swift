//
//  ContentView.swift
//  ColorPicker
//
//  Created by Serhii Ostrovetskyi on 25.10.2019.
//  Copyright © 2019 dev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var color = Color.black
    @State var colors: [[Color]] = [[]]
    
    var body: some View {
        VStack {
            HStack {
                Text("Selected color: ")
                Rectangle().frame(maxHeight: 30)
                    .foregroundColor(color)
            }
            .padding()
            Pallete(parentColor: $color, colors: getColors(),elementSize: 50)
            Spacer()
        }
    }
    
    func getColors() -> [[Color]] {
        var colors = [[Color]]()
        for i in 0..<9 {
            colors.append([])
            for _ in 0..<13 {
                colors[i].append(Color(red: Double.random(in: 0..<1), green: Double.random(in: 0..<1),blue: Double.random(in: 0..<1)))
            }
        }
        return colors
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
