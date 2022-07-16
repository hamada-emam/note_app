
import 'package:noteapp/ui/components/managers/conestants_manager.dart';




class Task {
  int? id;
  String? title;
  String? note;
  String? status;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

// constructor to initial fields 
  Task({
    this.id,
    this.title,
    this.note,
    this.status,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,

  });
// encoding data 
  Map<String, dynamic> toJson() {
    return {
      DBNamesConstants.columnId: id,
      DBNamesConstants.columnTitle: title,
      DBNamesConstants.columnNote: note,
      DBNamesConstants.columnStatus: status,
      DBNamesConstants.columnDate: date,
      DBNamesConstants.columnStartTime: startTime,
      DBNamesConstants.columnEndTime: endTime,
      DBNamesConstants.columnColor: color,
      DBNamesConstants.columnRemind: remind,
      DBNamesConstants.columnRepeat: repeat,
    };
  }
// decoding data 
  Task.fromJson(Map<String, dynamic> json) {
    id = json[DBNamesConstants.columnId];
    title = json[DBNamesConstants.columnTitle];
    note = json[DBNamesConstants.columnNote];
    status = json[DBNamesConstants.columnStatus];
    date = json[DBNamesConstants.columnDate];
    startTime = json[DBNamesConstants.columnStartTime];
    endTime = json[DBNamesConstants.columnEndTime];
    color = json[DBNamesConstants.columnColor];
    remind = json[DBNamesConstants.columnRemind];
    repeat = json[DBNamesConstants.columnRepeat];
  }
}
