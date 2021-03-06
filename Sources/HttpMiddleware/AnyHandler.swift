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
//  AnyHandler.swift
//  HttpMiddleware
//

#if compiler(<5.7)
/// Type erased Handler
public struct AnyHandler<InputType, OutputType, ContextType>: HandlerProtocol {
    private let _handle: (InputType, ContextType) async throws -> OutputType
    
    public init<HandlerType: HandlerProtocol> (_ realHandler: HandlerType)
    where HandlerType.InputType == InputType, HandlerType.OutputType == OutputType, HandlerType.ContextType == ContextType {
        if let alreadyErased = realHandler as? AnyHandler<InputType, OutputType, ContextType> {
            self = alreadyErased
            return
        }
        self._handle = realHandler.handle
    }
    
    public func handle(input: InputType, context: ContextType) async throws -> OutputType {
        return try await _handle(input, context)
    }
}
#else
public typealias AnyHandler<InputType, OutputType, ContextType> = any HandlerProtocol<InputType, OutputType, ContextType>
#endif

public typealias AnyMiddlewareHandler<InputType, OutputType> = AnyHandler<InputType, OutputType, MiddlewareContext>

extension AnyHandler: MiddlewareHandlerProtocol where ContextType == MiddlewareContext {
    
}
