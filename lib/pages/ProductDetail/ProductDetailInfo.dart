// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/ProductDetailModel.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ProductDetailInfoPage extends StatefulWidget {
  final ProductDetailModel model;
  const ProductDetailInfoPage({Key? key, required this.model})
      : super(key: key);

  @override
  State<ProductDetailInfoPage> createState() => _ProductDetailInfoPageState();
}

class _ProductDetailInfoPageState extends State<ProductDetailInfoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final uri = Config.domain + "pcontent?id=${widget.model.sId}";
    return Column(
      children: [
        Expanded(
            child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(uri)),
          onProgressChanged: (controller, progress) {
            if (progress / 100 > 0.9999) {}
          },
        ))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
