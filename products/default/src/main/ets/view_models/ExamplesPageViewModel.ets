import { HelloWorldPage } from 'e01_hello_world';
import { HMRouterExampleMainPage } from 'e02_hmrouter';
import { DebugLogExamplePage } from 'e03_debug_log';
import { AsyncExamplesPage } from 'e04_async';
import { TemplatesPage } from 'e98_templates';
import { PlaygroundPage } from 'e99_playground';
import { ExamplesPageItemModel } from 'models/src/main/ets/models/ExamplesPageItemModel';

@ObservedV2
export class ExamplesPageViewModel {
  @Trace pageTitle?: string | null = 'HarmonyOS Examples';
  @Trace itemModels: ExamplesPageItemModel[] = [];

  reloadItemModels() {
    this.itemModels.push(HelloWorldPage.examplesPageItemModel());
    this.itemModels.push(HMRouterExampleMainPage.examplesPageItemModel());
    this.itemModels.push(DebugLogExamplePage.examplesPageItemModel());
    this.itemModels.push(AsyncExamplesPage.examplesPageItemModel());
    this.itemModels.push(TemplatesPage.examplesPageItemModel());
    this.itemModels.push(PlaygroundPage.examplesPageItemModel());
  }
}