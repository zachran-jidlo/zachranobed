/**
 * Represents a food box.
 * @param {string} foodBoxId - The ID of the food box.
 * @param {string} count - The total count of the food box.
 * @param {string} donorCount - The count of donors for the food box.
 * @param {string} recipientCount - The count of recipients for the food box.
 */
export class FoodBox {
  /**
   * Creates a new instance of the FoodBox class.
   * @param {string} foodBoxId - The ID of the food box.
   * @param {string} count - The total count of the food box.
   * @param {string} donorCount - The count of boxes at donor side.
   * @param {string} recipientCount - The count boxes at recipient side.
   */
  constructor(
    public foodBoxId: string,
    public count: number,
    public donorCount: number,
    public recipientCount: number
  ) {}
}
