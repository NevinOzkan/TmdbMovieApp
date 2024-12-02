//
//  Result.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}
