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
        // Extract property names and check if it has a custom description
        let properties = declaration.memberBlock.members.compactMap { member -> String? in
            if let variable = member.decl.as(VariableDeclSyntax.self),
               let name = variable.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
               let type = variable.bindings.first?.typeAnnotation?.type {
                
                // Handle arrays specifically
                if let arrayType = type.as(ArrayTypeSyntax.self) {
                    // Get the element type of the array
                    if let elementType = arrayType.element.as(IdentifierTypeSyntax.self) {
                        // Check if the element type is a basic type or a complex type
                        if elementType.name.text == "String" || elementType.name.text == "Int" || elementType.name.text == "Double" || elementType.name.text == "Bool" {
                            return "\(name): \\(self.\(name))"
                        } else {
                            // Assume complex types in the array have their own description
                            return "\(name): \\(self.\(name).map { $0.description })"
                        }
                    }
                } else if let simpleType = type.as(IdentifierTypeSyntax.self) {
                    // Check if the property is a basic type
                    if simpleType.name.text == "String" || simpleType.name.text == "Int" || simpleType.name.text == "Double" || simpleType.name.text == "Bool" {
                        // For basic types, print the value
                        return "\(name): \\(self.\(name))"
                    } else {
                        // For complex types, assume they have their own description
                        return "\(name): \\(self.\(name).description)"
                    }
                }
            }
            return nil
        }
        
        // Generate the description string by listing properties and their values
        let descriptionBody = properties.joined(separator: ", ")
        
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
