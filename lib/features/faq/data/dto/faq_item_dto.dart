import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the faq_item_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'faq_item_dto.g.dart';

@JsonSerializable()
class FaqItemDto {
  final String question;
  final String answer;
  final int order;
  final String? categoryId;

  FaqItemDto({
    required this.question,
    required this.answer,
    required this.order,
    this.categoryId,
  });

  factory FaqItemDto.fromJson(Map<String, dynamic> json) => _$FaqItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FaqItemDtoToJson(this);
}
