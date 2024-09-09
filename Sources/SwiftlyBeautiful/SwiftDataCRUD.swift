//
//  File.swift
//  
//
//  Created by Lukasz Tomaszewski on 06/09/2024.
//

@attached(extension, names: named(save), named(delete), named(update), named(query))
public macro SwiftDataCRUD() = #externalMacro(module: "SwiftlyBeautifulMacros", type: "SwiftDataCRUDMacro")
