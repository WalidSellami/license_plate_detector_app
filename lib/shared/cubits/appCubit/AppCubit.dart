import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:license_plate_detector/data/models/alertModel/AlertModel.dart';
import 'package:license_plate_detector/data/models/dataModel/DataModel.dart';
import 'package:license_plate_detector/data/models/profileModel/ProfileModel.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppStates.dart';
import 'package:license_plate_detector/shared/network/remot/DioHelper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);


  bool isSearch = false;

  void activateSearch() {
    isSearch = !isSearch;
    emit(ActivateSearchAppState());
  }

  bool isProcessing = false;

  void updateProcessState(bool processState) {

    isProcessing = processState;
    emit(UpdateProcessAppState());

  }


  ProfileModel? profileModel;

  void getDataProfile() async {

    emit(LoadingGetDataProfileAppState());

    await DioHelper.getData(pathUrl: '/profile/$userId').then((value) {

      if(kDebugMode) {
        print(value?.data);
      }

      if(value?.data['user_id'] == userId) {
        profileModel = ProfileModel.fromJson(value?.data);
      }

      emit(SuccessGetDataProfileAppState());
    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} in get data profile');
      }

      emit(ErrorGetDataProfileAppState(error));
    });

  }


  DataModel? dataModel;

  void getLicensePlates() async {

    emit(LoadingGetLicensePlatesAppState());

    await DioHelper.getData(pathUrl: '/license_plates').then((value) {

      if(value?.data != null) {
        dataModel = DataModel.fromJson(value?.data);
      }

      emit(SuccessGetLicensePlatesAppState());
    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in get license plates');
      }

      emit(ErrorGetLicensePlatesAppState(error));
    });


  }


  void addLicensePlate({
    required String imageUrl,
    required String pltNumber
}) async {

    Map<String, dynamic> data = {
      'image': imageUrl,
      'plate_number': pltNumber
    };

    await DioHelper.postData(
        pathUrl: '/add_license_plate',
        data: data).then((value) {

          emit(SuccessAddLicensePlateAppState());

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in add license plate');
      }

      emit(ErrorAddLicensePlateAppState(error));
    });


  }

  void editLicensePlate({
    required dynamic plateId,
    required String imageUrl,
    required String pltNumber
  }) async {

    emit(LoadingEditLicensePlateAppState());

    Map<String, dynamic> data = {
      'image': imageUrl,
      'plate_number': pltNumber
    };

    await DioHelper.putData(
        pathUrl: '/edit_license_plate/$plateId',
        data: data).then((value) {

      emit(SuccessEditLicensePlateAppState());

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in edit license plate');
      }

      emit(ErrorEditLicensePlateAppState(error));
    });

  }


  void removeLicensePlate({
    required dynamic plateId,
}) async {

    emit(LoadingRemoveLicensePlateAppState());

    await DioHelper.deleteData(pathUrl: '/delete_license_plate/$plateId').then((value) {

      getLicensePlates();
    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in remove license plate');
      }

      emit(ErrorRemoveLicensePlateAppState(error));
    });

  }


  void searchLicensePlate({
    required String pltNumber,
}) async {

    emit(LoadingSearchLicensePlateAppState());

    await DioHelper.postData(
        pathUrl: '/search_license_plate',
        data: {
          'plate_number': pltNumber,
        },
    ).then((value) {

      if(value?.data != null) {
        dataModel = DataModel.fromJson(value?.data);
      }

      emit(SuccessSearchLicensePlateAppState());
    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in search license plate');
      }

      emit(ErrorSearchLicensePlateAppState(error));
    });

  }
  
  
  void addNewAdmin({
    required String name,
    required String email,
    required String password,
}) async {
    
    emit(LoadingAddNewAdminAppState());
    
    await DioHelper.postData(
        pathUrl: '/register',
        data: {
          'name': name,
          'email': email,
          'password': password
        }).then((value) {
          
          emit(SuccessAddNewAdminAppState());
    }).catchError((error) {
      
      if(kDebugMode) {
        print('${error.toString()} in add new admin');
      }
      
      emit(ErrorAddNewAdminAppState(error));
    });
    
  }



  XFile? imageUploaded;

  var picker = ImagePicker();

  Future<void> getImage() async {

    try {

      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if(pickedFile != null) {
        imageUploaded = XFile(pickedFile.path);
      }

      emit(SuccessGetImageAppState());

    } catch(e) {

      if (kDebugMode) {
        print(e.toString());
      }

      emit(ErrorGetImageAppState(e));

    }
  }


  void clearData() {
    imageUploaded = null;
    emit(ClearDataAppState());
  }



  String imgUploadUrl = '';

  void uploadWebImageAndDataToServer({
    required String pathUrl,
    required XFile image,
    required String pltNumber,
    bool isEdited = false,
    dynamic plateId,
  }) async {

    emit(LoadingUploadImageToServerAppState());

    List<int> bytes = await image.readAsBytes();

    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: image.path.split('/').last)
    });

    await DioHelper.postData(
        pathUrl: '/upload_image',
        data: formData).then((value) {

          if (kDebugMode) {
          print(value?.data);
        }

        imgUploadUrl = value?.data['image_url'];

        if(!isEdited) {
          addLicensePlate(imageUrl: imgUploadUrl, pltNumber: pltNumber);
        } else {
          editLicensePlate(plateId: plateId, imageUrl: imgUploadUrl, pltNumber: pltNumber);
        }

      }).catchError((error) {

        if (kDebugMode) {
          print(error.toString());
        }

        emit(ErrorUploadImageToServerAppState(error));
      });

  }


  void addAlert({
    required String status,
    required String plateNumber,
}) {

    emit(LoadingAddAlertAppState());

    DioHelper.postData(
        pathUrl: '/add_alert',
        data: {
          'status': status,
          'plate_number': plateNumber
        }).then((value) {

          getAlerts();

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in add alert');
      }
      
      emit(ErrorAddAlertAppState(error));

    });


  }

  
  AlertModel? alertModel;
  int numberOfAlerts = 0;
  
  void getAlerts({
    bool isRead = false,
}) {

    if(!isRead) {
      emit(LoadingGetAlertsAppState());
    }

    DioHelper.getData(pathUrl: '/alerts').then((value) {

      numberOfAlerts = 0;

      if(value?.data != null) {
        alertModel = AlertModel.fromJson(value?.data);
        for(var alert in alertModel!.alerts) {
          if(alert.status == 'Unread') {
            numberOfAlerts++;
          }
        }

        if(isRead) {
          Future.delayed(Duration(milliseconds: 1500)).then((value) {
            changeStatusAlerts();
          });
        }
      }

      emit(SuccessGetAlertsAppState());

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in get alerts');
      }

      emit(ErrorGetAlertsAppState(error));

    });

  }


  void changeStatusAlerts() {

    emit(LoadingChangeStatusAlertsAppState());

    DioHelper.putData(
        pathUrl: '/edit_alerts',
    ).then((value) {

      numberOfAlerts = 0;

      emit(SuccessChangeStatusAlertsAppState());

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in change status alerts');
      }

       emit(ErrorChangeStatusAlertsAppState(error));
    });

  }
  
  
  void removeAlert({
    required dynamic alertId
}) {
    
    emit(LoadingRemoveAlertAppState());
    
    DioHelper.deleteData(pathUrl: '/delete_alert/$alertId').then((value) {

      emit(SuccessRemoveAlertAppState());

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in remove alert');
      }

      emit(ErrorRemoveAlertAppState(error));
    });

  }


  void removeAllAlerts() {

    emit(LoadingRemoveAllAlertsAppState());

    DioHelper.deleteData(pathUrl: '/delete_all_alerts').then((value) {

      emit(SuccessRemoveAllAlertsAppState());

    }).catchError((error) {

      if (kDebugMode) {
        print('${error.toString()} --> in remove all alert');
      }

      emit(ErrorRemoveAllAlertsAppState(error));
    });

  }




  List<Map<String, dynamic>> detections = [];

  // Mobile
  void uploadImageAndGetDetectionsResult({
    required String imagePath,
}) async {

    emit(LoadingUploadImageAndGetDetectionsResultAppState());

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last)
    });

    await DioHelper.postData(
        pathUrl: '/detect_license_plate',
        data: formData).then((value) {

        if (kDebugMode) {
          print(value?.data);
        }

        detections = List<Map<String, dynamic>>.from(value?.data['detections']);

        emit(SuccessUploadImageAndGetDetectionsResultAppState());

        }).catchError((error) {

        if (kDebugMode) {
          print(error.toString());
        }

        emit(ErrorUploadImageAndGetDetectionsResultAppState(error));
      });

    }

  void clearDetectionResult() {
    detections.clear();
    isProcessing = false;
    emit(ClearDataAppState());
  }


  // Web Notifications
  Map<String, dynamic> notificationData = {};

  void getNotification(context) async {

    if(kIsWeb) {

      final wsUrl = Uri.parse('ws://$ipAddress:8000/ws/notifications');
      final channel = WebSocketChannel.connect(wsUrl);

      await channel.ready;

      channel.stream.listen((message) async {

        if(notificationData.isEmpty) {

          if (kDebugMode) {
            print(message.runtimeType);
          }

          notificationData = jsonDecode(message);

          if (kDebugMode) {
            print(notificationData);
          }

          if(notificationData['title'] == 'Unauthorized') {
            getAlerts();
          }

          emit(SuccessGetNotificationAppState(notificationData['title'], notificationData['message']));

          await Future.delayed(Duration(seconds: 1)).then((v) {
            notificationData.clear();
          });

        } 

      });
    }
  }

}