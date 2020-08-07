//
//  SafariExtensionHandler.swift
//  keyword-search Extension
//
//  Created by Eddie Cameron on 6/08/20.
//  Copyright © 2020 Eddie Cameron. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    let keywords: [KeywordEntry] = []
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
    
    override func page(_ page: SFSafariPage, willNavigateTo url: URL?) {
        NSLog("PAGE: " + ( url?.absoluteString ?? "NONE" ) )
        let isGoogle = url?.host?.range(of: "google") != nil
        if isGoogle {
            let query = (url?.queryParameters?["q"] ?? "")
            for keyword in KeywordDB.shared.keywords {
                let queryStart = keyword.keyword + "+"
                if query.starts(with: queryStart) {
                    // matched a keyword
                    let cleanQuery = query.dropFirst(queryStart.count)
                    if let searchUrl = URL( string: keyword.url.replacingOccurrences(of: "{search}", with: cleanQuery)) {
                        NSLog("Found keyword: " + keyword.keyword + ". Searching: " + searchUrl.absoluteString )
    //                    page.dispatchMessageToScript(withName: "goto", userInfo: ["search": searchUrl])
                        page.getContainingTab{ tab in
                            tab.navigate(to: searchUrl)
                        }
                    }
                    break
                }
            }
        }
    }
}

extension URL {
    // https://github.com/RayPS/Search-Engine-Switcher/blob/master/Search%20Engine%20Switcher/Search%20Engine%20Switcher%20Extension/SafariExtensionHandler.swift
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }

        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }

        return parameters
    }
}
