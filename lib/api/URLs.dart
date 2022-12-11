class URLs {
  static const String HOST = "office.alalfy.com";
  static const String URL = "https://$HOST";
  static const String API_VERSION = "v1";
  static const String API_URL = "$URL/api/$API_VERSION";

  static const String CURRENT_URL = "$API_URL/orders/current";
  static const String STOPPED_URL = "$API_URL/orders/stopped";
  static const String FINISHED_URL = "$API_URL/orders/finished";
  static const String ARCHIVED_URL = "$API_URL/orders/archived";

  static const String NEW_URL = "$API_URL/orders/store";
  static const String DELETE_URL = "$API_URL/orders/delete";
  static const String UPDATE_URL = "$API_URL/orders/update";
  static const String STRAT_URL = "$API_URL/orders/start";
  static const String STOP_URL = "$API_URL/orders/stop";
  static const String FINISH_URL = "$API_URL/orders/finish";
  static const String ARCHIVE_URL = "$API_URL/orders/archive";
  static const String UNARCHIVE_URL = "$API_URL/orders/unarchive";

  static const String UPDATE_DONE_URL = "$API_URL/orders/update/done";
  static const String UPDATE_SHIPPED_URL = "$API_URL/orders/update/shipped";
  static const String UPDATE_NOTES_URL = "$API_URL/orders/update/notes";
  static const String UPDATE_PROBLEMS_URL = "$API_URL/orders/update/problems";
  static const String UPDATE_PDF_URL = "$API_URL/orders/update/pdf";
  static const String UPDATE_DXF_URL = "$API_URL/orders/update/dxf";

  static const String PDF_URL = "$URL/uploads/pdf";
  static const String DXF_URL = "$URL/uploads/dxf";
}
