import { HMRouterMgr } from '@hadss/hmrouter';
import { ExamplesPageItemModel } from '../models/ExamplesPageItemModel';

@ObservedV2
export class ExamplesPageViewModel {
  @Trace pageTitle?: string | null = 'ExamplesPage';
  @Trace itemModels: ExamplesPageItemModel[] = [];

  reloadItemModels() {
    this.itemModels.push(new ExamplesPageItemModel({
      title: 'HMRouterExampleMainPage', subtitle: 'This is an HMRouter example', onClick: () => {
        HMRouterMgr.push({
          pageUrl: 'HMRouterExampleMainPage?msg=abcdef', param: { msg: '111' }
        });
      }
    }));

  }
}