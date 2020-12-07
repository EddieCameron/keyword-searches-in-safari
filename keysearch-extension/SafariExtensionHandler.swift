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
    
    static var currentTargetUrl: URL?
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
    
    override func page(_ page: SFSafariPage, willNavigateTo url: URL?) {
        SafariExtensionHandler.currentTargetUrl = url
        
        guard let realUrl = url else {
            return
        }
        
        var isSearch = false
        var query = ""
        if let isGoogle = realUrl.host?.contains("google"),
            realUrl.path.starts(with: "/search" ),
            isGoogle {
            isSearch = true
            query = (realUrl.queryParameters?["q"] ?? "")
        }
        else if let isDuckDuckGo = realUrl.host?.contains("duckduckgo.com"),
            isDuckDuckGo {
            // duckduckgo
            isSearch = true
            query = (realUrl.queryParameters?["q"] ?? "")
        }
        else if let isBing = realUrl.host?.contains("bing"),
            realUrl.path.starts(with: "/search" ),
            isBing {
            // bing
            isSearch = true
            query = (realUrl.queryParameters?["q"] ?? "")
        }
        else if let isYahoo = realUrl.host?.contains("search.yahoo.com"),
            realUrl.path.starts(with: "/search" ),
            isYahoo {
            // yahoo
            isSearch = true
            query = (realUrl.queryParameters?["p"] ?? "")
        }
        
        if isSearch {
            for keyword in KeywordDB.shared.keywords {
                let queryStart = keyword.keyword + "+"
                if query.starts(with: queryStart) {
                    // matched a keyword
                    let cleanQuery = query.dropFirst(queryStart.count)
                    if let urlEncodedQuery = cleanQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                       , let searchUrl = URL( string: keyword.url.replacingOccurrences(of: "{search}", with: urlEncodedQuery) ) {
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
    
    public func tryGetSearchQuery() -> String? {
        guard let params = self.queryParameters else {
            return nil
        }
        
        if let qParam = params["q"] {
            return qParam
        }
        if let searchParam = params["search"] {
            return searchParam
        }
        if let qParam = params["p"] {
            return qParam
        }
        
        // don't know how to get search query from URL
        return nil
    }
}
