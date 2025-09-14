import { hilogx } from '@andym129/hilogx'
import { closeLog, openLog } from '@free/log'
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { ExamplesPageItemModel } from 'models'
import { DebugLog1 } from './DebugLog1'
import { DebugLog2 } from './DebugLog2'
import { DebugLog3 } from './DebugLog3'
import { DebugLog4 } from './DebugLog4'
import { util } from '@kit.ArkTS'

interface DebugLogExamplePageBodyListItemBuilderParams {
  title?: string
  subtitle?: string | string[]
  onClick?: (event: ClickEvent) => void
}

@HMRouter({ pageUrl: 'DebugLogExamplePage' })
@Component
export struct DebugLogExamplePage {
  /** 页面标题 */
  static readonly PAGE_TITLE: string = 'DebugLogExamplePage'
  /** 页面子标题 */
  static readonly PAGE_SUBTITLE: string = 'DebugLog 相关示例'

  /** 静态方法，用于在示例页面中展示 */
  static examplesPageItemModel() {
    return new ExamplesPageItemModel({
      title: DebugLogExamplePage.PAGE_TITLE, subtitle: DebugLogExamplePage.PAGE_SUBTITLE, onClick: () => {
        HMRouterMgr.push({
          pageUrl: 'DebugLogExamplePage', param: {}
        })
      }
    })
  }

  build() {
    Column() {
      this.pageTitleBarBuilder()
      this.pageBodyBuilder()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  // 标题栏
  @Builder
  pageTitleBarBuilder() {
    Column() {
      RelativeContainer() {
        Button('返回', { type: ButtonType.Normal })
          .backgroundColor(Color.Transparent)
          .fontColor(Color.Gray)
          .onClick((event: ClickEvent) => {
            HMRouterMgr.pop()
          })
        Text(DebugLogExamplePage.PAGE_TITLE)
          .id('title')
          .fontSize(18)
          .fontColor(0x222222)
          .fontWeight(FontWeight.Normal)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
          })
          .margin({ left: 50, right: 50 })
      }.height(43).width("100%")
    }.expandSafeArea([SafeAreaType.SYSTEM])
  }

  @Builder
  pageBodyBuilder() {
    this.pageBodyListBuilder()
  }

