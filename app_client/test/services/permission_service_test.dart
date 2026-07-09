import 'package:flutter_test/flutter_test.dart';
import 'package:mova/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  test('canReadPhotos returns true when permission handler grants access', () async {
    final service = PermissionService(
      requestPhotoPermission: () async => PermissionStatus.granted,
    );

    final result = await service.canReadPhotos();

    expect(result, isTrue);
  });

  test('canReadPhotos falls back to photo manager limited access', () async {
    final service = PermissionService(
      requestPhotoPermission: () async => PermissionStatus.denied,
      requestLibraryAccess: () async => PermissionState.limited,
    );

    final result = await service.canReadPhotos();

    expect(result, isTrue);
  });

  test('canReadPhotos returns false when both permission checks deny access', () async {
    final service = PermissionService(
      requestPhotoPermission: () async => PermissionStatus.permanentlyDenied,
      requestLibraryAccess: () async => PermissionState.denied,
    );

    final result = await service.canReadPhotos();

    expect(result, isFalse);
  });
}
