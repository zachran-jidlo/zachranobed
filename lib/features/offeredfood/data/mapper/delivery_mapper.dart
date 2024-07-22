import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/models/dto/delivery_dto.dart';

/// DTO to domain mapper for [Delivery].
extension DeliveryMapper on DeliveryDto {
  /// Maps DTOs to domain representation.
  Delivery? toDomain() {
    final deliveryState = state?.toDomain();
    if (deliveryState == null) {
      return null;
    }

    final deliveryType = type?.toDomain();
    if (deliveryType == null) {
      return null;
    }

    return Delivery(
      id: id,
      donorId: donorId,
      recipientId: recipientId,
      state: deliveryState,
      type: deliveryType,
      carrierType: _carrierType(),
    );
  }

  CarrierType _carrierType() {
    switch (carrierId) {
      case "personal":
        return CarrierType.personal;
      default:
        return CarrierType.other;
    }
  }
}

/// DTO to domain mapper for [DeliveryState].
extension DeliveryStateMapper on DeliveryStateDto {
  /// Maps DTOs to domain representation.
  DeliveryState toDomain() {
    switch (this) {
      case DeliveryStateDto.prepared:
        return DeliveryState.prepared;
      case DeliveryStateDto.offered:
        return DeliveryState.offered;
      case DeliveryStateDto.accepted:
        return DeliveryState.accepted;
      case DeliveryStateDto.inDelivery:
        return DeliveryState.inDelivery;
      case DeliveryStateDto.delivered:
        return DeliveryState.delivered;
      case DeliveryStateDto.notUsed:
        return DeliveryState.notUsed;
    }
  }
}

/// Domain to DTO mapper for [DeliveryStateDto].
extension DeliveryStateDtoMapper on DeliveryState {
  /// Maps domain representation to DTOs.
  DeliveryStateDto toDto() {
    switch (this) {
      case DeliveryState.prepared:
        return DeliveryStateDto.prepared;
      case DeliveryState.offered:
        return DeliveryStateDto.offered;
      case DeliveryState.accepted:
        return DeliveryStateDto.accepted;
      case DeliveryState.inDelivery:
        return DeliveryStateDto.inDelivery;
      case DeliveryState.delivered:
        return DeliveryStateDto.delivered;
      case DeliveryState.notUsed:
        return DeliveryStateDto.notUsed;
    }
  }
}

/// DTO to domain mapper for [DeliveryType].
extension DeliveryTypeMapper on DeliveryTypeDto {
  /// Maps DTOs to domain representation.
  DeliveryType toDomain() {
    switch (this) {
      case DeliveryTypeDto.foodDelivery:
        return DeliveryType.foodDelivery;
      case DeliveryTypeDto.boxDelivery:
        return DeliveryType.boxDelivery;
    }
  }
}
