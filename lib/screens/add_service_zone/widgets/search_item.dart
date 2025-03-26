import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/service_search_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:provider/provider.dart';
import 'network_image_placeholder.dart';

class SearchServiceItem extends StatefulWidget {
  final ServiceSearchModel searchModel;

  SearchServiceItem(this.searchModel);

  @override
  State<SearchServiceItem> createState() => _SearchServiceItemState();
}

class _SearchServiceItemState extends State<SearchServiceItem> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewServiceProvider>(
      builder: (context, pro, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //pro.searchSelectedServiceList.any((e)=>e.serviceTextId==widget.searchModel.serviceTextId)
              Checkbox(
                value: pro.searchSelectedServiceList
                    .any((e) => e == widget.searchModel),
                checkColor: Colors.white,
                activeColor: myColors.green,
                onChanged: (val) {
                  var ap = context.read<AddNewServiceProvider>();
                  ap.updateSelectedService(widget.searchModel);
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    var ap = context.read<AddNewServiceProvider>();
                    ap.updateSelectedService(widget.searchModel);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.searchModel.serviceTitle ?? '',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '${widget.searchModel.categoryTitle}',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  debugPrint('${urlBase}${widget.searchModel.serviceImage}');
                },
                child: NetworkImageWithPlaceholder(
                  imageUrl: '${urlBase}${widget.searchModel.serviceImage}',
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: 1,
              color: myColors.devider,
            ),
          ),
        ],
      ),
    );
  }
}
