class DataModel {

  String? status;
  List<LicensePlateData> licensePlates = [];

  DataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    for(var element in json['license_plates']) {
      licensePlates.add(LicensePlateData.fromJson(element));
    }
  }
}


class LicensePlateData {
  int? id;
  String? plateNumber;
  String? image;
  dynamic dateTime;

  LicensePlateData({this.id, this.image, this.plateNumber, this.dateTime});

  LicensePlateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plateNumber = json['plate_number'];
    image = json['image'];
    dateTime = json['date'];
  }
}
