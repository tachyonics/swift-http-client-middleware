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
//  HandlerProtocol.swift
//  HttpMiddleware
//

#if compiler(<5.7)
public protocol HandlerProtocol {
    associatedtype InputType
    associatedtype OutputType
    associatedtype ContextType
       
    func handle(input: InputType, context: ContextType) async throws -> OutputType
}

extension HandlerProtocol {
    public func eraseToAnyHandler() -> AnyHandler<InputType, OutputType, ContextType> {
        return AnyHandler(self)
    }
}
#else
public protocol HandlerProtocol<InputType, OutputType, ContextType>> {
    associatedtype InputType
    associatedtype OutputType
    associatedtype ContextType
       
    func handle(input: InputType, context: ContextType) async throws -> OutputType
}

extension HandlerProtocol {
    public func eraseToAnyHandler() -> any HandlerProtocol<InputType, OutputType, ContextType>> {
        return self
    }
}
#endif

public protocol MiddlewareHandlerProtocol: HandlerProtocol where ContextType == MiddlewareContext {
    
}
