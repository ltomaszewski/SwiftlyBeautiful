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
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Extract property names to generate description
        let properties = declaration.memberBlock.members.compactMap { member -> String? in
            if let variable = member.decl.as(VariableDeclSyntax.self),
               let name = variable.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text {
                return name
            }
            return nil
        }
        
        // Generate the description string by listing properties and their values
        let descriptionBody = properties.map { "\($0): \\(\($0))" }.joined(separator: ", ")
        
        // Define the generated description property
        let descriptionDecl = """
        var description: String {
            return "\\(Self.self)(\(descriptionBody))"
        }
        """
        
        // Return the generated property as a member of the class
        return [DeclSyntax(stringLiteral: descriptionDecl)]
    }
}
