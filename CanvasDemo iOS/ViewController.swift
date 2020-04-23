//
//  ViewController.swift
//  CanvasDemo iOS
//
//  Created by Chen on 2020/4/15.
//  Copyright © 2020 vitiny. All rights reserved.
//

import UIKit

import Canvas

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCanvasView()
        setUpObservers()
        
        updateUI()
        
        canvasView.beginDrawingSession(type: PencilItem2.self)
    }
    
    func setUpCanvasView() {
        canvasView.selectionRange = 15
    }
    
    func setUpObservers() {
        let notCenter = NotificationCenter.default
        notCenter.addObserver(forName: .canvasViewDidEndSession, object: nil, queue: .main) { _ in
            let t = type(of: self.canvasView.items.last!).self
            self.canvasView.beginDrawingSession(type: t)
            self.updateUI()
        }
    }
    
    func updateUI() {
        undoButton.isEnabled = undoManager?.canUndo ?? false
        redoButton.isEnabled = undoManager?.canRedo ?? false
    }
    
    @IBAction func undo(_ sender: Any) {
        undoManager?.undo()
        updateUI()
    }
    
    @IBAction func redo(_ sender: Any) {
        undoManager?.redo()
        updateUI()
    }
    
    @IBAction func clearAll(_ sender: Any) {
        canvasView.removeAllItems()
        undoManager?.removeAllActions()
        updateUI()
    }
    
}

