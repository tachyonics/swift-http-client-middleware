// Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
// A copy of the License is located at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//
//  HeadersProtocol.swift
//  swift-http-client-middleware
//

import Foundation

public struct Endpoint: Hashable {
    public let path: String
    public let queryItems: [URLQueryItem]?
    public let protocolType: ProtocolType?
    public let host: String
    public let port: Int16
    
    public init(host: String,
                path: String = "/",
                port: Int16 = 443,
                queryItems: [URLQueryItem]? = nil,
                protocolType: ProtocolType? = .https) {
        self.host = host
        self.path = path
        self.port = port
        self.queryItems = queryItems
        self.protocolType = protocolType
    }
}

public extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = protocolType?.rawValue
        components.host = host
        components.path = path
        components.percentEncodedQueryItems = queryItems

        return components.url
    }
    
    var queryItemString: String {
        guard let queryItems = queryItems, !queryItems.isEmpty else {
            return ""
        }
        let queryString = queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        return "?\(queryString)"
    }
}
