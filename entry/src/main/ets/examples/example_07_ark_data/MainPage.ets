
@ObservedV2
class Example07_MainPageItemModel {
  title?: string | null;

  constructor(title?: string | null) {
    this.title = title;
  }
}


@ObservedV2
class Example07_MainPageViewModel {
  @Trace pageTitle: string | null = 'Example07_MainPage';
  @Trace items: Example07_MainPageItemModel[] | null = [];
  @Trace count: number = 1
}


@Preview
@Entry
@ComponentV2
struct Example07_MainPage {
  viewModel: Example07_MainPageViewModel = new Example07_MainPageViewModel()

  aboutToAppear() {
    console.info('[Example07_MainPage] aboutToAppear')
  }

  onDidBuild(): void {
    console.info('[Example07_MainPage] onDidBuild')
  }

  onPageShow(): void {
    console.info('[Example07_MainPage] onPageShow')
  }

  onBackPress(): boolean | void {
    console.info('[Example07_MainPage] onBackPress')
  }

  onPageHide(): void {
    console.info('[Example07_MainPage] onPageHide')
  }

  aboutToDisappear() {
    console.info('[Example07_MainPage] aboutToDisappear')
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
            this.getUIContext().getRouter().back()
          })
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
          Text(`当前计数：${this.viewModel.items?.length}`).fontSize(18)
          Blank().layoutWeight(1)
          Button('增加计数').onClick(() => {
            this.viewModel.items?.push(new Example07_MainPageItemModel(`Item ${this.viewModel.items.length}`))
          })
        }
      }

      ForEach(this.viewModel.items, (item: Example07_MainPageItemModel) => {
        Example07_MainPageListItem({ title: item.title })
      }, (item: string, index: number) => item)
    }.padding({ left: 10, right: 10 }).layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])

  }
}

@Preview
@Component
struct Example07_MainPageListItem {
  @State title?: string | null = null

  build() {
    ListItem() {
      Column() {
        Text(this.title).margin(10)
      }.width("100%").alignItems(HorizontalAlign.Start)
    }
  }
}