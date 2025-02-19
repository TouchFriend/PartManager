//
//  Log.swift
//  PartManager
//
//  Created by touchWorld on 2025/2/19.
//

import Foundation

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
          function: String = #function,
          line: Int = #line,
          column: Int = #column) {
#if DEBUG
    let message = String(format: format, args)
    let time = String.formateDate(Date(), formate: "yyyy-MM-dd HH:mm:ss.SSSSSS")
    print("\(time) \(file.components(separatedBy: "/").last ?? ""):\(function):\(line):\(column): \(message)")
#endif
}
