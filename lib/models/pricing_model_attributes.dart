class PricingAttribute {
  String? attrTextId;
  String? attrName;
  String? price;
  String? estTime;

  @override
  String toString() {
    return 'PricingAttribute{attrTextId: $attrTextId, attrName: $attrName, price: $price, estTime: $estTime}';
  }

  PricingAttribute({
    this.attrTextId,
    this.attrName,
    this.price,
    this.estTime,
  });
}
