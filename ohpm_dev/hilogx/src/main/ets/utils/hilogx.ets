import { hilog } from '@kit.PerformanceAnalysisKit';

export namespace hilogx {

  /** 默认 Domain */
  export let defaultDomain = 0xA129

  /** 默认 Tag */
  export let defaultTag = 'hilogx'

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

  interface LogInfo {
    domain?: number
    tag?: string
    labels?: string[]
    format?: string
    args?: ESObject[]
  }

  export function debug(...args: ESObject[]) {
    let logInfo = parseArgs(...args);
    return hilog.debug(logInfo.domain || defaultDomain, logInfo.tag || defaultTag, logInfo.format, ...logInfo.args ?? []);
  }

  export function info(...args: ESObject[]) {
    let logInfo = parseArgs(...args);
    return hilog.info(logInfo.domain || defaultDomain, logInfo.tag || defaultTag, logInfo.format, ...logInfo.args ?? []);
  }

  export function warn(...args: ESObject[]) {
    let logInfo = parseArgs(...args);
    return hilog.warn(logInfo.domain || defaultDomain, logInfo.tag || defaultTag, logInfo.format, ...logInfo.args ?? []);
  }

  export function error(...args: ESObject[]) {
    let logInfo = parseArgs(...args);
    return hilog.error(logInfo.domain || defaultDomain, logInfo.tag || defaultTag, logInfo.format, ...logInfo.args ?? []);
  }

  export function fatal(...args: ESObject[]) {
    let logInfo = parseArgs(...args);
    return hilog.fatal(logInfo.domain || defaultDomain, logInfo.tag || defaultTag, logInfo.format, ...logInfo.args ?? []);
  }

  function parseArgs(...args: ESObject[]): LogInfo {
    let logInfo: LogInfo = {}

    // 如果第一个参数是 number，则作为 domain 使用
    if (args.length > 0) {
      if (typeof args[0] === 'number') {
        logInfo.domain = args.shift();
      }
    }

    // 如果第一个参数是 string，且下一个参数是数组，则将其视为 tag
    if (args.length > 0) {
      if (typeof args[0] === 'string' && args[1] && (Array.isArray(args[1]) || typeof args[1] === 'string')) {
        logInfo.tag = args.shift() as string;
      }
    }

    // 如果是数组，视为 labels
    if (args.length > 0) {
      if (Array.isArray(args[0])) {
        logInfo.labels = args.shift() as string[];
      }
    }

    // 如果是 string，视为 format
    if (args.length > 0 && typeof args[0] === 'string') {
      logInfo.format = args.shift() as string;
    }

    // 剩余参数作为 debugArgs
    logInfo.args = args as ESObject[];

    // 基于 Caller 信息，构造最终的 format
    let callerInfo = getCallerInfo(3);
    logInfo.format = `[at (${callerInfo.stackFrame?.at?.location}) - ${callerInfo.stackFrame?.at?.classFunction}]${logInfo?.labels?.length ? (' #' + logInfo.labels.join(' #')) : ''} ➤ ${logInfo.format ?? ''}`;

    return logInfo
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
      callerInfo.stackFrame.at.className = atClassFunctionComponents.length > 1 ? atClassFunctionComponents[0] : undefined
      callerInfo.stackFrame.at.functionName = atClassFunctionComponents.length > 1 ? atClassFunctionComponents[1] : callerInfo.stackFrame.at.classFunction
      callerInfo.stackFrame.at.location = atComponents[2].substring(1, atComponents[2].length - 1)

      let atLocationComponents = callerInfo.stackFrame.at.location.split(":")
      callerInfo.stackFrame.at.filePath = atLocationComponents[0]
      callerInfo.stackFrame.at.fileDirPath = callerInfo.stackFrame.at.filePath.substring(0, callerInfo.stackFrame.at.filePath.lastIndexOf("/"))
      callerInfo.stackFrame.at.fileName = callerInfo.stackFrame.at.filePath.substring(callerInfo.stackFrame.at.filePath.lastIndexOf("/") + 1)
      callerInfo.stackFrame.at.fileTitle = callerInfo.stackFrame.at.fileName.substring(0, callerInfo.stackFrame.at.fileName.lastIndexOf("."))
      callerInfo.stackFrame.at.lineNumber = Number(atLocationComponents[1])
      callerInfo.stackFrame.at.columnNumber = Number(atLocationComponents[2])
    }

    return callerInfo
  }

}