import 'package:xerian/models/Group.dart';

import '../../models/GroupType.dart';
import '../../widgets/model_list_view.dart';

class GroupListView extends ModelListView {
  GroupListView({super.key})
      : super(Group.classType, const ['type', 'value', 'alternatives'],
            filter: DropDownFilter<GroupType>(GroupType.values));
}
