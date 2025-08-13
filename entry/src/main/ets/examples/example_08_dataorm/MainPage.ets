import { hilog } from '@kit.PerformanceAnalysisKit';
import { BaseDao, DaoSession, GlobalContext, Property } from '@ohos/dataorm';
import { WkDocModel } from './WkDocModel';


@ObservedV2
class Example08_MainPageItemModel {
  docModel?: WkDocModel | null;

  constructor(docModel?: WkDocModel | null) {
    this.docModel = docModel;
  }
}


@ObservedV2
class Example08_MainPageViewModel {
  @Trace pageTitle: string | null = 'dataorm examples';
  @Trace items: Example08_MainPageItemModel[] | null = [];
  @Trace docModels: WkDocModel[] | null = [];
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

      Example08_MainPageBodyActionListItem({ title: '查询所有数据' }).onClick(async () => {
        let entityClass = GlobalContext.getContext().getValue(GlobalContext.KEY_CLS) as Record<string, Object>;
        let properties = entityClass.WkDocModel as Record<string, Property>;

        let daoSession = GlobalContext.getContext().getValue("daoSession") as DaoSession;
        let docModelDao: BaseDao<WkDocModel, number> | null = daoSession.getBaseDao(WkDocModel);

        let docModelsQuery = docModelDao.queryBuilder().orderAsc(properties.lastViewedTimestamp).build();
        let docModels: Array<WkDocModel> = await docModelsQuery.list();
        hilog.info(0x0000, 'dataorm', `list - ${docModels.length} 条: ${JSON.stringify(docModels)}`);

        this.viewModel.docModels = docModels
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


    }.lanes(3).padding({ left: 10, right: 10 }).borderColor(Color.Gray).borderWidth({ bottom: 0.5 })
  }

  @Builder
  pageBodyDataListViewBuilder() {
    List({ space: 10 }) {
      ForEach(this.viewModel.docModels, (docModel: WkDocModel) => {
        Example08_MainPageDataListItem({ docModel: docModel })
      }, (docModel: WkDocModel, index: number) => docModel.docId)
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
  @State docModel?: WkDocModel | null = null

  build() {
    ListItem() {
      Column() {
        Row() {
          Text(`DocId=${this.docModel?.docId}`).fontSize(18)
          Blank().width(10)
          Text(this.docModel?.title)
            .fontSize(18)
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }.width('100%').justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Center)

        Text(this.docModel?.formattedLastViewedDate).fontSize(13).fontColor('#b8b8b8')
      }.width("100%").alignItems(HorizontalAlign.Start)
    }.padding({ top: 5, bottom: 5 })
  }
}