import { hilog } from '@kit.PerformanceAnalysisKit';
import { BaseDao, DaoSession, GlobalContext, Property } from '@ohos/dataorm';
import { WkDocModel } from './WkDocModel';


@ObservedV2
class Example08_MainPageViewModel {
  @Trace pageTitle: string | null = 'dataorm examples';
  @Trace docModels: WkDocModel[] = [];
}

@Preview
@Entry
@ComponentV2
struct Example08_MainPage {
  viewModel: Example08_MainPageViewModel = new Example08_MainPageViewModel()

  aboutToAppear() {
    console.info('[Example08_MainPage] aboutToAppear')
    this.reloadDocList()
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
      Example08_MainPageBodyActionListItem({ title: '查询所有数据' }).onClick(() => {
        this.reloadDocList()
      })
      Example08_MainPageBodyActionListItem({ title: '新增1条数据' }).onClick(() => {
        this.insertNewDocModel()
      })
    }.lanes(3).padding({ left: 10, right: 10 }).borderColor(Color.Gray).borderWidth({ bottom: 0.5 })
  }

  @Builder
  pageBodyDataListViewBuilder() {
    List({ space: 10 }) {
      ForEach(this.viewModel.docModels, (docModel: WkDocModel, index: number) => {
        Example08_MainPageDataListItem({
          index: index, docModel: docModel, onSwipeDelete: () => {
            this.deleteDocModel(index)
          }
        })
      })
    }.padding({ left: 10, right: 10 }).layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])
  }

  async reloadDocList() {
    let entityClass = GlobalContext.getContext().getValue(GlobalContext.KEY_CLS) as Record<string, Object>;
    let properties = entityClass.WkDocModel as Record<string, Property>;

    let daoSession = GlobalContext.getContext().getValue("daoSession") as DaoSession;
    let docModelDao: BaseDao<WkDocModel, number> | null = daoSession.getBaseDao(WkDocModel);

    let docModelsQuery = docModelDao.queryBuilder().orderAsc(properties.lastViewedTimestamp).build();
    let docModels: Array<WkDocModel> = await docModelsQuery.list();
    hilog.info(0x0000, 'dataorm', `list - ${docModels.length} 条: ${JSON.stringify(docModels)}`);

    this.viewModel.docModels = docModels
    this.getUIContext().getPromptAction().showToast({
      message: `已查询所有数据：${this.viewModel.docModels.length}条`
    });
  }

  async insertNewDocModel() {
    let docModel = new WkDocModel();
    docModel.docId = `${Math.floor(Math.random() * 100) + 1}`
    docModel.title = `文档 ${docModel.docId}`
    docModel.lastViewedDate = new Date() //docModel.lastViewedTimestamp = (new Date()).getTime()

    let daoSession = GlobalContext.getContext().getValue("daoSession") as DaoSession;
    let docModelDao: BaseDao<WkDocModel, number> | null = daoSession.getBaseDao(WkDocModel);
    docModel.pkId = await docModelDao.insert(docModel)

    this.viewModel.docModels.push(docModel)
    this.getUIContext().getPromptAction().showToast({
      message: `已新增1条数据，共${this.viewModel.docModels.length}条`
    });
  }

  async deleteDocModel(index: number) {
    let docModel = this.viewModel.docModels.splice(index, 1)[0];

    let daoSession = GlobalContext.getContext().getValue("daoSession") as DaoSession;
    let docModelDao: BaseDao<WkDocModel, number> | null = daoSession.getBaseDao(WkDocModel);
    await docModelDao.deleteByKeyAsync(docModel.pkId)

    this.getUIContext().getPromptAction().showToast({
      message: `已删除1条数据：${docModel.docId}，剩余${this.viewModel.docModels.length}条`
    });
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
  @State index?: number | null = null
  @State docModel?: WkDocModel | null = null
  onSwipeDelete?: (event: ClickEvent) => void;

  build() {
    ListItem() {
      Column() {
        Row() {
          Text(`No.${this.index}`).fontSize(13)
          Blank().width(10)
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
    }.padding({ top: 5, bottom: 5 }).swipeAction({
      end: {
        builder: this.itemEndBuilder,
      }
    })
  }

  @Builder
  itemEndBuilder() {
    Button('删除').type(ButtonType.Normal).backgroundColor('#EB5545').onClick(this.onSwipeDelete)
  }
}