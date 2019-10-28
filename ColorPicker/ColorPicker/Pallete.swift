//
//  Pallete.swift
//  ColorPicker
//
//  Created by Serhii Ostrovetskyi on 28.10.2019.
//  Copyright © 2019 dev. All rights reserved.
//

import SwiftUI

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
        var horizontalIndex = Int(point.x / elementSize)
        var verticalIndex = Int(point.y / elementSize)
        if horizontalIndex < 0 {horizontalIndex = 0}
        if horizontalIndex > (collumCount - 1) {horizontalIndex = collumCount - 1}
        if verticalIndex < 0 {verticalIndex = 0}
        if verticalIndex > (rowCount - 1) {verticalIndex = rowCount - 1}
        lastCheckedX = verticalIndex
        lastCheckedY = horizontalIndex
        return colors[verticalIndex][horizontalIndex]
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
            color.frame(minWidth: size, idealWidth: size, maxWidth: size, minHeight: size, idealHeight: size, maxHeight: size, alignment: .center)
                .border(Color.black, width: 1)
                .border(Color.white, width: i == lastCheckedX && j == lastCheckedY ? 2: 0)
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
