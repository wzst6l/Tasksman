import {TextButton} from './TextButton'
@Entry
@Component
export struct ProgressEdit {

  @Prop progress:number = 10  // 进度值，百分比
  @State mode: number = 1 // 滑动模式
  onCancel?:() => void
  onConfirm?:(progress:number) => void

  build() {
    Column(){
      Row() {
        Slider({
          value: this.progress,
          step: 1,
          style: SliderStyle.InSet
        })
          .width('80%')
          .onChange((value, mode) =>{
            this.progress = Math.trunc(value)
            this.mode = mode
          })
        Text(this.progress + '%')
          .fontSize($r('sys.float.ohos_id_text_size_button1'))
          .fontColor($r('sys.color.ohos_id_text_color_active'))

      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      Row(){
        TextButton({title: '取消'})
          .onClick(()=>{
            if(this.onCancel){
              this.onCancel()
            }
          })
        Blank()
        TextButton({title: '确定'})
          .onClick(()=>{
            if(this.onConfirm){
              this.onConfirm(this.progress)
            }
        })
      }
      .width('70%')
      .padding(10)
    }

  }
}