  @Builder
  pageBodyListBuilder() {
    List({ space: 1 }) {
      this.pageBodyListItemBuilder({
        title: '使用 hilog 模块（官方推荐方式）',
        subtitle: '鸿蒙提供了系统级的日志框架 HiLog，功能类似 iOS 的 os_log 或 Android 的 Log'
      })
      this.pageBodyListItemBuilder({
        title: '基本使用',
        subtitle: '',
        onClick: () => {

          // DOMAIN 自定义的日志域，范围 0x0 - 0xFFFF，建议为项目分配一个固定值，方便过滤
          const DOMAIN = 0xFF00

          // 日志标签，方便过滤
          const TAG = "MyApp"

          // a. 日志等级。
          // 说明： 日志级别要符合日志内容的实际级别，日志级别说明如下：
          // FATAL：重大致命异常，表明程序或功能即将崩溃，故障无法恢复。
          // ERROR：程序或功能发生了错误，该错误会影响功能的正常运行或用户的正常使用，可以恢复但恢复代价较高，如重置数据等。
          // WARN：发生了较为严重的非预期情况，但是对用户影响不大，程序可以自动恢复或通过简单的操作就可以恢复的问题。
          // INFO：用来记录业务关键流程节点，可以还原业务的主要运行过程；用来记录非正常情况信息，但这些情况都是可以预期的(如无网络信号、登录失败等)。这些日志都应该由该业务内处于支配地位的模块来记录，避免在多个被调用的模块或低级函数中重复记录。
          // DEBUG：比INFO级别更详细的流程记录，通过该级别的日志可以更详细地分析业务流程和定位分析问题。DEBUG级别的日志在正式发布版本中默认不会被打印，只有在调试版本或打开调试开关的情况下才会打印。
          //
          // 日志等级：debug < info < warn < error < fatal。
          // %{public}s / %{private}s 用于指定日志是否允许被外部工具明文看到（涉及隐私时要注意）
          hilog.debug(DOMAIN, TAG, "调试日志 message=hello debug")
          hilog.debug(DOMAIN, TAG, "调试日志 message=hello debug", [1, 2, 3])
          hilog.debug(DOMAIN, TAG, "调试日志 message=%{public}s", "hello debug")
          hilog.info(DOMAIN, TAG, "普通信息日志 message=%{public}s", "hello info")
          hilog.warn(DOMAIN, TAG, "警告日志 message=%{public}s", "hello warn")
          hilog.error(DOMAIN, TAG, "错误日志 message=%{public}s", "hello error")
          hilog.fatal(DOMAIN, TAG, "严重错误日志 message=%{public}s", "hello fatal")

          // 示例输出如下
          // 09-11 14:56:06.557   2280-2280     A0ff00/MyApp                    com.examp...examples  D     调试日志 message=hello debug
          // 09-11 14:56:06.557   2280-2280     A0ff00/MyApp                    com.examp...examples  I     普通信息日志 message=hello info
          // 09-11 14:56:06.557   2280-2280     A0ff00/MyApp                    com.examp...examples  W     警告日志 message=hello warn
          // 09-11 14:56:06.557   2280-2280     A0ff00/MyApp                    com.examp...examples  E     错误日志 message=hello error
          // 09-11 14:56:06.557   2280-2280     A0ff00/MyApp                    com.examp...examples  F     严重错误日志 message=hello fatal
        }
      })
      this.pageBodyListItemBuilder({
        title: 'hilog.setMinLogLevel(hilog.LogLevel.DEBUG)',
        subtitle: '',
        onClick: () => {
          hilog.setMinLogLevel(hilog.LogLevel.DEBUG)
        }
      })
      this.pageBodyListItemBuilder({
        title: 'hilog.setMinLogLevel(hilog.LogLevel.INFO)',
        subtitle: '',
        onClick: () => {
          hilog.setMinLogLevel(hilog.LogLevel.INFO)
        }
      })
      this.pageBodyListItemBuilder({
        title: 'hilog.setMinLogLevel(hilog.LogLevel.WARN)',
        subtitle: '',
        onClick: () => {
          hilog.setMinLogLevel(hilog.LogLevel.WARN)
        }
      })
      this.pageBodyListItemBuilder({
        title: 'hilog.setMinLogLevel(hilog.LogLevel.ERROR)',
        subtitle: '',
        onClick: () => {
          hilog.setMinLogLevel(hilog.LogLevel.ERROR)
        }
      })
      this.pageBodyListItemBuilder({
        title: 'hilog.setMinLogLevel(hilog.LogLevel.FATAL)',
        subtitle: '',
        onClick: () => {
          hilog.setMinLogLevel(hilog.LogLevel.FATAL)
        }
      })

      this.pageBodyListItemBuilder({
        title: '使用 console 对象（前端风格）',
        subtitle: '开发调试时，可以直接用类似 JS 的 console'
      })
      this.pageBodyListItemBuilder({
        title: '基本使用',
        subtitle: '',
        onClick: () => {
          console.debug("debug 日志")
          console.log("log 日志")
          console.info("info 日志")
          console.warn("warn 日志")
          console.error("error 日志")

          // 示例输出如下
          // 09-11 15:14:37.906   5764-5764     A03d00/JSAPP                    com.examp...examples  D     debug 日志
          // 09-11 15:14:37.906   5764-5764     A03d00/JSAPP                    com.examp...examples  I     info 日志
          // 09-11 15:14:37.906   5764-5764     A03d00/JSAPP                    com.examp...examples  W     warn 日志
          // 09-11 15:14:37.906   5764-5764     A03d00/JSAPP                    com.examp...examples  E     error 日志
        }
      })

      this.pageBodyListItemBuilder({
        title: '自定义日志工具类 - DebugLog1',
        subtitle: '为了统一管理日志，可以自己写一个日志工具类'
      })
      this.pageBodyListItemBuilder({
        title: '基本用法',
        subtitle: '',
        onClick: () => {
          DebugLog1.debug('hello debug')
          DebugLog1.error('hello error')
        }
      })

      this.pageBodyListItemBuilder({
        title: '自定义日志工具类 - DebugLog2',
        subtitle: 'wk 的日志工具类'
      })
      this.pageBodyListItemBuilder({
        title: '基本用法',
        subtitle: '',
        onClick: () => {
          DebugLog2.d('debug 日志')
          DebugLog2.i('info 日志')
          DebugLog2.w('warn 日志')
          DebugLog2.e('error 日志')
        }
      })

      this.pageBodyListItemBuilder({
        title: '自定义日志工具类 - 调研',
        subtitle: '获取当前的类名、方法名、行号'
      })
      this.pageBodyListItemBuilder({
        title: '调研 1',
        onClick: () => {
          const error = new Error()
          const stackLines = error.stack?.split("\n")
          console.debug(`stackLines = ${stackLines}`)
        }
      })
      this.pageBodyListItemBuilder({
        title: '调研 2',
        onClick: () => {
          const DOMAIN = 0xFF00
          const TAG = "MyApp"

          let callerInfo = DebugLog3.getCallerInfo(1)
          hilog.debug(DOMAIN, TAG, `[${callerInfo.fileName}:${callerInfo.lineNumber}:${callerInfo.columnNumber} - ${callerInfo.classFunction}] debug 日志`)
        }
      })
      this.pageBodyListItemBuilder({
        title: '调研 3',
        onClick: () => {
          const DOMAIN = 0xFF00
          const TAG = "MyApp"

          let callerInfo = DebugLog3.getCallerInfo(1)
          hilog.debug(DOMAIN, TAG, `[${callerInfo.filePath}:${callerInfo.lineNumber}:${callerInfo.columnNumber} - ${callerInfo.classFunction}] debug 日志`)
          hilog.debug(DOMAIN, TAG, `[(${callerInfo.filePath}:${callerInfo.lineNumber}:${callerInfo.columnNumber}) - ${callerInfo.classFunction}] debug 日志`)
          hilog.debug(DOMAIN, TAG, `[ (${callerInfo.filePath}:${callerInfo.lineNumber}:${callerInfo.columnNumber}) - ${callerInfo.classFunction}] debug 日志`)
          hilog.debug(DOMAIN, TAG, `[ ${callerInfo.stackFrame} - ${callerInfo.classFunction}] debug 日志`)
          hilog.debug(DOMAIN, TAG, `[ at ${callerInfo.stackFrame?.trim().split(' ')[2]} - ${callerInfo.classFunction}] debug 日志`)
          hilog.debug(DOMAIN, TAG, `[ at (${callerInfo.filePath}:${callerInfo.lineNumber}:${callerInfo.columnNumber}) - ${callerInfo.classFunction}] debug 日志`)
          hilog.debug(DOMAIN, TAG, `[ at ${callerInfo.filePath}:${callerInfo.lineNumber}:${callerInfo.columnNumber} - ${callerInfo.classFunction}] debug 日志`)
        }
      })

      this.pageBodyListItemBuilder({
        title: '自定义日志工具类 - DebugLog3 - 1',
        subtitle: '基于 wk 的日志工具类'
      })
      this.pageBodyListItemBuilder({
        title: '测试 1',
        onClick: () => {
          this.testDebugLog3_1()
        }
      })
      this.pageBodyListItemBuilder({
        title: '测试 2', onClick: () => {
          this.testDebugLog3_2()
        }
      })

      this.pageBodyListItemBuilder({
        title: '自定义日志工具类 - DebugLog4 调研',
        subtitle: '获取当前的类名、方法名、行号'
      })
      this.pageBodyListItemBuilder({
        title: '测试 1', onClick: () => {
          let callerInfo = DebugLog4.getCallerInfo(1)
          console.debug(`callerInfo = ${JSON.stringify(callerInfo)}`)
        }
      })
      this.pageBodyListItemBuilder({
        title: '测试 2', onClick: () => {
          this.testDebugLog4_1()
        }
      })

      this.pageBodyListItemBuilder({
        title: '自定义日志工具类 - hilogx',
        subtitle: '基于 hilog 的日志工具类，支持打印 log位置信息'
      })
      this.pageBodyListItemBuilder({
        title: '基本使用 - getCallerInfo', onClick: () => {
          this.testHilogx_getCallerInfo()
        }
      })
      this.pageBodyListItemBuilder({
        title: '基本使用 - logs', onClick: () => {
          this.testHilogx()
        }
      })
      this.pageBodyListItemBuilder({
        title: '自定义日志工具类 - hilogx - getMinLogLevel',
        subtitle: '',
        onClick: () => {
          this.getUIContext().getPromptAction().showToast({
            message: `hilogx.getMinLogLevel() => ${hilogx.getMinLogLevel()}`
          });
        }
      })
      this.pageBodyListItemBuilder({
        title: `hilogx.setMinLogLevel(hilogx.LogLevel.DEBUG - ${hilogx.LogLevel.DEBUG})`,
        onClick: () => {
          hilogx.setMinLogLevel(hilogx.LogLevel.DEBUG)
        }
      })
      this.pageBodyListItemBuilder({
        title: `hilogx.setMinLogLevel(hilogx.LogLevel.INFO - ${hilogx.LogLevel.INFO})`,
        onClick: () => {
          hilogx.setMinLogLevel(hilogx.LogLevel.INFO)
        }
      })
      this.pageBodyListItemBuilder({
        title: `hilogx.setMinLogLevel(hilogx.LogLevel.WARN - ${hilog.LogLevel.WARN})`,
        onClick: () => {
          hilogx.setMinLogLevel(hilogx.LogLevel.WARN)
        }
      })
      this.pageBodyListItemBuilder({
        title: `hilogx.setMinLogLevel(hilogx.LogLevel.ERROR - ${hilogx.LogLevel.ERROR})`,
        onClick: () => {
          hilogx.setMinLogLevel(hilogx.LogLevel.ERROR)
        }
      })
      this.pageBodyListItemBuilder({
        title: `hilogx.setMinLogLevel(hilogx.LogLevel.FATAL - ${hilogx.LogLevel.FATAL})`,
        onClick: () => {
          hilogx.setMinLogLevel(hilogx.LogLevel.FATAL)
        }
      })
      this.pageBodyListItemBuilder({
        title: `hilogx.debugToast`,
        onClick: () => {
          hilogx.debugToast('debugToast')
        }
      })

      this.pageBodyListItemBuilder({
        title: '@free/log(V1.0.0)',
        subtitle: '这是鸿蒙版本基于log控制台输出日志，通过摇晃手机弹出控制台输出日志，为我们快速的定位问题，找准的找到问题。'
      })
      this.pageBodyListItemBuilder({
        title: '开启日志监控 20 摇晃幅度',
        subtitle: undefined,
        onClick: () => {
          openLog(20)
        }
      })
      this.pageBodyListItemBuilder({
        title: '关闭日志监控',
        subtitle: undefined,
        onClick: () => {
          closeLog()
        }
      })

      this.pageBodyListItemBuilder({
        title: '使用Aspect工具类提供的AOP切面能力实现监控打印日志',
        subtitle: '详见 https://gitee.com/harmony-free/log/blob/master/src/main/ets/Log.ets#L42-63'
      })
      this.pageBodyListItemBuilder({
        title: '测试1',
        subtitle: undefined,
        onClick: () => {
          util.Aspect.addAfter(console, 'debug', true, (instance: console, method: string, arg: string, ...args: object[]) => {
            let callerInfo = hilogx.getCallerInfo(1)
          })

          // console.debug("debug 日志")
          // console.log("log 日志")
          // console.info("info 日志")
          // console.warn("warn 日志")
          // console.error("error 日志")
          // hilog.debug(DOMAIN, TAG, "调试日志 message=%{public}s", "hello debug")
          // hilog.info(DOMAIN, TAG, "普通信息日志 message=%{public}s", "hello info")
        }
      })
    }.layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])
  }

  @Builder
  pageBodyListItemBuilder(params?: DebugLogExamplePageBodyListItemBuilderParams) {
    ListItem() {
      Column() {
        if (!params?.onClick) {
          Blank().height(20)
        }

        if (params?.title?.length) {
          Text(params.title)
            .width('100%')
            .fontSize(14)
            .fontColor(Color.Black)
            .fontStyle(FontStyle.Normal)
            .fontWeight(FontWeight.Normal)
            .maxLines(5)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }

        if (params?.subtitle && ((typeof params.subtitle === 'string' && params.subtitle.length) ||
          (Array.isArray(params.subtitle) && params.subtitle.length))) {
          Blank().height(10)
          Text((typeof params.subtitle === 'string' ? params.subtitle : params.subtitle.join('\n\n').trim()))
            .width('100%')
            .fontSize(14)
            .fontColor(Color.Gray)
            .fontStyle(FontStyle.Normal)
            .fontWeight(FontWeight.Normal)
            .maxLines(10)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .opacity(params?.onClick ? 1 : 0.7)
    }
    .width('100%')
    .padding({
      left: 20,
      right: 20,
      top: 10,
      bottom: 10
    })
    .backgroundColor(params?.onClick ? Color.White : undefined)
    .onClick(params?.onClick)
  }

  testDebugLog3_1() {
    DebugLog3.d('debug 日志')
    DebugLog3.i('info 日志')
    DebugLog3.w('warn 日志')
    DebugLog3.e('error 日志')
  }

  testDebugLog3_2() {
    DebugLog3.d(['标签1', '标签2'], 'debug 日志', 'xxx', 'yyy', 'zzz')
    DebugLog3.i(['标签1', '标签2'], 'info 日志', 'xxx', 'yyy', 'zzz')
    DebugLog3.w(['标签1', '标签2'], 'warn 日志', 'xxx', 'yyy', 'zzz')
    DebugLog3.e(['标签1', '标签2'], 'error 日志', 'xxx', 'yyy', 'zzz')
  }

  testDebugLog4_1() {
    DebugLog4.v('', 'verbose 日志')
    DebugLog4.d('debug 日志', 'xxx', 'yyy', 'zzz')
    DebugLog4.i('info 日志', 'xxx', 'yyy', 'zzz')
    DebugLog4.w('warn 日志', 'xxx', 'yyy', 'zzz')
    DebugLog4.e('error 日志', 'xxx', 'yyy', 'zzz')

    DebugLog4.v('标签', 'verbose 日志')
    DebugLog4.d(['标签1', '标签2'], 'debug 日志', 'xxx', 'yyy', 'zzz')
    DebugLog4.i(['标签1', '标签2'], 'info 日志', 'xxx', 'yyy', 'zzz')
    DebugLog4.w(['标签1', '标签2'], 'warn 日志', 'xxx', 'yyy', 'zzz')
    DebugLog4.e(['标签1', '标签2'], 'error 日志', 'xxx', 'yyy', 'zzz')
  }

  testHilogx_getCallerInfo() {
    let callerInfo = hilogx.getCallerInfo(1)
    console.debug(`callerInfo = ${JSON.stringify(callerInfo, null, 2)}`)
  }

  testHilogx() {
    // 测试数据
    const DOMAIN = 0xFF00
    const TAG = "MyTag"
    const args = 'args blablabla'

    // log 示例
    hilogx.debug(DOMAIN, TAG, ['标签1', '标签2'], 'This is a debug message: %{public}s', args) // 完整参数
    hilogx.debug(TAG, ['标签1', '标签2'], 'This is a debug message: %{public}s', args) // 无 domain
    hilogx.debug(['标签1'], `This is a debug message: ${args}`) // 无 domain 和 tag
    hilogx.debug(`This is a debug message: ${args}`) // 只有 format 和 args
    hilogx.debug()

    // 也可以先支持设置默认值
    hilogx.defaultDomain = 0xFFFF
    hilogx.defaultTag = 'OHExamples'

    hilogx.info(DOMAIN, TAG, ['标签1', '标签2'], 'This is a info message: %{public}s', args) // 完整参数
    hilogx.info(TAG, ['标签1', '标签2'], 'This is a info message: %{public}s', args) // 无 domain
    hilogx.info(['标签1'], `This is a info message: ${args}`) // 无 domain 和 tag
    hilogx.info(`This is a info message: ${args}`) // 只有 format 和 args
    hilogx.info()

    hilogx.warn(DOMAIN, TAG, ['标签1', '标签2'], 'This is a warn message: %{public}s', args) // 完整参数
    hilogx.warn(TAG, ['标签1', '标签2'], 'This is a warn message: %{public}s', args) // 无 domain
    hilogx.warn(['标签1'], `This is a warn message: ${args}`) // 无 domain 和 tag
    hilogx.warn(`This is a warn message: ${args}`) // 只有 format 和 args
    hilogx.warn()

    hilogx.error(DOMAIN, TAG, ['标签1', '标签2'], 'This is a error message: %{public}s', args) // 完整参数
    hilogx.error(TAG, ['标签1', '标签2'], 'This is a error message: %{public}s', args) // 无 domain
    hilogx.error(['标签1'], `This is a error message: ${args}`) // 无 domain 和 tag
    hilogx.error(`This is a error message: ${args}`) // 只有 format 和 args
    hilogx.error()

    hilogx.fatal(DOMAIN, TAG, ['标签1', '标签2'], 'This is a fatal message: %{public}s', args) // 完整参数
    hilogx.fatal(TAG, ['标签1', '标签2'], 'This is a fatal message: %{public}s', args) // 无 domain
    hilogx.fatal(['标签1'], `This is a fatal message: ${args}`) // 无 domain 和 tag
    hilogx.fatal(`This is a fatal message: ${args}`) // 只有 format 和 args
    hilogx.fatal()
  }
}