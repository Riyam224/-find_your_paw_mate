import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animals_tasks/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_state.dart';

/// 🏷️ Handles fetching categories for filtering
/// Applies Clean Architecture + SOLID + functional error handling (Either)
class GetCategoriesCubit extends Cubit<GetCategoriesState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  GetCategoriesCubit(this._getCategoriesUseCase) : super(GetCategoriesInitial());

  /// 🏷️ Fetch list of categories
  Future<void> fetchCategories() async {
    emit(GetCategoriesLoading());
    final result = await _getCategoriesUseCase();

    result.fold(
      (failure) => emit(GetCategoriesError(failure.message)),
      (categories) => emit(GetCategoriesLoaded(categories)),
    );
  }
}
