import 'package:animals_tasks/features/home/domain/entities/category_entity.dart';

sealed class GetCategoriesState {}

final class GetCategoriesInitial extends GetCategoriesState {}

final class GetCategoriesLoading extends GetCategoriesState {}

final class GetCategoriesLoaded extends GetCategoriesState {
  final List<CategoryEntity> categories;
  GetCategoriesLoaded(this.categories);
}

final class GetCategoriesError extends GetCategoriesState {
  final String message;
  GetCategoriesError(this.message);
}
