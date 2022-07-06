//===----------------------------------------------------------------------===//
//
// This source file is part of the async-http-middleware-client open source project
//
// Copyright (c) 2022 the async-http-middleware-client project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of VSCode Swift project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import HttpClientMiddleware

public struct ContentTypeHeaderMiddleware<HTTPRequestType: HttpRequestProtocol,
                                          HTTPResponseType: HttpResponseProtocol>: ContentTypeMiddlewareProtocol {
    public typealias InputType = HttpRequestBuilder<HTTPRequestType>
    public typealias OutputType = HTTPResponseType
    
    private let contentType: String
    private let omitHeaderForZeroLengthBody: Bool
    
    public init(contentType: String,
                omitHeaderForZeroLengthBody: Bool) {
        self.contentType = contentType
        self.omitHeaderForZeroLengthBody = omitHeaderForZeroLengthBody
    }
    
    public func handle<HandlerType>(input: HttpRequestBuilder<HTTPRequestType>, next: HandlerType) async throws
    -> HTTPResponseType
    where HandlerType : HandlerProtocol, HttpRequestBuilder<HTTPRequestType> == HandlerType.InputType,
    HTTPResponseType == HandlerType.OutputType {
        if input.body?.knownLength != 0 || !self.omitHeaderForZeroLengthBody {
            input.withHeader(name: "Content-Type", value: self.contentType)
        }
        
        return try await next.handle(input: input)
    }
}