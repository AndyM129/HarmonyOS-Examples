import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';

type Nil = null | undefined;

@ObservedV2
class ExamplesPageItemModel {
  title?: string | Nil;

  constructor(title?: string | Nil) {
    this.title = title;
  }
}


@ObservedV2
class ExamplesPageViewModel {
  @Trace pageTitle: string | null = 'ExamplesPage';
  @Trace items: ExamplesPageItemModel[] | null = [];
  @Trace count: number = 1
}

@HMRouter({ pageUrl: 'ExamplesPage' })
@ComponentV2
export struct ExamplesPage {
  viewModel: ExamplesPageViewModel = new ExamplesPageViewModel()

  aboutToAppear() {
    console.info('[ExamplesPage] aboutToAppear')
  }

  onDidBuild(): void {
    console.info('[ExamplesPage] onDidBuild')
  }

  onPageShow(): void {
    console.info('[ExamplesPage] onPageShow')
  }

  onBackPress(): boolean | void {
    console.info('[ExamplesPage] onBackPress')
  }

  onPageHide(): void {
    console.info('[ExamplesPage] onPageHide')
  }

  aboutToDisappear() {
    console.info('[ExamplesPage] aboutToDisappear')
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
        Text(this.viewModel.pageTitle)
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
      ListItem() {
      }

      ListItem() {
        Row() {
          Text(`前往 HMRouterExampleMainPage >>`).fontSize(18)
        }.onClick(() => {
          HMRouterMgr.push({
            pageUrl: 'HMRouterExampleMainPage?msg=abcdef', param: { msg: '111' }
          })
        })
      }

      // ListItem() {
      //   Row() {
      //     Text(`当前计数：${this.viewModel.items?.length}`).fontSize(18)
      //     Blank().layoutWeight(1)
      //     Button('增加计数').onClick(() => {
      //       this.viewModel.items?.push(new ExamplesPageItemModel(`Item ${this.viewModel.items.length}`))
      //     })
      //   }
      // }
      //
      // ForEach(this.viewModel.items, (item: ExamplesPageItemModel) => {
      //   ExamplesPageListItem({ title: item.title })
      // }, (item: string, index: number) => item)
    }.padding({ left: 10, right: 10 }).layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])

  }
}

@Preview
@Component
struct ExamplesPageListItem {
  @State title: string | Nil = null

  build() {
    ListItem() {
      Column() {
        Text(this.title).margin(10)
      }.width("100%").alignItems(HorizontalAlign.Start)
    }
  }
}