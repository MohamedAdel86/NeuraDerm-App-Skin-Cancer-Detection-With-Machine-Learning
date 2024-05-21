import 'package:dartz/dartz.dart';
import 'package:mobile/core/error/exception.dart';
import 'package:mobile/core/network/api_constant.dart';
import 'package:mobile/core/network/api_consumer.dart';
import 'package:mobile/features/clinic/data/model/add_clinic_success_model.dart';
import 'package:mobile/features/clinic/data/model/clinic_model.dart';
import 'package:mobile/features/clinic/data/model/update_model.dart';
import 'package:mobile/features/clinic/data/repo/clinic_repo.dart';

class ClinicRepoImpl implements ClinicRepo {
  final ApiConsumer apiConsumer;

  ClinicRepoImpl({required this.apiConsumer});

  @override
  Future<Either<String, AddClinicSuccessModel>> createClinic(
      ClinicModel clinicModel, String token) async {
    try {
      final response = await apiConsumer.post(ApiConstant.createClinicEndPoint,
          body: clinicModel.toJson(), token: token);
      var clinicSuccessModel = AddClinicSuccessModel.fromJson(response);
      return Right(clinicSuccessModel);
    } on ServerException catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ClinicModel>> getDocClinic(
      {required String name}) async {
    try {
      final response = await apiConsumer.get(
          ApiConstant.getClinicByNameEndPoint,
          queryParameters: {'name': name});
      var clinicModel = ClinicModel.fromJson(response);
      return Right(clinicModel);
    } on ServerException catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, AddClinicSuccessModel>> deleteClinic(
      {required int id, required String token}) async {
    try {
      final reponse = await apiConsumer.delete(ApiConstant.deleteClinicEndPoint,
          queryParameters: {"id": id}, token: token);
      final successDeleted = AddClinicSuccessModel.fromJson(reponse);
      return Right(successDeleted);
    } on ServerException catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, AddClinicSuccessModel>> getDocHasClinic({
    required String docId,
  }) async {
    try {
      final response = await apiConsumer.get(
          ApiConstant.getDoctorHasClinicEndPoint,
          queryParameters: {"doctorId": docId});
      var addClinicSuccessModel = AddClinicSuccessModel.fromJson(response);
      return Right(addClinicSuccessModel);
    } on ServerException catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, AddClinicSuccessModel>> updateClinic(
    UpdateClinicModel updateClinicModel,
    String token,
  ) async {
    try {
      final respone = await apiConsumer.put(
        ApiConstant.updateClinic,
        token: token,
        body: updateClinicModel.toJson(),
      );
      var result = AddClinicSuccessModel.fromJson(respone);
      return Right(result);
    } on ServerException catch (error) {
      return Left(error.toString());
    }
  }
}
