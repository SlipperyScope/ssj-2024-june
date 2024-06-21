class_name Radio extends Device

signal dataSent(data:Dictionary)

func SendData(data:Dictionary): dataSent.emit(data)
