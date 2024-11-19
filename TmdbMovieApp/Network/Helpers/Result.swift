//
//  Result.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

//  hata durumlarını ele almak için.
public enum Result<Value> {
    case success(Value)
    case failure(Error)
}
