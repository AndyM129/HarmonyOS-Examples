import { hilog } from '@kit.PerformanceAnalysisKit';

export namespace hilogx {

  export let defaultDomain = 0x00000

  export let defaultTag = 'DefaultTag'

  export interface CallerStackFrameAtInfo {
    text?: string
    classFunction?: string
    className?: string
    functionName?: string
    location?: string
    filePath?: string
    fileDirPath?: string
    fileName?: string
    fileTitle?: string
    lineNumber?: number
    columnNumber?: number
  }

  export interface CallerStackFrameInfo {
    index?: number
    text?: string
    at?: CallerStackFrameAtInfo
  }

  export interface CallerInfo {
    stackTrace?: string[]
    stackFrame?: CallerStackFrameInfo
  }

  // export function debug(domain?: number, tag?: string, format?: string, ...args: ESObject[]) {
  //   let callerInfo = getCallerInfo(2)
  //   //let formatWithCallerInfo = `[at (${callerInfo.stackFrame?.at?.location}) - ${callerInfo.stackFrame?.at?.classFunction}${tags.length ? (' #'+tags.join(' #')) : ''}] ➤ ${DebugLog4.format}`
  //   let formatWithCallerInfo = `[at (${callerInfo.stackFrame?.at?.location}) - ${callerInfo.stackFrame?.at?.classFunction}] ➤ ${format}`
  //   return hilog.debug(domain, tag, formatWithCallerInfo, ...args)
  // }

  // export function debug(domain: number, tag: string, labels: string[], format: string, ...args: ESObject[]) {
  //   let callerInfo = getCallerInfo(2)
  //   let formatWithCallerInfo = `[at (${callerInfo.stackFrame?.at?.location}) - ${callerInfo.stackFrame?.at?.classFunction}${labels.length ? (' #'+labels.join(' #')) : ''}] ➤ ${format}`
  //   return hilog.debug(domain, tag, formatWithCallerInfo, ...args)
  // }

  export function debug(...args: ESObject[]) {
    let domain: number | undefined;
    let tag: string | undefined;
    let labels: string[] = [];
    let format: string = '';
    let debugArgs: ESObject[] = [];

    // 根据参数数量进行逻辑区分
    if (args.length > 0) {
      if (typeof args[0] === 'number') {
        domain = args.shift(); // 如果第一个参数是 number，则作为 domain 使用
      }
    }

    if (args.length > 0) {
      if (typeof args[0] === 'string' && args[1] && Array.isArray(args[1])) {
        tag = args.shift() as string; // 如果第一个参数是 string，且下一个参数是数组，则将其视为 tag
      }
    }

    if (args.length > 0) {
      if (Array.isArray(args[0])) {
        labels = args.shift() as string[]; // 如果是数组，视为 labels
      }
    }

    if (args.length > 0 && typeof args[0] === 'string') {
      format = args.shift() as string; // 如果是 string，视为 format
    }

    debugArgs = args as ESObject[]; // 剩余参数作为 debugArgs

    // 拼接 Caller 信息
    let callerInfo = getCallerInfo(2);
    let formatWithCallerInfo = `[at (${callerInfo.stackFrame?.at?.location}) - ${callerInfo.stackFrame?.at?.classFunction}${labels.length ? (' #' + labels.join(' #')) : ''}] ➤ ${format}`;

    // 调用原 hilog.debug 方法
    return hilog.debug(domain || 0, tag || 'DefaultTag', formatWithCallerInfo, ...debugArgs);
  }

