import { hilog } from '@kit.PerformanceAnalysisKit';


const DOMAIN: number = 0xFF00
type msgType = string | number | boolean | object

interface DebugLog3CallerInfo {
  stackTrace?: string[]
  stackFrameIndex?: number
  stackFrame?: string
  filePath?: string
  fileDirPath?: string
  fileName?: string
  lineNumber?: number
  columnNumber?: number
  functionName?: string
}

namespace TextUtils { /** 判断空值 */
  export function isEmpty(str: string | undefined): boolean {
    return undefined == str || null == str || "" == str || '' == str;
  }
}

/**
 * wk Log 工具
 */
export class DebugLog3 {
  private static readonly VERBOSE = 1
  private static readonly DEBUG = 2
  private static readonly INFO = 3
  private static readonly WARN = 4
  private static readonly ERROR = 5
  public static readonly LEVEL = DebugLog3.VERBOSE

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
    if (DebugLog3.LEVEL <= DebugLog3.VERBOSE) {
      console.info(tag, msg)
    }
  }

  static d(...args: msgType[]) {
    const error = new Error();
    const stackLines = error.stack?.split("\n");
    console.debug(`getCallerInfo = ${JSON.stringify(DebugLog3.getCallerInfo(2))}`)


    if (!DebugLog3.changeFormat(args)) {
      return
    }
    if (DebugLog3.LEVEL <= DebugLog3.DEBUG) {
      hilog.debug(DebugLog3.domain, DebugLog3.tag, DebugLog3.format, args)
    }

  }

  static i(...args: msgType[]) {
    if (!DebugLog3.changeFormat(args)) {
      return
    }
    if (DebugLog3.LEVEL <= DebugLog3.INFO) {
      hilog.info(DebugLog3.domain, DebugLog3.tag, DebugLog3.format, args)
    }

  }

  static w(...args: msgType[]) {
    if (!DebugLog3.changeFormat(args)) {
      return
    }
    if (DebugLog3.LEVEL <= DebugLog3.WARN) {
      hilog.warn(DebugLog3.domain, DebugLog3.tag, DebugLog3.format, args)
    }

  }

  static e(...args: msgType[]) {
    if (!DebugLog3.changeFormat(args)) {
      return
    }
    if (DebugLog3.LEVEL <= DebugLog3.ERROR) {
      hilog.error(DebugLog3.domain, DebugLog3.tag, DebugLog3.format, args)
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
      hilog.warn(DebugLog3.domain, DebugLog3.tag, DebugLog3.format, args)
      return false
    }

    const separator: string = ','
    const tmpArr: msgType[] = []

    args.forEach(item => {
      const type = typeof item;
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
    DebugLog3.format = tmpArr.join(separator)
    return true
  }

  public static getCallerInfo(stackFrameIndex?: number): DebugLog3CallerInfo {
    let error = new Error();
    let callerInfo: DebugLog3CallerInfo = {}
    callerInfo.stackTrace = error.stack?.trim()?.split("\n");
    callerInfo.stackFrameIndex = stackFrameIndex ?? 1
    callerInfo.stackFrame = callerInfo.stackTrace?.[callerInfo.stackFrameIndex];

    if (callerInfo.stackFrame?.length) {
      let prettyStackFrameStart: number = callerInfo.stackFrame.indexOf("(") + 1
      let prettyStackFrameEnd: number = callerInfo.stackFrame.indexOf(")")
      let prettyStackFrame: string = callerInfo.stackFrame.substring(prettyStackFrameStart, prettyStackFrameEnd)
      let stackFrameComponents: string[] = prettyStackFrame.split("/")
      let stackFrameLastComponent: string = stackFrameComponents[stackFrameComponents.length - 1]
      let stackFrameLastComponentComponents: string[] = stackFrameLastComponent.split(":")
      callerInfo.filePath = prettyStackFrame.split(":")[0]
      callerInfo.fileDirPath = callerInfo.filePath.substring(0, callerInfo.filePath.lastIndexOf("/"))
      callerInfo.fileName = stackFrameLastComponentComponents[0]
      callerInfo.lineNumber = Number(stackFrameLastComponentComponents[1])
      callerInfo.columnNumber = Number(stackFrameLastComponentComponents[2])
    }

    return callerInfo
  }
}
