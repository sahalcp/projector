import 'package:projector/models/progressCount.dart';
import 'package:projector/models/viewModel.dart';

class View {
  ProgressCount progressCount = ProgressCount();
  ViewModel viewModel;
  View(){
    progressCount.listen((value) {
      // the value is percentage.
      //can you refresh view or do anything
    });
    viewModel = ViewModel(progressCount);
  }
}