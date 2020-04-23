//
//  CircleDistItem.swift
//  CanvasDemo macOS
//
//  Created by Chen on 2020/4/23.
//  Copyright © 2020 vitiny. All rights reserved.
//

import Foundation
import CoreGraphics

import Canvas

class CircleDistItem: FixedCanvasItem {
    
    public private(set) var circles: [Circle] = []
    
    required init() {
        super.init(segments: 2, elements: 3)
    }
    
    override func mainPathWrappers() -> [PathWrapper] {
        circles = grid.filter { $0.count == elements }
            .compactMap { Circle($0[0], $0[1], $0[2]) ?? nil }
        
        var paths = [PathWrapper]()
        
        if isCompleted {
            let line = CGMutablePath()
            line.addLines(between: [circles[0].center, circles[1].center])
            paths += [PathWrapper(method: .stroke(lineWidth), color: strokeColor, path: line)]
            paths += circles.map {
                var circle = $0
                circle.radius = 3
                return PathWrapper(method: .fill, color: strokeColor, path: CGMutablePath.circle(circle))
            }
        }
        
        paths += circles.map {
            PathWrapper(method: .stroke(lineWidth), color: strokeColor, path: CGMutablePath.circle($0))
        }
        
        return paths
    }
    
    override func canSelect(by rect: CGRect) -> Bool {
        guard circles.count == 2 else { return false }
        return
            circles.contains(where: { $0.canSelect(by: rect) }) ||
            Line(from: circles[0].center, to: circles[1].center).canSelect(by: rect)
    }
    
}
