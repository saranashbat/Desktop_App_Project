enum OrderStatus {
  PROCESSING,
  SHIPPED,
  DELIVERED,
  CANCELED,
}

// Helper functions to convert from/to JSON
OrderStatus orderStatusFromString(String status) {
  switch (status) {
    case 'PROCESSING':
      return OrderStatus.PROCESSING;
    case 'SHIPPED':
      return OrderStatus.SHIPPED;
    case 'DELIVERED':
      return OrderStatus.DELIVERED;
    case 'CANCELED':
      return OrderStatus.CANCELED;
    default:
      throw Exception('Unknown OrderStatus: $status');
  }
}

String orderStatusToString(OrderStatus status) {
  return status.toString().split('.').last;
}

