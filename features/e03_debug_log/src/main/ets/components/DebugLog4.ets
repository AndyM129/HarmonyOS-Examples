import { hilog } from '@kit.PerformanceAnalysisKit'


const DOMAIN: number = 0xFF00
type msgType = string | number | boolean | object

export interface DebugLog4CallerStackFrameAtInfo {
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

export interface DebugLog4CallerStackFrameInfo {
  index?: number
  text?: string
  at?: DebugLog4CallerStackFrameAtInfo
}

export interface DebugLog4CallerInfo {
  stackTrace?: string[]
  stackFrame?: DebugLog4CallerStackFrameInfo
}

namespace TextUtils { /** 判断空值 */
  export function isEmpty(str: string | undefined): boolean {
    return undefined == str || null == str || "" == str || '' == str
  }
}

/**
 * wk Log 工具
 */
export class DebugLog4 {
  private static readonly VERBOSE = 1
  private static readonly DEBUG = 2
  private static readonly INFO = 3
  private static readonly WARN = 4
  private static readonly ERROR = 5
  public static readonly LEVEL = DebugLog4.VERBOSE

  private static domain: number = DOMAIN
  private static format: string = '%{public}s'
  private static tag: string = 'OHExamplesLog'

  /**
   * 打印verbose级别信息
   *
   * @param tag
   * @param msg
   */
  public static v(tag?: string, msg?: string): void {
    if (TextUtils.isEmpty(msg)) {
      return
    }
    if (DebugLog4.LEVEL <= DebugLog4.VERBOSE) {
      // let callerInfo = DebugLog4.getCallerInfo(2)
      console.info(tag, msg)
    }
  }

  static d(labelsOrMsg?: string[] | msgType, ...args: msgType[]) {
    let labels: string[] = []
    if (Array.isArray(labelsOrMsg)) {
      labels = labelsOrMsg
    } else {
      args = [labelsOrMsg as msgType, ...args]
    }

    if (!DebugLog4.changeFormat(args)) {
      return
    }
    if (DebugLog4.LEVEL <= DebugLog4.DEBUG) {
      let callerInfo = DebugLog4.getCallerInfo(2)
      hilog.debug(DebugLog4.domain, DebugLog4.tag, `[at (${callerInfo.stackFrame?.at?.location}) - ${callerInfo.stackFrame?.at?.classFunction}${labels.length ? (' #'+labels.join(' #')) : ''}] ➤ ${DebugLog4.format}`, args)
    }

  }

  static i(labelsOrMsg?: string[] | msgType, ...args: msgType[]) {
    let labels: string[] = []
    if (Array.isArray(labelsOrMsg)) {
      labels = labelsOrMsg
    } else {
      args = [labelsOrMsg as msgType, ...args]
    }

    if (!DebugLog4.changeFormat(args)) {
      return
    }
    if (DebugLog4.LEVEL <= DebugLog4.INFO) {
      let callerInfo = DebugLog4.getCallerInfo(2)
      hilog.info(DebugLog4.domain, DebugLog4.tag, `[at (${callerInfo.stackFrame?.at?.location}) - ${callerInfo.stackFrame?.at?.classFunction}${labels.length ? (' #'+labels.join(' #')) : ''}] ➤ ${DebugLog4.format}`, args)
    }

  }

  static w(labelsOrMsg?: string[] | msgType, ...args: msgType[]) {
    let labels: string[] = []
    if (Array.isArray(labelsOrMsg)) {
      labels = labelsOrMsg
    } else {
      args = [labelsOrMsg as msgType, ...args]
    }

    if (!DebugLog4.changeFormat(args)) {
      return
    }
    if (DebugLog4.LEVEL <= DebugLog4.WARN) {
      let callerInfo = DebugLog4.getCallerInfo(2)
      hilog.warn(DebugLog4.domain, DebugLog4.tag, `[at (${callerInfo.stackFrame?.at?.location}) - ${callerInfo.stackFrame?.at?.classFunction}${labels.length ? (' #'+labels.join(' #')) : ''}] ➤ ${DebugLog4.format}`, args)
    }

  }

  static e(labelsOrMsg?: string[] | msgType, ...args: msgType[]) {
    let labels: string[] = []
    if (Array.isArray(labelsOrMsg)) {
      labels = labelsOrMsg
    } else {
      args = [labelsOrMsg as msgType, ...args]
    }

    if (!DebugLog4.changeFormat(args)) {
      return
    }
    if (DebugLog4.LEVEL <= DebugLog4.ERROR) {
      let callerInfo = DebugLog4.getCallerInfo(2)
      hilog.error(DebugLog4.domain, DebugLog4.tag, `[at (${callerInfo.stackFrame?.at?.location}) - ${callerInfo.stackFrame?.at?.classFunction}${labels.length ? (' #'+labels.join(' #')) : ''}] ➤ ${DebugLog4.format}`, args)
    }

  }

  /**
   * 根据传参修改 format
   * @param args
   * @returns
   */
  private static changeFormat(args: msgType[]): boolean {
    if (!args?.length) { // 未传参数
      args = ['[No Parameter]']
      hilog.warn(DebugLog4.domain, DebugLog4.tag, DebugLog4.format, args)
      return false
    }

    const separator: string = ','
    const tmpArr: msgType[] = []

    args.forEach(item => {
      const type = typeof item
      switch (type) {
        case 'string':
        case 'number':
          tmpArr.push(item)
          break
        case 'boolean':
          tmpArr.push(item === false ? 'false' : 'true')
          break
        case 'object':
          tmpArr.push(`[${(item as object).constructor.name} Class]`)
          break
        default:
          tmpArr.push('[Unknown]')
          break
      }
    })
    DebugLog4.format = tmpArr.join(separator)
    return true
  }

  public static getCallerInfo(stackFrameIndex?: number): DebugLog4CallerInfo {
    let error = new Error()
    let callerInfo: DebugLog4CallerInfo = {}
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
