interface ExamplesPageItemModelInitParams {
  title?: string | null;
  subtitle?: string | null;
  onClick?: (event: ClickEvent) => void;
}

@ObservedV2
export class ExamplesPageItemModel {
  title?: string | null;
  subtitle?: string | null;
  onClick?: (event: ClickEvent) => void;

  constructor(params?: ExamplesPageItemModelInitParams) {
    this.title = params?.title;
    this.subtitle = params?.subtitle;
    this.onClick = params?.onClick;
  }
}