/// Marks the last delivery of a page, used to fetch the page after it.
///
/// Treat it as opaque: get it from a page and pass it back to load the next
/// one. The date and id together give a unique position even when several
/// deliveries share the same date, so the cursor can resume exactly after the
/// last delivery instead of skipping same-date siblings.
class DeliveryPageCursor {
  final DateTime deliveryDate;
  final String deliveryId;

  const DeliveryPageCursor({
    required this.deliveryDate,
    required this.deliveryId,
  });
}
