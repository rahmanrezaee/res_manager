import 'package:admin/GlobleService/APIRequest.dart';
import 'package:admin/constants/api_path.dart';

class TermConditionService {
  Future getTerm() async {
    String url = "$baseUrl/public/pages/customer/tandc";
    var res = await APIRequest().get(myUrl: url);
    print(res.data);
    return res.data['data']['body'];
  }
}
