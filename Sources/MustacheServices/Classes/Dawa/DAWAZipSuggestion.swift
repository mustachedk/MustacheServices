//
//  ZipAutoCompleteModel.swift
//  MustacheServices
//
//  Created by Simon Elhøj Steinmejer on 07/06/2019.
//

import Foundation

public struct DAWAZipSuggestion: Decodable {
    
    public let tekst: String
    public let nr: String
    public let by: String
    
    enum CodingKeys: String, CodingKey {
        case tekst
        case postnummer
    }
    
    enum postnummerCodingKeys: String, CodingKey {
        case nr
        case by = "navn"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.tekst = try values.decode(String.self, forKey: .tekst)
        let postnummer = try values.nestedContainer(keyedBy: postnummerCodingKeys.self, forKey: .postnummer)
        self.nr = try postnummer.decode(String.self, forKey: .nr)
        self.by = try postnummer.decode(String.self, forKey: .by)
    }
    
}
