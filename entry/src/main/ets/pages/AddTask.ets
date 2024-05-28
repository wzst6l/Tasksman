@Entry
@Component @CustomDialog
export struct AddTask {
  @State taskName: string = '';
  ctrl?:CustomDialogController;
  onConfirm?:(value: string) => void;

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
             this.onConfirm(this.taskName)
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