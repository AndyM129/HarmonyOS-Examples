import { HelloWorldPage } from 'e01_hello_world';
import { HMRouterExampleMainPage } from 'e02_hmrouter';
import { ExamplesPageItemModel } from 'models/src/main/ets/models/ExamplesPageItemModel';

@ObservedV2
export class ExamplesPageViewModel {
  @Trace pageTitle?: string | null = 'HarmonyOS Examples';
  @Trace itemModels: ExamplesPageItemModel[] = [];

  reloadItemModels() {
    this.itemModels.push(HelloWorldPage.examplesPageItemModel());
    this.itemModels.push(HMRouterExampleMainPage.examplesPageItemModel());
  }
}