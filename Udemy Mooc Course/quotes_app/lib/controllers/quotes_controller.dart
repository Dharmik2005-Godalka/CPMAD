import 'package:get/get.dart';
import 'package:quotes_app/models/quote_model.dart';
import 'package:quotes_app/services/quote_service.dart';

class QuoteController extends GetxController 
{
  RxList<Quotes> quotes = <Quotes>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() 
  {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async 
  {
    isLoading.value = true;
    try 
    {
      quotes.clear();
      quotes.addAll(await QuoteService.fetchQuote());
    } 
    finally 
    {
      isLoading.value = false;
    }
  }
}
