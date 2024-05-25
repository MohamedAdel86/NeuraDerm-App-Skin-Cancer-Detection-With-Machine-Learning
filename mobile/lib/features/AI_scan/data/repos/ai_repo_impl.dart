import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mobile/core/error/exception.dart';
import 'package:mobile/core/network/ai_consumer.dart';
import 'package:mobile/core/network/api_constant.dart';
import 'package:mobile/core/network/api_consumer.dart';
import 'package:mobile/features/AI_scan/data/models/ai_history_model.dart';
import 'package:mobile/features/AI_scan/data/models/upload_success_model.dart';
import 'package:mobile/features/AI_scan/data/models/perediction_mode.dart';

import 'ai_repo.dart';

class AIRepoImpl implements AIRepo {
  final ApiConsumer apiConsumer;

  AIRepoImpl({required this.apiConsumer});

  @override
  Future<Either<String, PeredictionModel>> peredectionSkinorNot(
      File image) async {
    try {
      final response = await DioHelper.postData(
          url: ApiConstant.skinornotModel,
          isFormData: true,
          data: {"image": await convertImageToBinary(image)});
      final predict = PeredictionModel.fromJson(response.data);
      return Right(predict);
    } on DioException catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, PeredictionModel>> peredectionTypeofCancer(
      File image) async {
    try {
      final response = await DioHelper.postData(
          url: ApiConstant.detectModel,
          isFormData: true,
          data: {"image": await convertImageToBinary(image)});
      final predict = PeredictionModel.fromJson(response.data);
      return Right(predict);
    } on DioException catch (error) {
      return Left(error.toString());
    }
  }

  Future convertImageToBinary(File image) async {
    List<int> imageBytes = await image.readAsBytes();
    return MultipartFile.fromBytes(imageBytes,
        filename: image.path
            .split('/')
            .last);
  }

  @override
  Future<Either<String, UploadSuccessModel>> uploadAiDetection(String userId,
      String result, File image) async {
    try {
      final response = await apiConsumer.post(
        ApiConstant.uploadAiResult,
        formDataIsEnabled: true,

        body: {
          'UserId': userId,
          'Result': result,
          'Image': await convertImageToBinary(image),
        },
      );
      final output = UploadSuccessModel.fromJson(response);
      return Right(output);
    } on ServerException catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, List<AiHistoryModel>>> getAiDetection(
      String userId) async {
    try {
      final response = await apiConsumer.get(ApiConstant.getAiResult,
          queryParameters: {'userID': userId,
          }
      );
      List <AiHistoryModel>aiList=(response as List).map((e) => AiHistoryModel.fromJson(e)).toList();
      return Right(aiList);

    }
    on ServerException catch (err) {
      return Left(err.toString());
    }
    }
  }
