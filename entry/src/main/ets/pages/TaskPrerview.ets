import { CommonConstants } from '../common/constant/CommonConstant';

@Entry
@Component
export struct TaskPrerview {
  @State message: string = 'Hello World';
  @Prop latestUpdate: string = '2024/5/27 12:12:14' // 接收父组件传的最新更新时间
  @Prop total: number = 3
  @Prop finish: number = 1

  build() {
    Column() {
      this.Header()
      this.TotalProgress()
    }
    .width(CommonConstants.MAIN_BOARD_WIDTH)
    .backgroundColor(Color.White)
    .borderRadius(CommonConstants.TARGET_BORDER_RADIUS)
  }

  @Builder
  Header() {
    Row() {
      Image($r('app.media.startIcon'))
        .width(90)
        .height(90)
      Column() {
        Text('2024开发任务')
          .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
          .fontWeight(FontWeight.Bold)
        Text('高质量完成交付')
          .subTextStyle()
      }.padding(20)
    }
    .width('100%')
    .padding(20)
  }

  //自定义构建函数
  @Builder
  TotalProgress() {
    Row() {
      Column() {
        Text('总进度')
          .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
          .fontWeight(FontWeight.Bold)
        Row() {
          Text('最近更新')
            .secondTextStyle()

          Text(this.latestUpdate)
            .secondTextStyle()

        }
      }.alignItems(HorizontalAlign.Start)

      Stack() {
        Row() {
          Text(this.finish.toString()).fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
          Text('/' + this.total.toString()).fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
        }

        Progress({
          value: this.finish,
          total: this.total,
          type: ProgressType.Ring
        }).width(50)
      }.padding(20)
    }.width('100%')
    .padding(20)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

// 二级文字样式复用
@Extend(Text)
function subTextStyle() {
  .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
  .fontColor($r('sys.color.ohos_id_color_text_secondary'))

}

@Extend(Text)
function secondTextStyle() {
  .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
  .margin({
    top: $r('app.float.list_margin_top')
  })
}