//
//  SafariExtensionViewController.swift
//  keyword-search Extension
//
//  Created by Eddie Cameron on 6/08/20.
//  Copyright © 2020 Eddie Cameron. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:370, height:200)
        return shared
    }()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    @IBAction func keywordEdited(_ sender: NSTextField) {
        let row = tableView.row(for: sender)
        if row >= 0 {
                
            // ignore empty
            if sender.stringValue.isEmpty {
                sender.stringValue = KeywordDB.shared.keywords[row].keyword
                return
            }
            
            // ignore duplicates
            for keyword in KeywordDB.shared.keywords {
                if keyword.keyword == sender.stringValue {
                    sender.stringValue = KeywordDB.shared.keywords[row].keyword
                    return
                }
            }
            
            KeywordDB.shared.keywords[row].keyword = sender.stringValue
            KeywordDB.shared.persist()
        }
    }
    
    @IBAction func urlEdited(_ sender: NSTextField) {
        let row = tableView.row(for: sender)
        if row >= 0 {
                
            // ignore empty
            if sender.stringValue.isEmpty {
                sender.stringValue = KeywordDB.shared.keywords[row].url
                return
            }
            
            // ignore if search keyphrase not found
            if !sender.stringValue.contains("{search}") {
                sender.stringValue = KeywordDB.shared.keywords[row].url
                return
            }
            
            KeywordDB.shared.keywords[row].url = sender.stringValue
            KeywordDB.shared.persist()
        }
    }
    
    @IBAction func addRemoveClicked(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            // add
            let insertionIdx = KeywordDB.shared.keywords.count
            
            var prefillUrl = "http://url.com?q={search}"
            if let currentUrl = SafariExtensionHandler.currentTargetUrl {
                if let searchQuery = currentUrl.tryGetSearchQuery() {
                    prefillUrl = currentUrl.absoluteString.replacingOccurrences(of: searchQuery, with: "{search}")
                }
            }
    
            KeywordDB.shared.add(keyword: "kw", url: prefillUrl)
            tableView.insertRows(at: IndexSet(integer:insertionIdx), withAnimation: .effectGap)
            tableView.editColumn(0, row: insertionIdx, with: nil, select: false)    // preselect keyword field for editing
        }
        else {
            // remove
            let selectedRow = tableView.selectedRow
            if selectedRow >= 0 && selectedRow < tableView.numberOfRows {
                KeywordDB.shared.removeKeywordAt(idx: selectedRow)
                
                tableView.removeRows(at: IndexSet(integer: selectedRow), withAnimation: .effectFade)
                
                let nextRow = selectedRow > 0 ? selectedRow - 1 : selectedRow
                tableView.selectRowIndexes(IndexSet(integer: nextRow), byExtendingSelection: false)
            }
        }
    }
}

extension SafariExtensionViewController: NSTableViewDataSource {
  
    func numberOfRows(in tableView: NSTableView) -> Int {
        return KeywordDB.shared.keywords.count
    }

}

extension SafariExtensionViewController: NSTableViewDelegate {
    
    fileprivate enum ColumnIdentifiers {
        static let Keyword = "KeywordColumn"
        static let Url = "UrlColumn"
    }
    
    fileprivate enum CellIdentifiers {
        static let KeywordCell = "KeywordCellID"
        static let UrlCell = "UrlCellID"
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let keyword = KeywordDB.shared.keywords[row]
        NSLog("Showing row " + keyword.keyword)
        NSLog( tableColumn?.identifier.rawValue ?? " no column" )

        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(ColumnIdentifiers.Keyword) {
            // keyword
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.KeywordCell), owner: nil) as? NSTableCellView {
                NSLog("column 0 " + keyword.keyword)
                cell.textField?.stringValue = keyword.keyword
                
                cell.textField?.target = self
                cell.textField?.action = #selector(keywordEdited)
                return cell
            }
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(ColumnIdentifiers.Url) {
            // URL
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.UrlCell), owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = keyword.url
                
                cell.textField?.target = self
                cell.textField?.action = #selector(urlEdited)
                return cell
            }
        }
        
        
        return nil
    }


}
