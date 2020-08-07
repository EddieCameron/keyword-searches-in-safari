//
//  KeywordDB.swift
//  keyword-search Extension
//
//  Created by Eddie Cameron on 6/08/20.
//  Copyright © 2020 Eddie Cameron. All rights reserved.
//

import Foundation

class KeywordDB {
    static let shared = KeywordDB()
    
    static let DEFAULTS_KEY = "KWSKeywords"
    
    var keywords: [KeywordEntry]
    
    init() {
        UserDefaults.standard.synchronize()
        keywords = []
        guard let serializedKeywords:[Data] = UserDefaults.standard.array(forKey: KeywordDB.DEFAULTS_KEY) as? [Data] else {
            return
        }
        
        if serializedKeywords.count > 0 {
            for keywordString in serializedKeywords {
                do {
                    let keyword = try JSONDecoder().decode(KeywordEntry.self, from: keywordString)
                    keywords.append(keyword)
                }
                catch {
                    NSLog("Error loading saved keyword data")
                }
            }
        }
        else {
            // load defaults
            keywords.append(KeywordEntry(keyword: "w", url: "https://en.wikipedia.org/w/index.php?search={search}"))
        }
    }
    
    func persist() {
        UserDefaults.standard.synchronize()
        var keywordData: [Data] = []
        for keyword in keywords {
            do {
                let data = try JSONEncoder().encode(keyword)
                keywordData.append(data)
            }
            catch {
                
            }
        }
        
        UserDefaults.standard.set(keywordData, forKey: KeywordDB.DEFAULTS_KEY)
    }
    
    func add(keyword: String, url:String ) {
        keywords.append(KeywordEntry(keyword: keyword, url: url))
        persist()
    }
    
    func removeKeywordAt(idx:Int) {
        keywords.remove(at: idx)
        persist()
    }
}
