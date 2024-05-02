//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 18.04.2024.
//

import Foundation
enum NetworkError: Error {
    case httpStatusCode(Int, String)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError
    case imageError
}
