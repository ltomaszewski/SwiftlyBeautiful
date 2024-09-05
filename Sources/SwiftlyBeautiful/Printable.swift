//
//  File.swift
//  
//
//  Created by Lukasz Tomaszewski on 05/09/2024.
//

@attached(member, names: named(description))
macro Printable() = #externalMacro(module: "SwiftlyBeautifulMacros", type: "PrintableMacro")
