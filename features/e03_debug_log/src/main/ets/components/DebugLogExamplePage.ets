import { HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { ExamplesPageItemModel } from 'models'
import { DebugLog1 } from './DebugLog1'
import { DebugLog2 } from './DebugLog2'
import { DebugLog3 } from './DebugLog3'

interface DebugLogExamplePageBodyListItemBuilderParams {
  title?: string
  subtitle?: string
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
    }.width('100%').height('100%')
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
    }.expandSafeArea([SafeAreaType.SYSTEM]).backgroundColor('#F2F3F5')
  }

  @Builder
  pageBodyBuilder() {
    List({ space: 10 }) {
      this.pageBodyListItemBuilder({
        title: '使用 hilog 模块（官方推荐方式）',
        subtitle: '鸿蒙提供了系统级的日志框架 HiLog，功能类似 iOS 的 os_log 或 Android 的 Log',
        onClick: () => {

          // DOMAIN 自定义的日志域，范围 0x0 - 0xFFFF，建议为项目分配一个固定值，方便过滤
          const DOMAIN = 0xFF00

          // 日志标签，方便过滤
          const TAG = "MyApp"

          // %{public}s / %{private}s 用于指定日志是否允许被外部工具明文看到（涉及隐私时要注意）
          // 日志等级：debug < info < warn < error < fatal。
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
        title: '使用 console 对象（前端风格）', subtitle: '开发调试时，可以直接用类似 JS 的 console', onClick: () => {
          console.debug("debug 日志")
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
        title: '自定义日志工具类 - DebugLog1', subtitle: '为了统一管理日志，可以自己写一个日志工具类', onClick: () => {
          DebugLog1.debug('hello debug')
          DebugLog1.error('hello error')
        }
      })

      this.pageBodyListItemBuilder({
        title: '自定义日志工具类 - DebugLog2', subtitle: 'wk 的日志工具类', onClick: () => {
          DebugLog2.d('debug 日志')
          DebugLog2.i('info 日志')
          DebugLog2.w('warn 日志')
          DebugLog2.e('error 日志')
        }
      })

      this.pageBodyListItemBuilder({
        title: '自定义日志工具类 - 调研 - 获取当前的类名、方法名、行号', subtitle: '', onClick: () => {

          // const error = new Error();
          // const stackLines = error.stack?.split("\n");
          // console.debug(`stackLines = ${stackLines}`)

          DebugLog3.d('debug 日志')

        }
      })

      // this.pageBodyListItemBuilder({
      //   title: '自定义日志工具类 - DebugLog3', subtitle: '基于 wk 的日志工具类', onClick: () => {
      //     DebugLog3.d('debug 日志')
      //     // DebugLog3.i('info 日志')
      //     // DebugLog3.w('warn 日志')
      //     // DebugLog3.e('error 日志')
      //   }
      // })
    }.padding({ left: 10, right: 10 }).layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])
  }

  @Builder
  pageBodyListItemBuilder(params: DebugLogExamplePageBodyListItemBuilderParams) {
    ListItem() {
      Column() {
        if (params.title) {
          Text(params.title)
            .width('100%')
            .fontSize(14)
            .fontColor(Color.Black)
            .fontStyle(FontStyle.Normal)
            .fontWeight(FontWeight.Normal)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        Blank().height(10)
        if (params.subtitle) {
          Text(params.subtitle)
            .width('100%')
            .fontSize(14)
            .fontColor(Color.Gray)
            .fontStyle(FontStyle.Normal)
            .fontWeight(FontWeight.Normal)
            .maxLines(10)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }.layoutWeight(1).justifyContent(FlexAlign.Start).alignItems(HorizontalAlign.Start)
    }.padding(10).onClick(params.onClick)
  }
}