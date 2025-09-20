//
//  TokenPayload.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//
import Vapor
import Redis
import NIOCore // for ByteBuffer

protocol Redisable: Codable, RESPValueConvertible {

    func toKey() -> String
    
    func expiredAt() -> Date
    
}

extension Redisable {
    
    init?(fromRESP value: RediStack.RESPValue) {
        guard case let .bulkString(buffer) = value,
              var buf = buffer,                       // make a mutable copy
              let bytes = buf.readBytes(length: buf.readableBytes) else {
            return nil
        }
        do {
            let decoded = try JSONDecoder().decode(Self.self, from: Data(bytes))
            self = decoded
        } catch {
            return nil
        }
    }
    
    func convertedToRESPValue() -> RediStack.RESPValue {
        do {
            let data = try JSONEncoder().encode(self)
            var buffer = ByteBufferAllocator().buffer(capacity: data.count)
            buffer.writeBytes(data)
            return .bulkString(buffer)
        } catch {
            return .null
        }
    }
}
