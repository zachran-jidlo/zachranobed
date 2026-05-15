import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the faq_category_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'faq_category_dto.g.dart';

@JsonSerializable()
class FaqCategoryDto {
  final String title;
  final String description;
  final int order;

  FaqCategoryDto({
    required this.title,
    required this.description,
    required this.order,
  });

  factory FaqCategoryDto.fromJson(Map<String, dynamic> json) => _$FaqCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FaqCategoryDtoToJson(this);
}
