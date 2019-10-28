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
            Pallete(parentColor: $color, colors: getColors())
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

struct Pallete: View {
    @Binding var parentColor: Color
    @State var colors: [[Color]] = [[]]
    
    @State var lastCheckedX = -1
    @State var lastCheckedY = -1
    @State var elementSize: CGFloat = 20
    
    var rowCount: Int {
        colors.count
    }
    var collumCount: Int {
        colors.first?.count ?? 0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rowCount) { i in
                HStack(spacing: 0) {
                    ForEach(0..<self.collumCount) { j in
                        self.makeElem(i: i, j:j)
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged({ value in
                    self.parentColor = self.getColorFromPoint(point: value.location)
                })
        )
    }
    
    func getColorFromPoint(point: CGPoint) -> Color{
        var f = Int(point.x / elementSize)
        var s = Int(point.y / elementSize)
        if(f < 0) {f = 0}
        if(f > collumCount - 1) {f = collumCount - 1}
        if(s < 0) {s = 0}
        if(s > rowCount - 1) {s = rowCount - 1}
        lastCheckedX = s
        lastCheckedY = f
        return colors[s][f]
    }
    
    func makeElem(i: Int, j: Int) -> PalleteElement {
        let color = colors[i][j]
        return PalleteElement(parentColor: $parentColor, lastCheckedX: $lastCheckedX, lastCheckedY: $lastCheckedY,color: color, size: elementSize, i: i, j: j)
    }
    
    struct PalleteElement: View {
        @Binding var parentColor: Color
        @Binding var lastCheckedX: Int
        @Binding var lastCheckedY: Int
        
        @State var color = Color.black
        @State var size: CGFloat
        @State var i: Int
        @State var j: Int
       
        var body: some View {
            Rectangle().frame(minWidth: size, idealWidth: size, maxWidth: size, minHeight: size, idealHeight: size, maxHeight: size, alignment: .center)
                .border(Color.black, width: 1)
                .border(Color.white, width: i == lastCheckedX && j == lastCheckedY ? 5: 0)
                .foregroundColor(color)
                .gesture(
                    TapGesture()
                        .onEnded({ _ in
                            self.parentColor = self.color
                            self.lastCheckedX = self.i
                            self.lastCheckedY = self.j
                        })
            )
        }
    }
    
}
