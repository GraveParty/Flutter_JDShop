// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../models/ProductDetailModel.dart';

class ProductDetailCommentPage extends StatefulWidget {
  final ProductDetailModel model;
  const ProductDetailCommentPage({Key? key, required this.model})
      : super(key: key);

  @override
  State<ProductDetailCommentPage> createState() =>
      _ProductDetailCommentPageState();
}

class _ProductDetailCommentPageState extends State<ProductDetailCommentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
