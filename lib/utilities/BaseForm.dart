import 'package:fcm_voip/data/form_details.dart';
import 'package:flutter/material.dart';

abstract class BaseForm {
  Widget buildForm(List<FormDetails> formDetails);
}