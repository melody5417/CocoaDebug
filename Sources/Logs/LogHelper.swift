//
//  Example
//  man
//
//  Created by man on 11/11/2018.
//  Copyright © 2018 man. All rights reserved.
//

import Foundation

public class LogHelper: NSObject {
    
    var enable: Bool = true
    
    @objc static let shared = LogHelper()
    private override init() {}
    
    fileprivate func parseFileInfo(file: String?, function: String?, line: Int?) -> String? {
        guard let file = file, let function = function, let line = line, let fileName = file.components(separatedBy: "/").last else {return nil}
        return "\(fileName)[\(line)]\(function)\n"
    }

    func handleLog(file: String?, function: String?, line: Int?, message: Any..., color: UIColor?) {
        
        let stringContent = message.reduce("") { result, next -> String in
            return "\(result)\(result.count > 0 ? " " : "")\(next)"
        }
        
        commonHandleLog(file: file, function: function, line: (line ?? 0), message: stringContent, color: color)
    }
    
    @objc func objcHandleLog(file: String?, function: String?, line: Int, message: String, color: UIColor?) {
        commonHandleLog(file: file, function: function, line: line, message: message, color: color)
    }
    
    private func commonHandleLog(file: String?, function: String?, line: Int, message: String, color: UIColor?) {
        
        guard enable else {
            return
        }
        
        //1.
        let fileInfo = parseFileInfo(file: file, function: function, line: line)
        
        //2.
        let newLog = LogModel(content: message, color: color, fileInfo: fileInfo)
        LogStoreManager.shared.addLog(newLog)
        
        NotificationCenter.default.post(name: NSNotification.Name("refreshLogs_CocoaDebug"), object: nil, userInfo: nil)
    }
}