  export function getCallerInfo(stackFrameIndex?: number): CallerInfo {
    let error = new Error()
    let callerInfo: CallerInfo = {}
    callerInfo.stackTrace = error.stack?.trim()?.split("\n")
    callerInfo.stackFrame = {}
    callerInfo.stackFrame.index = stackFrameIndex ?? 1
    callerInfo.stackFrame.text = callerInfo.stackTrace?.[callerInfo.stackFrame.index]

    if (callerInfo.stackFrame.text?.length) {
      callerInfo.stackFrame.at = {}
      callerInfo.stackFrame.at.text = callerInfo.stackFrame.text.trim()

      let atComponents = callerInfo.stackFrame.at.text.split(" ")
      callerInfo.stackFrame.at.classFunction = atComponents[1]

      let atClassFunctionComponents = callerInfo.stackFrame.at.classFunction.split(".")
      callerInfo.stackFrame.at.className =
        atClassFunctionComponents.length > 1 ? atClassFunctionComponents[0] : undefined
      callerInfo.stackFrame.at.functionName =
        atClassFunctionComponents.length > 1 ? atClassFunctionComponents[1] : callerInfo.stackFrame.at.classFunction

      callerInfo.stackFrame.at.location = atComponents[2].substring(1, atComponents[2].length - 1)

      let atLocationComponents = callerInfo.stackFrame.at.location.split(":")
      callerInfo.stackFrame.at.filePath = atLocationComponents[0]
      callerInfo.stackFrame.at.fileDirPath =
        callerInfo.stackFrame.at.filePath.substring(0, callerInfo.stackFrame.at.filePath.lastIndexOf("/"))
      callerInfo.stackFrame.at.fileName =
        callerInfo.stackFrame.at.filePath.substring(callerInfo.stackFrame.at.filePath.lastIndexOf("/") + 1)
      callerInfo.stackFrame.at.fileTitle =
        callerInfo.stackFrame.at.fileName.substring(0, callerInfo.stackFrame.at.fileName.lastIndexOf("."))
      callerInfo.stackFrame.at.lineNumber = Number(atLocationComponents[1])
      callerInfo.stackFrame.at.columnNumber = Number(atLocationComponents[2])
    }

    return callerInfo
  }
}


export class hilogxxx {
  // function info(domain: number, tag: string, format: string, ...args: ESObject[]): void {
  //
  // }
  //
  // function warn(domain: number, tag: string, format: string, ...args: ESObject[]): void {
  //
  // }
  //
  // function error(domain: number, tag: string, format: string, ...args: ESObject[]): void {
  //
  // }
  //
  // function fatal(domain: number, tag: string, format: string, ...args: ESObject[]): void {
  //
  // }
  //
  // function isLoggable(domain: number, tag: string, level: LogLevel): boolean {
  //
  // }
  //
  // function setMinLogLevel(level: LogLevel): void {
  //
  // }
  //
  // enum LogLevel {
  //   DEBUG = 3,
  //   INFO = 4,
  //   WARN = 5,
  //   ERROR = 6,
  //   FATAL = 7
  // }
  //
  // public static getCallerInfo(stackFrameIndex?: number): CallerInfo {
  //   let error = new Error()
  //   let callerInfo: CallerInfo = {}
  //   callerInfo.stackTrace = error.stack?.trim()?.split("\n")
  //   callerInfo.stackFrame = {}
  //   callerInfo.stackFrame.index = stackFrameIndex ?? 1
  //   callerInfo.stackFrame.text = callerInfo.stackTrace?.[callerInfo.stackFrame.index]
  //
  //   if (callerInfo.stackFrame.text?.length) {
  //     callerInfo.stackFrame.at = {}
  //     callerInfo.stackFrame.at.text = callerInfo.stackFrame.text.trim()
  //
  //     let atComponents = callerInfo.stackFrame.at.text.split(" ")
  //     callerInfo.stackFrame.at.classFunction = atComponents[1]
  //
  //     let atClassFunctionComponents = callerInfo.stackFrame.at.classFunction.split(".")
  //     callerInfo.stackFrame.at.className = atClassFunctionComponents.length > 1 ? atClassFunctionComponents[0] : undefined
  //     callerInfo.stackFrame.at.functionName = atClassFunctionComponents.length > 1 ? atClassFunctionComponents[1] : callerInfo.stackFrame.at.classFunction
  //
  //     callerInfo.stackFrame.at.location = atComponents[2].substring(1, atComponents[2].length - 1)
  //
  //     let atLocationComponents = callerInfo.stackFrame.at.location.split(":")
  //     callerInfo.stackFrame.at.filePath = atLocationComponents[0]
  //     callerInfo.stackFrame.at.fileDirPath = callerInfo.stackFrame.at.filePath.substring(0, callerInfo.stackFrame.at.filePath.lastIndexOf("/"))
  //     callerInfo.stackFrame.at.fileName = callerInfo.stackFrame.at.filePath.substring(callerInfo.stackFrame.at.filePath.lastIndexOf("/") + 1)
  //     callerInfo.stackFrame.at.fileTitle = callerInfo.stackFrame.at.fileName.substring(0, callerInfo.stackFrame.at.fileName.lastIndexOf("."))
  //     callerInfo.stackFrame.at.lineNumber = Number(atLocationComponents[1])
  //     callerInfo.stackFrame.at.columnNumber = Number(atLocationComponents[2])
  //   }
  //
  //   return callerInfo
  // }
}
