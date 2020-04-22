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
        canvasView.rectBorderColor = .darkGray
        canvasView.rectBackgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        canvasView.selectionRange = 15
        canvasView.zoom = true
    }
    
    func setUpObservers() {
        let notCenter = NotificationCenter.default
        
        notCenter.addObserver(forName: .canvasViewDidChangeSelection, object: nil, queue: .main) { _ in
            self.updateUI()
        }
        
        notCenter.addObserver(forName: .canvasViewDidEndSession, object: nil, queue: .main) { _ in
            guard let item = self.canvasView.items.last else { return }
            self.registerUndoAdd(item: item)
            self.canvasView.beginDrawingSession(type: PencilItem2.self)
            self.updateUI()
        }
        
        notCenter.addObserver(forName: .canvasViewDidCancelSession, object: nil, queue: .main) { _ in
            self.updateUI()
        }
    }
    
    func registerUndoAdd(item: BaseDrawer) {
        undoManager?.registerUndo(withTarget: self) { vc in
            if let idx = vc.canvasView.items.firstIndex(of: item) {
                vc.canvasView.removeItems(at: [idx])
            }
            vc.registerUndoRemove(item)
        }
    }
    
    func registerUndoRemove(_ item: BaseDrawer) {
        undoManager?.registerUndo(withTarget: self) { vc in
            vc.canvasView.addItem(item)
            vc.registerUndoAdd(item: item)
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
    
}

