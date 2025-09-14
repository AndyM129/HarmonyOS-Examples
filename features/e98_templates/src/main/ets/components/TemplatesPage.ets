import { HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { ExamplesPageItemModel } from 'models'
import { ButtonsExampleTemplatePage } from '../pages/ButtonsExampleTemplatePage'

interface TemplatesPageBodyListItemBuilderParams {
  title?: string
  subtitle?: string | string[]
  onClick?: (event: ClickEvent) => void
}

@HMRouter({ pageUrl: 'TemplatesPage' })
@Component
export struct TemplatesPage {
  /** 页面标题 */
  static readonly PAGE_TITLE: string = 'TemplatesPage'
  /** 页面子标题 */
  static readonly PAGE_SUBTITLE: string = '各种常见、常用的 UI 模板'

  /** 静态方法，用于在示例页面中展示 */
  static examplesPageItemModel() {
    return new ExamplesPageItemModel({
      title: TemplatesPage.PAGE_TITLE, subtitle: TemplatesPage.PAGE_SUBTITLE, onClick: () => {
        HMRouterMgr.push({
          pageUrl: 'TemplatesPage', param: {}
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
        Text(TemplatesPage.PAGE_TITLE)
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

      // this.pageBodyListItemBuilder({
      //   title: 'Section title', subtitle: 'Section subtitle'
      // })

      this.pageBodyListItemBuilder({
        title: 'ExampleListTemplatePage', subtitle: '基于 ListView 的功能示例页', onClick: () => {
          HMRouterMgr.push({ pageUrl: 'ExampleListTemplatePage', param: {} })
        }
      })
      this.pageBodyListItemBuilder({
        title: ButtonsExampleTemplatePage.PAGE_TITLE,
        subtitle: ButtonsExampleTemplatePage.PAGE_SUBTITLE,
        onClick: ButtonsExampleTemplatePage.examplesPageItemModel().onClick
      })
    }.layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])
  }

  @Builder
  pageBodyListItemBuilder(params?: TemplatesPageBodyListItemBuilderParams) {
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