class AlertModel {

  String? status;
  List<AlertData> alerts = [];

  AlertModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    for(var element in json['alerts']) {
      alerts.add(AlertData.fromJson(element));
    }

  }

}



class AlertData {

  int? id;
  String? status;
  String? vehicleStatus;
  String? plateNumber;
  dynamic dateTime;

  AlertData({this.id, this.status, this.vehicleStatus, this.plateNumber, this.dateTime});

  AlertData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    vehicleStatus = json['vehicle_status'];
    plateNumber = json['plate_number'];
    dateTime = json['date'];
  }



}