import json from '@ohos.util.json';
import to from 'await-to-arkts';


@ObservedV2
class Example09_MainPageItemModel {
  title?: string | null;

  constructor(title?: string | null) {
    this.title = title;
  }
}


@ObservedV2
class Example09_MainPageViewModel {
  @Trace pageTitle: string | null = 'Promise';
  @Trace items: Example09_MainPageItemModel[] | null = [];
  @Trace count: number = 1

  fetchData(): Promise<string> {
    return new Promise((resolve, reject) => { // 模拟一个异步操作，例如数据请求
      setTimeout(() => {
        const success = true; // 模拟成功或失败的条件
        if (success) {
          resolve("数据加载成功！"); // 当操作成功时调用 resolve
        } else {
          reject("数据加载失败！"); // 当操作失败时调用 reject
        }
      }, 1000); // 设置一个延迟
    });
  }

  getRandomNumber(): Promise<number> {
    return new Promise((resolve, reject) => { // 模拟一个异步操作，例如数据请求
      setTimeout(() => {
        try {
          const randomNumber: number = Math.random();
          console.info(`[Example09_MainPage] getRandomNumber: ${json.stringify({ 'randomNumber': randomNumber })}`)
          if (randomNumber > 0.5) {
            resolve(randomNumber);
          } else if (randomNumber > 0.3) {
            reject(new Error(`随机数有点小(${randomNumber})`)); // 能被 try-catch 住，否则无法获取返回结果
          } else {
            throw new Error(`随机数太小(${randomNumber})`) // 必须在该 Error 作用域进行 try-catch 处理，否则会 crash
          }
        } catch (error) {
          reject(error);
        }
      }, 1000);
    });
  }

  requestParams(params: Object) {
    return new Promise<Object>((resolve, reject) => {
      setTimeout(() => {
        resolve(params);
      }, 1000);
    });
  }
}


@Preview
@Entry
@ComponentV2
struct Example09_MainPage {
  viewModel: Example09_MainPageViewModel = new Example09_MainPageViewModel()

  aboutToAppear() {
    console.info('[Example09_MainPage] aboutToAppear')
  }

  onDidBuild(): void {
    console.info('[Example09_MainPage] onDidBuild')
  }

  onPageShow(): void {
    console.info('[Example09_MainPage] onPageShow')
  }

  onBackPress(): boolean | void {
    console.info('[Example09_MainPage] onBackPress')
  }

  onPageHide(): void {
    console.info('[Example09_MainPage] onPageHide')
  }

  aboutToDisappear() {
    console.info('[Example09_MainPage] aboutToDisappear')
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
      Example09_MainPageListItem({ title: 'fetchData' }).onClick(async () => {
        let res = await this.viewModel.fetchData();
        console.info(`[Example09_MainPage] fetchData - res = ${res}`)
      })

      Example09_MainPageListItem({ title: 'getRandomNumber' }).onClick(async () => {
        try {
          let res = this.viewModel.getRandomNumber().catch((error: Object) => {
            console.info(`[Example09_MainPage] getRandomNumber - res - catch error = ${error}`)
          });
          console.info(`[Example09_MainPage] getRandomNumber - res = ${res}`)
        } catch (error) {
          console.info(`[Example09_MainPage] getRandomNumber - res - error = ${error}`)
        }
      })

      Example09_MainPageListItem({ title: 'await to(getRandomNumber())' }).onClick(async () => {
        try {
          let res = await to(this.viewModel.getRandomNumber())
          console.info(`[Example09_MainPage] getRandomNumber - res[0] = ${res[0]}, res[1] = ${res[1]}`)
        } catch (error) {
          console.info(`[Example09_MainPage] getRandomNumber - res - error = ${error}`)
        }
      })

      Example09_MainPageListItem({ title: 'await to(getRandomNumber()) - 2' }).onClick(async () => {
        let res = await to(this.viewModel.getRandomNumber())
        console.info(`[Example09_MainPage] getRandomNumber - res[0] = ${res[0]}, res[1] = ${res[1]}`)
      })

      Example09_MainPageListItem({ title: 'await to(getRandomNumber()) - 3' }).onClick(async () => {
        let result = await to(this.viewModel.getRandomNumber(), {
          'errorExtKey1': 'errorExtValue1', 'errorExtKey2': 'errorExtValue2'
        })
        if (result[0]) {

          // 示例：
          // {
          //   "message": "随机数有点小(0.4523705296048919)",
          //   "stack": "    at anonymous (entry/src/main/ets/examples/example_09_promise/MainPage.ets:43:20)\n",
          //   "topstack": "    at anonymous (entry|entry|1.0.0|src/main/ets/examples/example_09_promise/MainPage.ts:47:32)\n",
          //   "errorExtKey1": "errorExtValue1",
          //   "errorExtKey2": "errorExtValue2"
          // }
          console.info(`[Example09_MainPage] requestParams - res - error = ${json.stringify(result[0])}`)
        } else {
          console.info(`[Example09_MainPage] getRandomNumber - res = ${result[1]}`)
        }
      })

      Example09_MainPageListItem({ title: 'requestParams' }).onClick(async () => {
        try {
          let res = await this.viewModel.requestParams('params ok');
          console.info(`[Example09_MainPage] requestParams - res = ${res}`)
        } catch (error) {
          console.info(`[Example09_MainPage] requestParams - res - error = ${error}`)
        }
      })

      Example09_MainPageListItem({ title: 'xxxPromise' }).onClick(async () => {
        let xxxPromise = new Promise<number>((resolve, reject) => {
          const result: number = Math.random();
          console.info(`[Example09_MainPage] xxxPromise: ${json.stringify({ 'result': result })}`)
          if (result > 0.5) {
            resolve(result);
          } else if (result > 0.3) {
            reject(new Error(`随机数有点小(${result})`));
          } else {
            throw new Error(`随机数太小(${result})`)
          }
        })

        let result = await to(xxxPromise)
        console.info(`[Example09_MainPage] xxxPromise - result = [${result[0]}, ${result[1]}]`)
      })
    }.padding({ left: 10, right: 10 }).layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])

  }
}

@Preview
@Component
struct Example09_MainPageListItem {
  @State title: string | null = null

  build() {
    ListItem() {
      Column() {
        Text(this.title).margin(10)
      }.width("100%").alignItems(HorizontalAlign.Start)
    }
  }
}

