import 'package:animals_tasks/features/details/domain/usecases/get_dog_details_usecase.dart';
import 'package:animals_tasks/features/details/presentation/cubit/get_dog_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetDogDetailsCubit extends Cubit<GetDogDetailsState> {
  final GetDogDetailsUseCase getDogDetailsUseCase;

  GetDogDetailsCubit(this.getDogDetailsUseCase) : super(GetDogDetailsInitial());

  Future<void> fetchDogDetails(String dogId) async {
    emit(GetDogDetailsLoading());

    final result = await getDogDetailsUseCase(dogId);

    result.fold(
      (failure) => emit(GetDogDetailsError(failure.message)),
      (dog) => emit(GetDogDetailsLoaded(dog)),
    );
  }
}
