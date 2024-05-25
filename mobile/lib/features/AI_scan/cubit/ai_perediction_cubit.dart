import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/AI_scan/data/models/ai_history_model.dart';
import 'package:mobile/features/AI_scan/data/models/upload_success_model.dart';
import 'package:mobile/features/AI_scan/data/models/perediction_mode.dart';

import '../data/repos/ai_repo.dart';

part 'ai_perediction_state.dart';

class AiPeredictionCubit extends Cubit<AiPeredictionState> {
  AiPeredictionCubit({required this.aiRepo}) : super(AiPeredictionInitial());
  AIRepo aiRepo;

  Future<void> peredictonSkinorNot(File image) async {
    emit(PeredictonSkinOrNotIsloading());
    try {
      Either<String, PeredictionModel> response =
          await aiRepo.peredectionSkinorNot(image);
      emit(response.fold((l) => PeredictonSkinOrNotIsError(error: l),
          (r) => PeredictonSkinOrNotIsSuccess(peredictionModel: r)));
    } catch (error) {
      emit(PeredictonSkinOrNotIsError(error: error.toString()));
    }
  }

  Future<void> peredictonCancerType(File image) async {
    emit(PeredictonSkinOrNotIsloading());
    try {
      Either<String, PeredictionModel> response =
          await aiRepo.peredectionTypeofCancer(image);
      emit(response.fold((l) => PeredictonSkinOrNotIsError(error: l),
          (r) => PeredictionCancerTypeIsSuccess(peredictionModel: r)));
    } catch (error) {
      emit(PeredictonSkinOrNotIsError(error: error.toString()));
    }
  }

  Future<void> uploadAiResult(String userId, String result, File image) async {

    try {
      Either<String, UploadSuccessModel> response =
          await aiRepo.uploadAiDetection(userId, result, image);
      emit(response.fold(
          (l) => UploadAiResultError(l), (r) => UploadAiResultSuccess(r)));
    } catch (error) {
      emit(UploadAiResultError(error.toString()));
    }
  }


  Future<void> getAiHistory(String userId, ) async {
    try {
      Either<String, List<AiHistoryModel>> response =
      await aiRepo.getAiDetection(userId);
      emit(response.fold(
              (l) => GetAiHistoryResultError(l),
              (r) => GetAiHistoryResultSuccess(r)));
    } catch (error) {
      emit(GetAiHistoryResultError(error.toString()));
    }
  }
}
