import { hilog } from '@kit.PerformanceAnalysisKit'

const DOMAIN = 0xFF00
const TAG = "MyApp"

export class DebugLog1 {
  static debug(msg: string, ...args: ESObject[]) {
    hilog.debug(DOMAIN, TAG, msg, ...args)
  }

  static info(msg: string, ...args: ESObject[]) {
    hilog.info(DOMAIN, TAG, msg, ...args)
  }

  static warn(msg: string, ...args: ESObject[]) {
    hilog.warn(DOMAIN, TAG, msg, ...args)
  }

  static error(msg: string, ...args: ESObject[]) {
    hilog.error(DOMAIN, TAG, msg, ...args)
  }
}