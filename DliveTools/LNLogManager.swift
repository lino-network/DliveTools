    //
    //  LNLogManager.swift
    //  LnLog
    //
    //  Created by 健崔 on 2022/9/1.
    //

    import UIKit

    let selfFilePath = NSHomeDirectory().appending("/Library/Caches/LNContLog")
    let latestLogFile = "latest"
    let previousLogFile = "previous"
    var writeTimes  = 0;
open class LNLogManager: NSObject {
        
        //    #MARK: ----------------Log writing uses an external interface
        static  func log(msg : String , file : String = #file,line :Int = #line ,funcs : String = #function) {
            let fileName = (file as NSString).lastPathComponent
            let data = Date()
            let dateformat: DateFormatter = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            let nowTime = dateformat.string(from: data)
            let logs = String(format: "[%@] [%@ : %d] -[%@] ●: %@ \n", nowTime,fileName,line,funcs,msg);
            LNLogManager.writeLog(msg: logs)
            print(logs)
        }
        
    //    #MARK: ----------------Initial Configuration The log system creates a log folder and a log file
        static func configLog(){
    //        LNLogManager.deleteFile(filePath: selfFilePath)
            do {
               try     FileManager.default.createDirectory(atPath: selfFilePath, withIntermediateDirectories: true)

            } catch  {
                
            }
            let haveLog = LNLogManager.haveLogFile()
            if !haveLog {
                LNLogManager.createLogFile(fileName: previousLogFile)
            }
            LNLogManager.updateFileSize()

        }
          

        static func writeLog(msg : String) {
            writeTimes  =  writeTimes + 1
            let filePath = selfFilePath.appending("/").appending(LNLogManager.recentLogFile())
            let fileHandle = FileHandle(forUpdatingAtPath: filePath)
            fileHandle?.seekToEndOfFile()
            guard let data = msg.data(using: .utf8) else { return }
            fileHandle?.write(data)
            fileHandle?.synchronizeFile()
            fileHandle?.closeFile()
            if ( writeTimes % 100 == 0 ){
                writeTimes = 0
                LNLogManager.updateFileSize()
            }
        }
        
        //    #MARK: ----------------Interface implementation logic

        static func recentLogFile() ->String {
            let pathArr = FileManager.default.subpaths(atPath: selfFilePath) as?  NSArray
            if ( pathArr!.count > 1 ) {
                return latestLogFile.appending(".text")
            } else {
                return previousLogFile.appending(".text")
            }
        }
                
        static func updateFileSize() {
            let filePath  = selfFilePath.appending("/").appending(LNLogManager.recentLogFile())
            let fileSize = LNLogManager.fileSizeAtPath(logFilePath: filePath)
            if fileSize >= 3 * 1024 * 1024  {
                LNLogManager.updateLogFile()
            }
        }
        
        static func updateLogFile() {
            if FileManager.default.fileExists(atPath: selfFilePath) {
                let pathArr = FileManager.default.subpaths(atPath: selfFilePath) as?  NSArray
                if (pathArr!.count > 1) {
                    let filePath = selfFilePath.appending("/").appending(previousLogFile).appending(".text")
                    LNLogManager.deleteFile(filePath: filePath)
    //              Change the second log file name to the first
                    let newFileName = selfFilePath.appending("/").appending(previousLogFile).appending(".text")
                    let oldFileName = selfFilePath.appending("/").appending(latestLogFile).appending(".text")
                    LNLogManager.changeFileName(oldName: oldFileName, newName: newFileName)
    //               Recreate the second log file
                    LNLogManager.createLogFile(fileName: latestLogFile)
                } else if ( pathArr!.count == 1) {
                    LNLogManager.createLogFile(fileName: latestLogFile)
                }
            }
        }
       
        
        //    #MARK: ----------------Log system internal tools, such as changing file names, monitoring file sizes, and deleting files
        
        static func haveLogFile() ->Bool {
            let pathArr = FileManager.default.subpaths(atPath: selfFilePath) as?  NSArray
            return pathArr!.count > 0
        }
        
        
        static func isFileExist() ->Bool {
            return  FileManager.default.fileExists(atPath: selfFilePath);
        }
        
        static func createLogFile(fileName : String){
            let path = selfFilePath.appending("/").appending(fileName).appending(".text")
            print(path)
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
//            do {
//                try  FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
//                
//            } catch _ as NSError {
//                
//            }
        }
        
        static func deleteFile(filePath : String) {
            do {
                try FileManager.default.removeItem(atPath: filePath)
            }catch _ as NSError{
                
            }
        }
        
        
        static func changeFileName(oldName : String , newName : String) {
            
            let fileManager = FileManager.default
            do{
               try  fileManager.moveItem(at: URL(fileURLWithPath: oldName), to: URL(fileURLWithPath: newName))

            }catch _ as NSError {
                
            }
        }
        
        
        static func totalLogSize() ->UInt64 {
            var foldersSize : UInt64 = 0;
             if FileManager.default.fileExists(atPath: selfFilePath) {
                 let pathArr = FileManager.default.subpaths(atPath: selfFilePath) as?  NSArray
                 let logFilesEnumerator =   pathArr?.objectEnumerator()
                 var i = 1;
                 while (i < 3){
                     if let pathName = logFilesEnumerator?.nextObject() as? String {
                         if (pathName.hasSuffix(".text")){
                             let logFilePath = selfFilePath.appending(pathName)
                           let fileSize =   LNLogManager.fileSizeAtPath(logFilePath: logFilePath)
                             foldersSize = fileSize + foldersSize
                         }
                     }
                     i = i + 1;
                 }
             }
            return foldersSize
         }
        
        
       static func fileSizeAtPath(logFilePath : String) -> UInt64 {
            
            if (FileManager.default.fileExists(atPath: logFilePath)) {
                let attr = try? FileManager.default.attributesOfItem(atPath: logFilePath)
                let size = attr?[FileAttributeKey.size] as! UInt64
                return size
            }
            return 0
        }
    }
