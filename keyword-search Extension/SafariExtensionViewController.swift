//
//  SafariExtensionViewController.swift
//  keyword-search Extension
//
//  Created by Eddie Cameron on 6/08/20.
//  Copyright © 2020 Eddie Cameron. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
