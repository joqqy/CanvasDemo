//
//  ViewController.swift
//  CanvasDemo macOS
//
//  Created by Chen on 2020/4/15.
//  Copyright © 2020 vitiny. All rights reserved.
//

import Cocoa

import Canvas

enum Shape: String, CaseIterable {
    case line
    case polyline
    case circle
    case pencil
    case pencil2
    case arc
    
    func canvasItemType() -> CanvasItem.Type {
        switch self {
        case .line:     return LineItem.self
        case .polyline: return PolylineItem.self
        case .circle:   return CircleItem.self
        case .pencil:   return PencilItem.self
        case .pencil2:  return PencilItem2.self
        case .arc:      return ArcItem.self
        }
    }
}

class ViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var cursorButton: NSButton!
    @IBOutlet weak var deleteButton: NSButton!
    @IBOutlet weak var canvasView: CanvasView!
    
    var selectedRow: Int? { tableView.selectedRow == -1 ? nil : tableView.selectedRow}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpObservers()
        updateUI()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.doubleAction = #selector(doubleClicked(_:))
    }
    
    func setUpObservers() {
        let notCenter = NotificationCenter.default
        notCenter.addObserver(forName: .canvasViewDidChangeSelection, object: nil, queue: .main) { _ in
            self.updateUI()
        }
        notCenter.addObserver(forName: .canvasViewDidEndSession, object: nil, queue: .main) { _ in
            self.updateUI()
        }
        notCenter.addObserver(forName: .canvasViewDidCancelSession, object: nil, queue: .main) { _ in
            self.updateUI()
        }
    }
    
    func updateUI() {
        deleteButton.isEnabled = !canvasView.indicesOfSelectedItems.isEmpty
    }
    
    // MARK: - Actions
    
    @objc func doubleClicked(_ tableView: NSTableView) {
        if tableView.selectedRow != -1 {
            let shape = Shape.allCases[tableView.selectedRow]
            canvasView.beginDrawingSession(type: shape.canvasItemType())
        }
    }
    
    @IBAction func endSession(_ sender: Any) {
        canvasView.endDrawingSession()
    }
    
    @IBAction func removeSelection(_ sender: Any) {
        canvasView.removeItems(at: canvasView.indicesOfSelectedItems)
    }
    
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int { Shape.allCases.count }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = NSUserInterfaceItemIdentifier("Cell")
        let rowView = tableView.makeView(withIdentifier: id, owner: nil) as? NSTableCellView
        rowView?.textField?.stringValue = Shape.allCases[row].rawValue.capitalized
        return rowView
    }
    
}
