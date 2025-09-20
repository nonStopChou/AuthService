//
//  Provider.swift
//  hello
//
//  Created by prchou on 2025/7/24.
//

public enum Provider: String, Codable, Sendable {
    case google, github, linkedin, discord, visitor, illegalProvider
}


extension Provider {
    
    public static func isValid(provider: String) -> Bool {
        switch provider.lowercased() {
            case "google":
                return true
            case "github":
                return true
            case "linkedin":
                return true
            case "discord":
                return true
            case "visitor":
                return true
            default:
                return false
            }
    }
    
    public static func from(_ rawValue: String) -> Provider {
        switch(rawValue.lowercased()) {
            case "google": return Provider.google
            case "github": return Provider.github
            case "linkedin": return Provider.linkedin
            case "discord": return Provider.discord
        case "visitor": return Provider.visitor
        default: return Provider.illegalProvider
        }
    }
    
}

