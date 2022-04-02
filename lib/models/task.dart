import 'dart:ui';

import '../shard_alongapp/components_reused/constants.dart';


class Task {
  int? id;
  String? title;
  String? note;
  String? status;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
 // int? state;
  int? remind;
  String? repeat;


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

  Map<String, dynamic> toJson() {
    return {
      columnId: id,
      columnTitle: title,
      columnNote: note,
      columnStatus: status,
      columnDate: date,
      columnStartTime: startTime,
      columnEndTime: endTime,
      columnColor: color,
      columnRemind: remind,
      columnRepeat: repeat,
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json[columnId];
    title = json[columnTitle];
    note = json[columnNote];
    status = json[columnStatus];
    date = json[columnDate];
    startTime = json[columnStartTime];
    endTime = json[columnEndTime];
    color = json[columnColor];
    remind = json[columnRemind];
    repeat = json[columnRepeat];
  }
}
