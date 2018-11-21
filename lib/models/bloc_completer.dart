import 'package:sitcom_joke_app/models/error.dart';

abstract class BlocCompleter<T>{

    completed(T t);
    error(dynamic error);
}