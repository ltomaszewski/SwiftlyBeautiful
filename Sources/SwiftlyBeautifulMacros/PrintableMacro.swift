//
//  File.swift
//  
//
//  Created by Lukasz Tomaszewski on 05/09/2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct PrintableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        in context: MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        // Extracting properties to generate a description string
        let properties = declaration.memberBlock.members.compactMap { member -> String? in
            if let variable = member.decl.as(VariableDeclSyntax.self),
               let name = variable.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text {
                return name
            }
            return nil
        }
        
        // Generate the description string dynamically
        let descriptionBody = properties.map { "\($0): \\(\($0))" }.joined(separator: ", ")
        
        let descriptionDecl = """
        var description: String {
            return "\\(Self.self)(\(descriptionBody))"
        }
        """
        
        return [DeclSyntax(stringLiteral: descriptionDecl)]
    }
}
