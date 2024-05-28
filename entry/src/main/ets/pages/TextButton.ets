@Entry
@Component
export struct TextButton {
  @State bgColor: Resource = $r('sys.color.ohos_id_color_button_normal')
  title: ResourceStr = '标题' // 标题确定后不变，所以用普通类型

  build() {
   Text(this.title).backgroundColor(this.bgColor)
     .borderRadius(10)
     .fontSize($r('sys.float.ohos_id_text_size_button1'))
     .fontColor($r('sys.color.ohos_id_text_color_active'))
     .width(96)
     .textAlign(TextAlign.Center)
     .onTouch((e) =>{
       if(e.type == TouchType.Down){
         this.bgColor = $r('sys.color.ohos_id_picker_press_color')
       }else if(e.type == TouchType.Up){
         this.bgColor = $r('sys.color.ohos_id_color_button_normal')
       }
     }).padding(5)
  }
}