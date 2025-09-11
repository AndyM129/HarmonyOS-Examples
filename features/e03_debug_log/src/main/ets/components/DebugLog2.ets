import { hilog } from '@kit.PerformanceAnalysisKit';


const DOMAIN: number = 0xFF00
type msgType = string | number | boolean | object

namespace TextUtils { /** 判断空值 */
  export function isEmpty(str: string | undefined): boolean {
    return undefined == str || null == str || "" == str || '' == str;
  }
}

/**
 * wk Log 工具
 */
export class DebugLog2 {
  private static readonly VERBOSE = 1
  private static readonly DEBUG = 2
  private static readonly INFO = 3
  private static readonly WARN = 4
  private static readonly ERROR = 5
  public static readonly LEVEL = DebugLog2.VERBOSE

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
    if (DebugLog2.LEVEL <= DebugLog2.VERBOSE) {
      console.info(tag, msg)
    }
  }

  static d(...args: msgType[]) {
    if (!DebugLog2.changeFormat(args)) {
      return
    }
    if (DebugLog2.LEVEL <= DebugLog2.DEBUG) {
      hilog.debug(DebugLog2.domain, DebugLog2.tag, DebugLog2.format, args)
    }

  }

  static i(...args: msgType[]) {
    if (!DebugLog2.changeFormat(args)) {
      return
    }
    if (DebugLog2.LEVEL <= DebugLog2.INFO) {
      hilog.info(DebugLog2.domain, DebugLog2.tag, DebugLog2.format, args)
    }

  }

  static w(...args: msgType[]) {
    if (!DebugLog2.changeFormat(args)) {
      return
    }
    if (DebugLog2.LEVEL <= DebugLog2.WARN) {
      hilog.warn(DebugLog2.domain, DebugLog2.tag, DebugLog2.format, args)
    }

  }

  static e(...args: msgType[]) {
    if (!DebugLog2.changeFormat(args)) {
      return
    }
    if (DebugLog2.LEVEL <= DebugLog2.ERROR) {
      hilog.error(DebugLog2.domain, DebugLog2.tag, DebugLog2.format, args)
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
      hilog.warn(DebugLog2.domain, DebugLog2.tag, DebugLog2.format, args)
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
    DebugLog2.format = tmpArr.join(separator)
    return true
  }
}
