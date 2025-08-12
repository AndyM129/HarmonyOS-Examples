@ObservedV2
class ListExamplePageItemModel {
  title?: string | null;

  constructor(title?: string | null) {
    this.title = title;
  }
}


@ObservedV2
class ListExamplePageViewModel {
  @Trace pageTitle: string | null = 'ListExamplePage';
  @Trace items: ListExamplePageItemModel[] | null = [];
  @Trace count: number = 1
}


@Preview
@Entry
@ComponentV2
struct ListExamplePage {
  viewModel: ListExamplePageViewModel = new ListExamplePageViewModel()

  aboutToAppear() {
    console.info('[ListExamplePage] aboutToAppear')
    this.viewModel.items?.push(new ListExamplePageItemModel('hello'))
    this.viewModel.items?.push(new ListExamplePageItemModel('world'))
  }

  onDidBuild(): void {
    console.info('[ListExamplePage] onDidBuild')
  }

  onPageShow(): void {
    console.info('[ListExamplePage] onPageShow')
  }

  onBackPress(): boolean | void {
    console.info('[ListExamplePage] onBackPress')
  }

  onPageHide(): void {
    console.info('[ListExamplePage] onPageHide')
  }

  aboutToDisappear() {
    console.info('[ListExamplePage] aboutToDisappear')
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
      ListExamplePageListItem({ title: 'item 01' })
      ListExamplePageListItem({ title: 'item 02' })
      ListExamplePageListItem({ title: 'item 03' })
      ListExamplePageListItem({ title: 'item 04' })

      ForEach(this.viewModel.items, (item: ListExamplePageItemModel, index: number) => {
        ListItem() {
          Text(`ForEach: item ${index}`).margin(10).borderWidth(0.5)
        }
        .swipeAction({
          end: {
            builder: () => {
              this.itemEnd(index)
            },
          }
        }) // 设置侧滑属性.
        .width('100%')
        .borderWidth(0.5)
      }, (item: ListExamplePageItemModel, index: number) => JSON.stringify(item))

      ListItem() {
        Row() {
          Text('text text').borderWidth(0.5)
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Top)
        .borderWidth(0.5)
      }
    }
    .listDirection(Axis.Vertical)
    .scrollBar(BarState.Auto)
    .lanes(1)
    .alignListItem(ListItemAlign.Start)
    .divider({
      color: Color.Gray,
      strokeWidth: 5,
      startMargin: 10,
      endMargin: 10,
    })
    .padding({ left: 10, right: 10 })
    .layoutWeight(1)
    .expandSafeArea([SafeAreaType.SYSTEM])
  }

  @Builder itemEnd(index: number) {
    Button({ type: ButtonType.Circle }) {
      Text('xxx')
    }
    // .onClick(() => {
    //   // this.messages为列表数据源，可根据实际场景构造。点击后从数据源删除指定数据项。
    //   // this.messages.splice(index, 1);
    // })

  }
}

@Preview
@Component
struct ListExamplePageListItem {
  @State title?: string | null = null

  build() {
    ListItem() {
      Text(this.title).margin(10).borderWidth(0.5)
    }.borderWidth(0.5)
  }
}