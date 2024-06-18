import 'package:xerian/models/Category.dart';

import '../../widgets/model_list_view.dart';

class CategoryListView extends ModelListView {
  CategoryListView({super.key})
      : super(Category.classType, const ['type', 'value', 'alternatives']);
}
