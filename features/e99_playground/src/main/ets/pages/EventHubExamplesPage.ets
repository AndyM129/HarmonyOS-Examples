import { hilogx } from '@andym129/hilogx'
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { common } from '@kit.AbilityKit'
import { ExamplesPageItemModel } from 'models'

interface EventHubExamplesPageBodyListItemBuilderParams {
  title?: string
  subtitle?: string | string[]
  onClick?: (event: ClickEvent) => void
}

// 详见文档 https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/uiability-data-sync-with-ui
@HMRouter({ pageUrl: 'EventHubExamplesPage' })
@Component
export struct EventHubExamplesPage {
  /** 页面标题 */
  static readonly PAGE_TITLE: string = 'EventHubExamplesPage'
  /** 页面子标题 */
  static readonly PAGE_SUBTITLE: string = 'EventHub为UIAbility组件提供了事件机制，使它们能够进行订阅、取消订阅和触发事件等数据通信能力。'

  /** 静态方法，用于在示例页面中展示 */
  static examplesPageItemModel() {
    return new ExamplesPageItemModel({
      title: EventHubExamplesPage.PAGE_TITLE, subtitle: EventHubExamplesPage.PAGE_SUBTITLE, onClick: () => {
        HMRouterMgr.push({
          pageUrl: 'EventHubExamplesPage', param: {}
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
        Text(EventHubExamplesPage.PAGE_TITLE)
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
        title: '示例1', subtitle: ''
      })
      this.pageBodyListItemBuilder({
        title: '订阅 event1', subtitle: '', onClick: () => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext
          context.eventHub.on('event1', this.eventFunc_1);
          hilogx.debugToast(`on event1`)
        }
      })
      this.pageBodyListItemBuilder({
        title: '触发 event1', subtitle: '', onClick: () => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext
          context.eventHub.emit('event1', 'arg1', 'arg2');
        }
      })
      this.pageBodyListItemBuilder({
        title: '取消订阅 event1', subtitle: '', onClick: () => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext
          context.eventHub.off('event1');
          hilogx.debugToast(`off event1`)
        }
      })

      this.pageBodyListItemBuilder({
        title: '示例2', subtitle: ''
      })
      this.pageBodyListItemBuilder({
        title: '订阅 event2', subtitle: '', onClick: () => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext
          context.eventHub.on('event2', (data: string) => {
            hilogx.debugToast('event2: ' + `${data}`);
          })
          hilogx.debugToast(`on event2`)
        }
      })
      this.pageBodyListItemBuilder({
        title: '触发 event2', subtitle: '', onClick: () => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext
          context.eventHub.emit('event2', 'test');
        }
      })
      this.pageBodyListItemBuilder({
        title: '取消订阅 event2', subtitle: '', onClick: () => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext
          context.eventHub.off('event2');
          hilogx.debugToast(`off event2`)
        }
      })
    }.layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])
  }

  @Builder
  pageBodyListItemBuilder(params?: EventHubExamplesPageBodyListItemBuilderParams) {
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

  eventFunc_1(argOne: Context, argTwo: Context): void {
    hilogx.debugToast('event1: ' + `${argOne}, ${argTwo}`);
  }
}