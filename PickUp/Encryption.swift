//
//  Encryption.swift
//  PickUp
//
//  Created by Krish Patel on 3/23/23.
//

import Foundation
import CommonCrypto

enum AESError: Error {
    case keySizeError
    case keyDataError
}

public struct AES256 {
    private let key: Data

    public init?(key: String) throws {
        guard key.count == kCCKeySizeAES256 else {
            print("ERROR")
            throw AESError.keySizeError
        }
        guard let keyData = key.data(using: .utf8) else {
            print("ERROR")
            throw AESError.keyDataError
        }
        self.key = keyData
    }

    public func encrypt(messageData: Data?) -> Data? {
        guard let messageData else { return nil}
        return crypt(data: messageData, option: CCOperation(kCCEncrypt))
    }

    public func decrypt(encryptedData: Data?) -> Data? {
        return crypt(data: encryptedData, option: CCOperation(kCCDecrypt))
    }

    private func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        var outputBuffer = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128)
        var numBytesEncrypted = 0
        let status = CCCrypt(
            option,
            CCAlgorithm(kCCAlgorithmAES),
            CCOptions(kCCOptionPKCS7Padding),
            Array(key),
            kCCKeySizeAES256,
            nil,
            Array(data),
            data.count,
            &outputBuffer, outputBuffer.count, &numBytesEncrypted
        )
        guard status == kCCSuccess else { return nil }
        let outputBytes = outputBuffer.prefix(numBytesEncrypted)
        return Data(outputBytes)
    }
}
