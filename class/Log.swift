//
//  Log.swift
//  PartManager
//
//  Created by touchWorld on 2025/2/19.
//

import Foundation

public class PartLog {
    public static var log: ((_ message: String,
                             _ file: String,
                             _ line: Int,
                             _ column: Int) -> Void)?
}


extension String {
    static func formateDate(_ date: Date, formate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: date)
    }
}

func DLog(_ format: String,
          _ args: any CVarArg...,
          file: String = #file,
          line: Int = #line,
          column: Int = #column) {
    let message = String(format: format, args)
    DLog(message, file: file, line: line, column: column)
}

func DLog(_ message: String,
          file: String = #file,
          line: Int = #line,
          column: Int = #column) {
    if let log = PartLog.log {
        log(message, file, line, column)
        return
    }
#if DEBUG
    let time = String.formateDate(Date(), formate: "yyyy-MM-dd HH:mm:ss.SSSSSS")
    print("\(time) \(file.components(separatedBy: "/").last ?? ""):\(line):\(column): \(message)")
#endif
}

