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
    var body: some View {
        VStack {
            HStack {
                Text("Selected color: ")
                Rectangle().frame(maxHeight: 30)
                    .foregroundColor(color)
            }
            .padding()
            Pallete(parentColor: $color)
            //Pallete(rowCount: 6, parentColor: $color)
            //Pallete(rowCount: 5, collumCount: 7, parentColor: $color)
            //Pallete(rowCount: 20, collumCount: 22, elementSize: 40, parentColor: $color)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Pallete: View {
    @State var rowCount = 9
    @State var collumCount = 13
    @State var elementSize: CGFloat = 20
    @Binding var parentColor: Color
    @State var point: CGPoint = CGPoint(x: 0, y: 0)
    @State var elements = [PalleteElement]()
    @State var colorHandler = ColorHandler()
    
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
                    self.parentColor = self.colorHandler.getColorFromPoint(point: value.location)
                })
        )
    }
    
    func makeElem(i: Int, j: Int) -> PalleteElement {
        colorHandler.rowCount = rowCount
        colorHandler.collumCount = collumCount
        colorHandler.elementSize = elementSize
        let color = colorHandler.colors[i][j]
        return PalleteElement(i: i, j: j, colorHandler: $colorHandler, color: color, parentColor: $parentColor, size: $elementSize)
        //return PalleteElement(i:i, j:j, colorHandler: $colorHandler, size: $elementSize, color:color, parentColor: self.$parentColor)
    }
    
    struct PalleteElement: View {
        @State var i = 0
        @State var j = 0
        @Binding var colorHandler: ColorHandler

        var selected: Bool {
            return i == colorHandler.lastCheckedX && j == colorHandler.lastCheckedY
        }
        @State var color = Color.black
        @Binding var parentColor: Color
        @Binding var size: CGFloat
        var body: some View {
            Rectangle().frame(minWidth: size, idealWidth: size, maxWidth: size, minHeight: size, idealHeight: size, maxHeight: size, alignment: .center)
                .border(Color.white, width: selected ? 5: 0)
                .foregroundColor(color)
                .gesture(
                    TapGesture()
                        .onEnded({ _ in
                            self.parentColor = self.color
                            self.colorHandler.lastCheckedX = self.i
                            self.colorHandler.lastCheckedY = self.j
                        })
            )
        }
    }
    
    class ColorHandler {
        var rowCount: Int
        var collumCount: Int
        var elementSize: CGFloat
        var lastCheckedX = -1
        var lastCheckedY = -1
        
        init() {
            self.rowCount = 0
            self.collumCount = 0
            self.elementSize = 1
        }
        
        init(rowCount: Int, collumnCount: Int, elementSize: CGFloat) {
            self.rowCount = rowCount
            self.collumCount = collumnCount
            self.elementSize = elementSize
        }
        
        private var _colors = [[Color]]()
        
        var colors : [[Color]]
        {
            if _colors.count == 0 {
                var color = [[Color]]()
                for i in 0..<rowCount {
                    color.append([])
                    for _ in 0..<collumCount {
                        color[i].append(Color(red: Double.random(in: 0..<1), green: Double.random(in: 0..<1),blue: Double.random(in: 0..<1)))
                    }
                }
                _colors = color
            }
            return _colors
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
        
    }
}
