// import { Columns, ColumnType, Entity, Id, Index, NotNull } from '@ohos/dataorm';
//
// @Entity('WkDocModel')
// class WkDocModel {
//   @Columns({ columnName: 'pkId', types: ColumnType.num }) @Id({ autoincrement: true }) pkId?: number; // 主键id
//   @Columns({ columnName: 'docId', types: ColumnType.str }) @NotNull() @Index(true) docId?: string;
//   @Columns({ columnName: 'title', types: ColumnType.str }) title?: string;
//
//   constructor(pkId?: number, docId?: string, title?: string) {
//     this.pkId = pkId;
//     this.docId = docId;
//     this.title = title;
//   }
// }


@ObservedV2
class Example08_MainPageItemModel {
  title?: string | null;

  constructor(title?: string | null) {
    this.title = title;
  }
}


@ObservedV2
class Example08_MainPageViewModel {
  @Trace pageTitle: string | null = 'Example08_MainPage';
  @Trace items: Example08_MainPageItemModel[] | null = [];
  @Trace count: number = 1
}

@Preview
@Entry
@ComponentV2
struct Example08_MainPage {
  viewModel: Example08_MainPageViewModel = new Example08_MainPageViewModel()

  aboutToAppear() {
    console.info('[Example08_MainPage] aboutToAppear')
  }

  onDidBuild(): void {
    console.info('[Example08_MainPage] onDidBuild')
  }

  onPageShow(): void {
    console.info('[Example08_MainPage] onPageShow')
  }

  onBackPress(): boolean | void {
    console.info('[Example08_MainPage] onBackPress')
  }

  onPageHide(): void {
    console.info('[Example08_MainPage] onPageHide')
  }

  aboutToDisappear() {
    console.info('[Example08_MainPage] aboutToDisappear')
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
    this.pageBodyActionListViewBuilder()
    this.pageBodyDataListViewBuilder()
  }

  @Builder
  pageBodyActionListViewBuilder() {
    List({ space: 10 }) {
      Example08_MainPageBodyActionListItem({ title: '创建数据库' }).onClick(() => {
        this.getUIContext().getPromptAction().showToast({
          message: 'Hello World'
        });
      })
      Example08_MainPageBodyActionListItem({ title: '创建数据库' }).onClick(() => {
        this.viewModel.items?.push(new Example08_MainPageItemModel(`Item ${this.viewModel.items.length}`))
      })
    }.lanes(3).padding({ left: 10, right: 10 }).borderColor(Color.Gray).borderWidth({ bottom: 0.5 })
  }

  @Builder
  pageBodyDataListViewBuilder() {
    List({ space: 10 }) {
      ForEach(this.viewModel.items, (item: Example08_MainPageItemModel) => {
        Example08_MainPageDataListItem({ title: item.title })
      }, (item: string, index: number) => item)
    }.padding({ left: 10, right: 10 }).layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])
  }
}

@Preview
@Component
struct Example08_MainPageBodyActionListItem {
  title?: string | null = null

  build() {
    ListItem() {
      Button(`${this.title}`)
        .width('100%')
        .fontColor('#4575F6')
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
    }
  }
}

@Preview
@Component
struct Example08_MainPageDataListItem {
  @State title?: string | null = null

  build() {
    ListItem() {
      Column() {
        Text(this.title).margin(10)
      }.width("100%").alignItems(HorizontalAlign.Start)
    }
  }
}