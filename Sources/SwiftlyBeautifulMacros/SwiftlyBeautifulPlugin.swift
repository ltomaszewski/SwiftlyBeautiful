//
//  File.swift
//  
//
//  Created by Lukasz Tomaszewski on 05/09/2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

@main
struct SwiftlyBeautifulPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        PrintableMacro.self
    ]
}
