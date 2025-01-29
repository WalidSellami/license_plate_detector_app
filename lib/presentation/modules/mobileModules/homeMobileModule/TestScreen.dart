import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:license_plate_detector/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppCubit.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppStates.dart';
import 'package:license_plate_detector/shared/styles/Colors.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Test',
            ),
          ),
          body: Center(
            child: ConditionalBuilder(
              condition: cubit.imageUploaded != null,
              builder: (context) => Column(
                spacing: 20.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        clipBehavior: Clip.antiAlias,
                        child: Image.file(File((cubit.imageUploaded?.path) ?? ''),
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 300.0,
                          fit: BoxFit.cover,
                          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                            if(frame == null) {
                              return Container(
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  height: 300.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.0,
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Center(child: LoadingIndicator(os: getOs())));
                            }
                            return child;
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 300.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(child: Icon(
                                  Icons.error_outline,
                                  size: 30.0,
                                  color: Colors.white,
                                )));
                          },
                        ),
                      ),
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.grey.shade700,
                          ),
                        ),
                        onPressed: () {
                          cubit.clearData();
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  ConditionalBuilder(
                    condition: state is! LoadingUploadImageToServerAppState,
                    builder: (context) => ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          darkPrimary,
                        ),
                      ),
                      onPressed: () {
                        // cubit.uploadImageToServer(pathUrl: '/upload_image', imagePath: cubit.imageUploaded!.path);
                      },
                      child: Text(
                        'Upload',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    fallback: (context) => Center(child: LoadingIndicator(os: getOs())),
                  ),
                ],
              ),
              fallback: (context) => Center(
                child: Text(
                  'Press on the button to upload image.',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: cubit.imageUploaded == null ? FloatingActionButton(
            onPressed: () {
              cubit.getImage();
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ) : null,
        );
      },
    );
  }
}
