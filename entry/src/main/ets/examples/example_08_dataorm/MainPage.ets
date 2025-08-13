import { hilog } from '@kit.PerformanceAnalysisKit';
import { BaseDao, DaoSession, GlobalContext, Property } from '@ohos/dataorm';
import { WkDocModel } from './WkDocModel';


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

      Example08_MainPageBodyActionListItem({ title: '新增数据' }).onClick(() => {
        let docModel = new WkDocModel();
        docModel.docId = `${Math.floor(Math.random() * 100) + 1}`
        docModel.title = `文档 ${docModel.docId}`
        docModel.lastViewedDate = new Date() //docModel.lastViewedTimestamp = (new Date()).getTime()

        let daoSession = GlobalContext.getContext().getValue("daoSession") as DaoSession;
        let docModelDao: BaseDao<WkDocModel, number> | null = daoSession.getBaseDao(WkDocModel);
        docModelDao.insert(docModel)
      })

      Example08_MainPageBodyActionListItem({ title: '查询所有数据' }).onClick(async () => {
        let entityClass = GlobalContext.getContext().getValue(GlobalContext.KEY_CLS) as Record<string, Object>;
        let properties = entityClass.WkDocModel as Record<string, Property>;

        let daoSession = GlobalContext.getContext().getValue("daoSession") as DaoSession;
        let docModelDao: BaseDao<WkDocModel, number> | null = daoSession.getBaseDao(WkDocModel);

        let docModelsQuery = docModelDao.queryBuilder().orderAsc(properties.lastViewedTimestamp).build();
        let docModels: Array<WkDocModel> = await docModelsQuery.list();
        hilog.info(0x0000, 'dataorm', `list - ${docModels.length} 条: ${JSON.stringify(docModels)}`);
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