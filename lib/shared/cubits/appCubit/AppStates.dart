abstract class AppStates {}

class InitialAppState extends AppStates {}

class ActivateSearchAppState extends AppStates {}

class UpdateProcessAppState extends AppStates {}

// Get Data Profile
class LoadingGetDataProfileAppState extends AppStates {}

class SuccessGetDataProfileAppState extends AppStates {}

class ErrorGetDataProfileAppState extends AppStates {

  dynamic error;
  ErrorGetDataProfileAppState(this.error);
}

// Upload Image
class LoadingUploadImageToServerAppState extends AppStates {}

class SuccessUploadImageToServerAppState extends AppStates {}

class ErrorUploadImageToServerAppState extends AppStates {

  dynamic error;
  ErrorUploadImageToServerAppState(this.error);
}


// Upload Image And Get Detections Result
class LoadingUploadImageAndGetDetectionsResultAppState extends AppStates {}

class SuccessUploadImageAndGetDetectionsResultAppState extends AppStates {}

class ErrorUploadImageAndGetDetectionsResultAppState extends AppStates {

  dynamic error;
  ErrorUploadImageAndGetDetectionsResultAppState(this.error);
}


// Get Image Device
class SuccessGetImageAppState extends AppStates {}

class ErrorGetImageAppState extends AppStates {

  dynamic error;
  ErrorGetImageAppState(this.error);

}

class ClearDataAppState extends AppStates {}


// Get License Plates
class LoadingGetLicensePlatesAppState extends AppStates {}

class SuccessGetLicensePlatesAppState extends AppStates {}

class ErrorGetLicensePlatesAppState extends AppStates {

  dynamic error;
  ErrorGetLicensePlatesAppState(this.error);

}

// Add License Plates
class LoadingAddLicensePlateAppState extends AppStates {}

class SuccessAddLicensePlateAppState extends AppStates {}

class ErrorAddLicensePlateAppState extends AppStates {

  dynamic error;
  ErrorAddLicensePlateAppState(this.error);

}


// Edit License Plate
class LoadingEditLicensePlateAppState extends AppStates {}

class SuccessEditLicensePlateAppState extends AppStates {}

class ErrorEditLicensePlateAppState extends AppStates {

  dynamic error;
  ErrorEditLicensePlateAppState(this.error);

}

// Remove License Plate
class LoadingRemoveLicensePlateAppState extends AppStates {}

class SuccessRemoveLicensePlateAppState extends AppStates {}

class ErrorRemoveLicensePlateAppState extends AppStates {

  dynamic error;
  ErrorRemoveLicensePlateAppState(this.error);

}

// Search License Plate
class LoadingSearchLicensePlateAppState extends AppStates {}

class SuccessSearchLicensePlateAppState extends AppStates {}

class ErrorSearchLicensePlateAppState extends AppStates {

  dynamic error;
  ErrorSearchLicensePlateAppState(this.error);

}


// Add New Admin
class LoadingAddNewAdminAppState extends AppStates {}

class SuccessAddNewAdminAppState extends AppStates {}

class ErrorAddNewAdminAppState extends AppStates {

  dynamic error;
  ErrorAddNewAdminAppState(this.error);

}


// Add Alert
class LoadingAddAlertAppState extends AppStates {}

class SuccessAddAlertAppState extends AppStates {}

class ErrorAddAlertAppState extends AppStates {

  dynamic error;
  ErrorAddAlertAppState(this.error);

}


// Get Alerts
class LoadingGetAlertsAppState extends AppStates {}

class SuccessGetAlertsAppState extends AppStates {}

class ErrorGetAlertsAppState extends AppStates {

  dynamic error;
  ErrorGetAlertsAppState(this.error);

}


// Change Status Alerts
class LoadingChangeStatusAlertsAppState extends AppStates {}

class SuccessChangeStatusAlertsAppState extends AppStates {}

class ErrorChangeStatusAlertsAppState extends AppStates {

  dynamic error;
  ErrorChangeStatusAlertsAppState(this.error);

}

// Remove Alert
class LoadingRemoveAlertAppState extends AppStates {}

class SuccessRemoveAlertAppState extends AppStates {}

class ErrorRemoveAlertAppState extends AppStates {

  dynamic error;
  ErrorRemoveAlertAppState(this.error);

}


// Remove All Alerts
class LoadingRemoveAllAlertsAppState extends AppStates {}

class SuccessRemoveAllAlertsAppState extends AppStates {}

class ErrorRemoveAllAlertsAppState extends AppStates {

  dynamic error;
  ErrorRemoveAllAlertsAppState(this.error);

}


// Get Notification
class SuccessGetNotificationAppState extends AppStates {

  final dynamic title;
  final dynamic message;
  SuccessGetNotificationAppState(this.title, this.message);


}

