import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/types/product_as_type.dart';
import 'package:spooky/providers/in_app_purchase_provider.dart';

class SpAddOnVisibility extends StatelessWidget {
  const SpAddOnVisibility({
    Key? key,
    required this.child,
    required this.type,
    this.reverse = false,
  }) : super(key: key);

  final Widget child;
  final ProductAsType type;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    InAppPurchaseProvider provider = Provider.of<InAppPurchaseProvider>(context);
    return Visibility(
      visible: provider.purchased(type) != reverse,
      child: child,
    );
  }
}
