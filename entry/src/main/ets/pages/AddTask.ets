import { CommonConstants } from '../common/constant/CommonConstant';
@Entry
@Component @CustomDialog
export struct AddTask {
  @State taskName: string = '';
  ctrl?:CustomDialogController;
  onConfirm?:(value: string, typeIndex?: number) => void;

  types:string[] = ['健康', '职业技能' , '业余爱好', '沟通表达']
  @State selectedIndex:number = -1

  build() {
    Column({space: 10}) {
      Text('添加任务')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
      TextInput({placeholder: '请输入任务名称'})
        .onChange((value:string) =>{
          this.taskName = value
        })
      // 选标签
      Flex({
        alignContent: FlexAlign.SpaceAround
      }){
        ForEach(CommonConstants.TASK_TYPES, (item: string, index) =>{
          Text(item)
            .labelTextStyle(this.selectedIndex == index ? $r('app.color.main_blue') : $r('app.color.main_gray'))
            .onClick(e =>{
              console.log('点击标签', CommonConstants.TASK_TYPES[index])
               this.selectedIndex =  index
            })

        })
      }
      .width('100%')

      Row(){
        Button('取消')
          .onClick(() =>{
            this.ctrl?.close()
          })
        Blank()
        Button('保存')
          .onClick(() =>{
           if(this.onConfirm){
             console.log('CustomDialog 保存任务:' , this.taskName)
             this.onConfirm(this.taskName, this.selectedIndex)
           }
          })
      }
      .padding(20)
      .width('100%')
      .height('10%')
    }
    .width('90%')
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(15)
  }
}
@Extend(Text)
function labelTextStyle(color: Resource){
  .fontSize($r('app.float.text_font'))
  .fontColor(color)
  .borderColor(color)
  .borderWidth(1)
  .borderRadius(10)
  .padding($r('app.float.text_margin'))
  .margin({
    left: 5,
    right: 5
  })



}