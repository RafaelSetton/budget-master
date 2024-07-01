import 'package:flutter/material.dart';

abstract class CreationFormSelector<T> extends StatefulWidget {
  const CreationFormSelector({super.key});

  T get value;
}
