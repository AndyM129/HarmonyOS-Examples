import { hilogx } from '@andym129/hilogx'
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { ExamplesPageItemModel } from 'models'

interface ButtonsExampleTemplatePageBodyListItemBuilderParams {
  title?: string
  subtitle?: string | string[]
  onClick?: (event: ClickEvent) => void
  builder?: () => void
}

@HMRouter({ pageUrl: 'ButtonsExampleTemplatePage' })
@Component
export struct ButtonsExampleTemplatePage {
  /** 页面标题 */
  public static readonly PAGE_TITLE: string = 'ButtonsExampleTemplatePage'
  /** 页面子标题 */
  public static readonly PAGE_SUBTITLE: string = '各种按钮 示例页'

  /** 静态方法，用于在示例页面中展示 */
  static examplesPageItemModel() {
    return new ExamplesPageItemModel({
      title: ButtonsExampleTemplatePage.PAGE_TITLE, subtitle: ButtonsExampleTemplatePage.PAGE_SUBTITLE, onClick: () => {
        HMRouterMgr.push({
          pageUrl: 'ButtonsExampleTemplatePage', param: {}
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
        Text(ButtonsExampleTemplatePage.PAGE_TITLE)
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
        title: 'Section title', subtitle: 'Section subtitle'
      })
      ListItem() {
        Row() {
          Button({ type: ButtonType.Normal }) {
            Row() { // @formatter:off
              Blank().width(20).height(20).backgroundColor(Color.White).borderRadius(3).margin({ left: 10, top: 10, bottom: 10 })
              Text('title').fontSize(16).fontColor(Color.White).margin({ left: 5, top: 10, bottom: 10, right: 10 })
            }.justifyContent(FlexAlign.Center).alignItems(VerticalAlign.Center) // @formatter:on
          }.backgroundColor('#3D83E6').borderRadius(8).onClick(() => {
            hilogx.debugToast(`Button clicked`)
          })

          Button({ type: ButtonType.Normal }) {
            Row() { // @formatter:off
              Text('title').fontSize(16).fontColor(Color.White).margin({ left: 10, top: 10, bottom: 10 })
              Blank().width(20).height(20).backgroundColor(Color.White).borderRadius(3).margin({ left: 5, top: 10, bottom: 10, right: 10 })
            }.justifyContent(FlexAlign.Center).alignItems(VerticalAlign.Center) // @formatter:on
          }.backgroundColor('#3D83E6').borderRadius(8).onClick(() => {
            hilogx.debugToast(`Button clicked`)
          })

          Button({ type: ButtonType.Normal }) {
            Column() { // @formatter:off
              Blank().width(20).height(20).backgroundColor(Color.White).borderRadius(3).margin({ top: 5, left: 10, right: 10 })
              Text('title').fontSize(16).fontColor(Color.White).margin({ top: 10, left: 10, right: 10, bottom: 5 })
            }.justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center) // @formatter:on
          }.backgroundColor('#3D83E6').borderRadius(8).onClick(() => {
            hilogx.debugToast(`Button clicked`)
          })

          Button({ type: ButtonType.Normal }) {
            Column() { // @formatter:off
              Text('title').fontSize(16).fontColor(Color.White).margin({ top: 5, left: 10, right: 10 })
              Blank().width(20).height(20).backgroundColor(Color.White).borderRadius(3).margin({ top: 10, left: 10, right: 10, bottom: 5 })
            }.justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center) // @formatter:on
          }.backgroundColor('#3D83E6').borderRadius(8).onClick(() => {
            hilogx.debugToast(`Button clicked`)
          })
        }.width('100%').justifyContent(FlexAlign.SpaceEvenly)
      }.buttonListItem()

    }.layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])
  }

  @Builder
  pageBodyListItemBuilder(params?: ButtonsExampleTemplatePageBodyListItemBuilderParams) {
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
    }.width('100%').padding({
      left: 20,
      right: 20,
      top: 10,
      bottom: 10
    }).backgroundColor(params?.onClick ? Color.White : undefined).onClick(params?.onClick)
  }
}

@Extend(ListItem)
function buttonListItem() {
  .width('100%').padding({
    left: 20,
    right: 20,
    top: 10,
    bottom: 10
  }).backgroundColor(Color.White)
}