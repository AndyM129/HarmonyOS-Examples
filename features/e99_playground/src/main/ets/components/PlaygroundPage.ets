import { hilogx } from '@andym129/hilogx'
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { JSON } from '@kit.ArkTS'
import { ExamplesPageItemModel } from 'models'

interface PlaygroundPageBodyListItemBuilderParams {
  title?: string
  subtitle?: string | string[]
  onClick?: (event: ClickEvent) => void
}

@HMRouter({ pageUrl: 'PlaygroundPage' })
@Component
export struct PlaygroundPage {
  /** 页面标题 */
  static readonly PAGE_TITLE: string = 'PlaygroundPage'
  /** 页面子标题 */
  static readonly PAGE_SUBTITLE: string = '各种测试示例'

  /** 静态方法，用于在示例页面中展示 */
  static examplesPageItemModel() {
    return new ExamplesPageItemModel({
      title: PlaygroundPage.PAGE_TITLE, subtitle: PlaygroundPage.PAGE_SUBTITLE, onClick: () => {
        HMRouterMgr.push({
          pageUrl: 'PlaygroundPage', param: {}
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
        Text(PlaygroundPage.PAGE_TITLE)
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
    List({ space: 10 }) {
      this.pageBodyListItemBuilder({
        title: '类似与 OC 的结果回调', subtitle: ''
      })
      this.pageBodyListItemBuilder({
        title: '示例：aFuncWithCompletion', subtitle: '', onClick: () => {
          type Completion = (params: ESObject) => void;
          let aFuncWithCompletion = (param1: ESObject, params2: ESObject, completion: Completion) => {
            hilogx.debug(`params: ${param1}, ${params2}`)
            hilogx.debug(`completion 准备执行...`)
            completion('我是 completion 的参数')
            hilogx.debug(`completion 准备结束`)
          }

          aFuncWithCompletion('pv1', 'pv2', (params: ESObject) => {
            hilogx.debug(`completion 执行中：params = ${JSON.stringify(params)}`)
          })
        }
      })
    }.layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])
  }

  @Builder
  pageBodyListItemBuilder(params?: PlaygroundPageBodyListItemBuilderParams) {
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
}