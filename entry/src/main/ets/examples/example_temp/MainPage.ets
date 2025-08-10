type Nil = null | undefined;

@ObservedV2
class MainPageItemModel {
  title?: string | Nil;

  constructor(title?: string | Nil) {
    this.title = title;
  }
}


@ObservedV2
class MainPageViewModel {
  @Trace pageTitle: string | null = 'MainPage';
  @Trace items: MainPageItemModel[] | null = [];
}


@Preview
@Entry
@ComponentV2
struct MainPage {
  viewModel: MainPageViewModel = new MainPageViewModel()

  aboutToAppear() {
    console.info('[MainPage] aboutToAppear')
  }

  onDidBuild(): void {
    console.info('[MainPage] onDidBuild')
  }

  onPageShow(): void {
    console.info('[MainPage] onPageShow')
  }

  onBackPress(): boolean | void {
    console.info('[MainPage] onBackPress')
  }

  onPageHide(): void {
    console.info('[MainPage] onPageHide')
  }

  aboutToDisappear() {
    console.info('[MainPage] aboutToDisappear')
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
            this.viewModel.items?.push(new MainPageItemModel(`Item ${this.viewModel.items.length}`))
          })
        }
      }

      ForEach(this.viewModel.items, (item: MainPageItemModel) => {
        MainPageListItem({ title: item.title })
      }, (item: string, index: number) => item)
    }.padding({ left: 10, right: 10 }).layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])

  }
}

@Preview
@Component
struct MainPageListItem {
  @State title: string | Nil = null

  build() {
    ListItem() {
      Column() {
        Text(this.title).margin(10)
      }.width("100%").alignItems(HorizontalAlign.Start)
    }
  }
}