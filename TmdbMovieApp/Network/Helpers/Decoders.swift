//
//  Decoders.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 5.11.2024.
//

import Foundation

// JSON verisini doğrudan Date türüne dönüştürür
public enum Decoders {
    
    public static let releaseDateDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
}
