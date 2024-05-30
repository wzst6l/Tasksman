import { CommonConstants } from '../common/constant/CommonConstant';

@Entry
@Component
export struct TaskPrerview {
  @State message: string = 'Hello World';
  @Prop latestUpdate: string = '2024/5/27 12:12:14' // 接收父组件传的最新更新时间
  @Prop total: number = 3
  @Prop @Watch('onFinishChange') finish: number  = 1
  @State level:number = 0
  @State levelMax:number = 3

  // 当finish发生变化时
  onFinishChange(){
    for (let i = 0; i < CommonConstants.LEVEL_MAX.length; i++) {
      if(this.finish < CommonConstants.LEVEL_MAX[i]){
        this.level = i + 1
        this.levelMax = CommonConstants.LEVEL_MAX[i]
        break
      }
    }

  }

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
        Text($r('app.string.target_name'))
          .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
          .fontWeight(FontWeight.Bold)
        Text($r('app.string.target_info'))
          .subTextStyle()
        Column(){
          Row(){
            Row(){
              Text('人生旅者等级L').levelTextStyle()
              Text(this.level.toString()).levelTextStyle()
            }

            Text(this.finish + '/' + this.levelMax).levelTextStyle()
          }.width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({
            bottom: $r('app.float.text_margin')
          })


          Progress({
            value: this.finish,
            total: this.levelMax,
            type: ProgressType.Capsule
          }).width('100%')
            .height(12)
        }.backgroundColor($r('app.color.edit_blue'))
        .borderRadius(10)
        .padding(10)
        .margin({
          top: 5
        })



      }.padding(10)
      .width('70%')
      .alignItems(HorizontalAlign.Start)

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
    .padding({
      left: 20
    })
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

// 二级文字样式复用
@Extend(Text)
function subTextStyle() {
  .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
  .margin({
    top:10
  })

}

@Extend(Text)
function secondTextStyle() {
  .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
  .margin({
    top: $r('app.float.list_margin_top')
  })
}

@Extend(Text)
function levelTextStyle() {
  .fontSize($r('sys.float.ohos_id_text_size_body3'))
  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
  .fontWeight(FontWeight.Bold)
  .fontStyle(FontStyle.Italic)

}