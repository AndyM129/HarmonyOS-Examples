import { hilogx } from '@andym129/hilogx'
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { JSON } from '@kit.ArkTS'
import json from '@ohos.util.json'
import to from 'await-to-arkts'
import { ExamplesPageItemModel } from 'models'

interface AsyncExamplesPageBodyListItemBuilderParams {
  title?: string
  subtitle?: string | string[]
  onClick?: (event: ClickEvent) => void
}

@ObservedV2
class AsyncExamplesPageModel {
  @Trace await_1_result?: ESObject
  @Trace await_2_result?: ESObject
  @Trace await_3_result?: ESObject
  @Trace await_4_result?: ESObject
  @Trace await_5_result?: ESObject = []
}

@HMRouter({ pageUrl: 'AsyncExamplesPage' })
@ComponentV2
export struct AsyncExamplesPage {
  /** 页面标题 */
  static readonly PAGE_TITLE: string = 'AsyncExamplesPage'
  /** 页面子标题 */
  static readonly PAGE_SUBTITLE: string = '异步编程相关示例'
  pageModel = new AsyncExamplesPageModel()

  /** 静态方法，用于在示例页面中展示 */
  static examplesPageItemModel() {
    return new ExamplesPageItemModel({
      title: AsyncExamplesPage.PAGE_TITLE, subtitle: AsyncExamplesPage.PAGE_SUBTITLE, onClick: () => {
        HMRouterMgr.push({
          pageUrl: 'AsyncExamplesPage', param: {}
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
        Text(AsyncExamplesPage.PAGE_TITLE)
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
        title: 'await', subtitle: ''
      })
      this.pageBodyListItemBuilder({
        title: '① 简单的请求一个异步方法',
        subtitle: `执行结果 = ${json.stringify(this.pageModel.await_1_result)}`,
        onClick: async () => {
          hilogx.debug(`====== 分割线 ======`)

          this.pageModel.await_1_result = await this.deleteXxxFromNetwork()
          hilogx.debug(`执行结果：${JSON.stringify(this.pageModel.await_1_result)}`)
          this.getUIContext().getPromptAction().showToast({ message: '结果已更新' })

          // 执行结果示例：
          // requestResult = {"message":"网络异常"}
          // requestResult = {"status":0,"message":"删除失败"}
          // 执行结果：{"isSuccess":false}
          // requestResult = {"status":0,"message":"删除成功"}
          // 执行结果：{"isSuccess":true}
          // requestResult = {"status":100,"message":"内容不存在"}
          //
          // 总结：
          // 仅当 resolve 时，才会收到返回值
        }
      })
      this.pageBodyListItemBuilder({
        title: '② 简单的请求一个异步方法，并用 try...catch 捕获异常',
        subtitle: `执行结果 = ${json.stringify(this.pageModel.await_2_result)}`,
        onClick: async () => {
          hilogx.debug(`====== 分割线 ======`)

          try {
            this.pageModel.await_2_result = await this.deleteXxxFromNetwork()
            hilogx.debug(`执行结果：${JSON.stringify(this.pageModel.await_2_result)}`)
            this.getUIContext().getPromptAction().showToast({ message: '结果已更新' })
          } catch (error) {
            hilogx.debug(`捕获到异常：${error.toString()}`)
            this.getUIContext().getPromptAction().showToast({ message: '捕获到异常' })
          }

          // 总结：
          // 仅当 resolve 时，才会收到返回值
          // 可用 try...catch 捕获异常
        }
      })
      this.pageBodyListItemBuilder({
        title: '③ 简单的请求一个异步方法，并用 then...catch 捕获异常',
        subtitle: `执行结果 = ${json.stringify(this.pageModel.await_3_result)}`,
        onClick: async () => {
          hilogx.debug(`====== 分割线 ======`)

          let res = await this.deleteXxxFromNetwork().then((result) => {
            this.pageModel.await_3_result = result
            hilogx.debug(`执行结果：${JSON.stringify(result)}`)
            this.getUIContext().getPromptAction().showToast({ message: '结果已更新' })
            return result
          }).catch((error: Error) => {
            hilogx.debug(`捕获到异常：${error.toString()}`)
            this.getUIContext().getPromptAction().showToast({ message: '捕获到异常' })
            return false
          })
          hilogx.debug(`执行结束：${JSON.stringify(res)}`)

          // 总结：
          // 异步方法，可以用 then 继续逻辑，并干预返回结果
          // 同时，可用 catch 捕获异常，并补充返回结果
          //
          // 当 then、catch 都执行结束后，按需走对应的 return 语句，作为 await 的最终结果返回给调用方
        }
      })
      this.pageBodyListItemBuilder({
        title: '④ 简单的请求一个异步方法，并用 catch 处理异常，并返回兜底值',
        subtitle: `执行结果 = ${json.stringify(this.pageModel.await_4_result)}`,
        onClick: async () => {
          hilogx.debug(`====== 分割线 ======`)

          this.pageModel.await_4_result = await this.deleteXxxFromNetwork().catch((error: Error) => {
            hilogx.debug(`捕获到异常：${error}`)
            this.getUIContext().getPromptAction().showToast({ message: '捕获到异常' })
            return false
          })
          hilogx.debug(`执行结果：${JSON.stringify(this.pageModel.await_4_result)}`)
          this.getUIContext().getPromptAction().showToast({ message: '结果已更新' })
        }
      })

      this.pageBodyListItemBuilder({
        title: 'Promise 异步编程', subtitle: '鸿蒙 ArkTS 的基础异步单元是 Promise，和前端 TS/JS 类似'
      })
      this.pageBodyListItemBuilder({
        title: '基本使用：', subtitle: [
          'Promise 中，任何导致无法返回预期结果的情况，都用 reject，如 参数异常、网络异常、执行异常 等；',
          '而 resolve 仅用于返回符合预期的结果',
        ], onClick: async () => {
          hilogx.debug(`====== 分割线 ======`)

          let result = await this.deleteXxxFromNetwork_2().catch((error: Error) => {
            hilogx.debugToast(`捕获到异常：${error} => ${error.stack}`)
            return false
          })
          hilogx.debugToast(`执行结果：${JSON.stringify(result)}`)
        }
      })
      this.pageBodyListItemBuilder({
        title: '进阶使用 - 自定义Error', subtitle: undefined, onClick: async () => {
          hilogx.debug(`====== 分割线 ======`)

          interface CustomError {
            code?: number
            message?: string
            data?: ESObject
          }

          let aPromise = new Promise<boolean>((resolve, reject) => {
            let error: CustomError = {}
            error.code = 100
            error.message = '网络异常'
            error.data = {}
            reject(error)
          })

          let result = await aPromise.catch((error: CustomError) => {
            hilogx.debugToast(`捕获到异常：${JSON.stringify(error)}`)
            return false
          })
          hilogx.debugToast(`执行结果：${JSON.stringify(result)}`)
        }
      })

      this.pageBodyListItemBuilder({
        title: 'Promise 异步编程 - await-to-arkts', subtitle: 'Async await wrapper for easy error handling'
      })
      this.pageBodyListItemBuilder({
        title: '⑤ 基本使用：', // subtitle: `执行结果 = ${json.stringify(this.pageModel.await_5_result, null, 2)}`,
        subtitle: [
          '执行结果：', `result[0] = ${this.pageModel.await_5_result[0] ?? '(undefined)'}`,
          `result[1] = ${this.pageModel.await_5_result[1] ?? '(undefined)'}`
        ], onClick: async () => {
          hilogx.debug(`====== 分割线 ======`)

          this.pageModel.await_5_result = await to(this.deleteXxxFromNetwork_2())
          hilogx.debugToast(`执行结果：${JSON.stringify(this.pageModel.await_5_result[1] ??
          this.pageModel.await_5_result[0].toString())}`)
        }
      })
    }.layoutWeight(1).expandSafeArea([SafeAreaType.SYSTEM])
  }

  @Builder
  pageBodyListItemBuilder(params?: AsyncExamplesPageBodyListItemBuilderParams) {
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
    }.width('100%').padding(10).backgroundColor(params?.onClick ? Color.White : undefined).onClick(params?.onClick)
  }

  // 模拟一个返回 Promise 的异步函数
  async fetchData(): Promise<string> {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        let randomNumber = Math.floor(Math.random() * 100)
        let error: Error | null = null

        if (randomNumber < 10) {
          error = Error('网络请求失败！')
          error = Error('网络请求失败！')
        } else if (randomNumber < 50) {
          error = Error('网络请求失败！')
        } else {
          resolve('网络请求成功！')
        }

        hilogx.debug(`${JSON.stringify({
          'randomNumber': randomNumber, 'error': error
        })}`)
        error ? reject(error) : resolve('网络请求成功！')
      }, 500) // 模拟耗时
    })
  }

  /**
   * 模拟一个返回 Promise 的异步函数
   * @returns Promise<boolean> 成功返回 true，失败返回 false
   */
  async deleteXxxFromNetwork(params?: ESObject): Promise<boolean> {
    interface RequestResult {
      status?: number
      message?: string
    }

    // @formatter:off
    const requestResults: RequestResult[] = [
      {'status': undefined, 'message': '参数异常'},
      {'status': undefined, 'message': '网络异常'},
      {'status': 100, 'message': '内容不存在'},
      {'status': 0, 'message': '删除失败'},
      {'status': 0, 'message': '删除成功'},
    ]
    // @formatter:on

    return new Promise((resolve, reject) => {
      setTimeout(() => { // 模拟各种情况
        let requestResultIndex = Math.floor(Math.random() * requestResults.length)
        let requestResult = requestResults[requestResultIndex]
        hilogx.debug(`requestResult = ${JSON.stringify(requestResult)}`)
        if (requestResult.status != 0) {
          reject(new Error(requestResult.message))
        } else {
          resolve(requestResult.message?.includes('成功') ? true : false)
        }
      }, 500) // 模拟耗时
    })
  }

  async deleteXxxFromNetwork_2(params?: ESObject): Promise<boolean> {
    interface RequestResult {
      status?: number
      message?: string
    }

    // @formatter:off
    const requestResults: RequestResult[] = [
      {'status': undefined, 'message': '参数异常'},
      {'status': undefined, 'message': '网络异常'},
      {'status': 100, 'message': '内容不存在'},
      {'status': 200, 'message': '删除失败'},
      {'status': 0, 'message': '删除成功'},
    ]
    // @formatter:on

    return new Promise((resolve, reject) => {
      setTimeout(() => { // 模拟各种情况
        let requestResultIndex = Math.floor(Math.random() * requestResults.length)
        let requestResult = requestResults[requestResultIndex]
        hilogx.debug(`requestResult = ${JSON.stringify(requestResult)}`)
        if (requestResult.status != 0) {
          reject(new Error(requestResult.message))
        } else {
          resolve(requestResult.message?.includes('成功') ? true : false)
        }
      }, 500) // 模拟耗时
    })
  }
}
