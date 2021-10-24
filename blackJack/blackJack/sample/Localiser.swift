//
//  File.swift
//  
//
//  Created by Kakeru Fukuda on 2021/10/05.
//

import Foundation
import Entities

public struct Localizer {
    internal let dictionary: LocalizeDictionary
    public var version: Int { dictionary.version }

    public init() {
        guard let url = Bundle.module.url(forResource: "LocalizeDictionary", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(LocalizeDictionary.self, from: data) else {
                  fatalError()
              }

        dictionary = decoded
    }

    public func localize(key: LocalizeKey) -> String {
        if let word = dictionary.dictionary.first(where: { $0.key == key.rawValue }) {
            switch AppSettings.language {
            case .japanese: return word.ja
            case .english : return word.en
            }
        }
        return key.rawValue
    }
}

