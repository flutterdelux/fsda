# Structure Example

Dokumen ini bersifat ilustratif, bukan normatif.

Untuk menjaga keterbacaan, beberapa bagian pada contoh ini menyorot struktur implementasi utama tanpa selalu mengulang seluruh baseline Flutter yang kini direkomendasikan untuk setiap module, seperti `l10n.yaml`, `lib/l10n/`, dan `lib/src/generated/`.

Aturan normatif untuk baseline module tetap mengikuti [Structure](structure.md), [Development Workflow](../guides/development-workflow.md), dan [app_l10n](../packages/app-l10n.md).

Contoh page pada App juga perlu dibaca sebagai ilustrasi surface page. Dalam praktiknya, page dapat berupa single-slice page maupun aggregate page sesuai kebutuhan composition aplikasi.

```text
fsda-base/
├── apps/
│   └── fsda_base/
│       ├── analysis_options.yaml
│       ├── flutter_launcher_icons.yaml
│       ├── package_rename_config.yaml
│       ├── pubspec.yaml
│       ├── assets/
│       │   └── images/
│       │       └── logo.png
│       └── lib/
│           ├── main.dart
│           ├── app/
│           │   ├── app_router.dart
│           │   ├── main_app.dart
│           │   ├── startup.dart
│           │   └── dashboard/
│           │       ├── dashboard_route.dart
│           │       ├── pages/
│           │       │   ├── dashboard.dart
│           │       │   └── home_page.dart
│           │       └── widgets/
│           │           └── bottom_nav_bar.dart
│           ├── core/
│           │   ├── constants/
│           │   │   ├── app_config.dart
│           │   │   ├── app_constants.dart
│           │   │   └── app_external_links.dart
│           │   ├── di/
│           │   │   ├── core_di.dart
│           │   │   ├── di.dart
│           │   │   ├── di_keys.dart
│           │   │   └── external_di.dart
│           │   ├── extensions/
│           │   │   └── failure_x.dart
│           │   ├── externals/
│           │   │   ├── fdelux_mock_config.dart
│           │   │   ├── logging_config.dart
│           │   │   ├── network_timeout_config.dart
│           │   │   ├── owm_config.dart
│           │   │   ├── sqflite_config.dart
│           │   │   └── supabase_config.dart
│           │   ├── mixins/
│           │   │   └── page_provider_mixin.dart
│           │   └── pages/
│           │       ├── invalid_argument_page.dart
│           │       └── not_found_page.dart
│           └── modules/
│               ├── attendance/
│               │   ├── attendance_di.dart
│               │   ├── attendance_route.dart
│               │   └── features/
│               │       └── attendance/
│               │           └── pages/
│               │               └── attendance_list_page.dart
│               ├── finance/
│               │   ├── finance_di.dart
│               │   ├── finance_route.dart
│               │   └── features/
│               │       └── wallet/
│               │           └── pages/
│               │               └── wallet_detail_page.dart
│               ├── inbox/
│               │   ├── inbox_di.dart
│               │   ├── inbox_route.dart
│               │   └── features/
│               │       └── inbox/
│               │           └── pages/
│               │               └── inbox_list_page.dart
│               ├── location/
│               │   ├── location_di.dart
│               │   ├── location_route.dart
│               │   └── features/
│               │       └── city/
│               │           └── pages/
│               │               └── city_list_page.dart
│               ├── note/
│               │   ├── note_di.dart
│               │   ├── note_route.dart
│               │   └── features/
│               │       └── note/
│               │           └── pages/
│               │               └── note_list_page.dart
│               ├── product/
│               │   ├── product_di.dart
│               │   ├── product_route.dart
│               │   └── features/
│               │       └── product/
│               │           └── pages/
│               │               └── product_detail_page.dart
│               ├── queue/
│               │   ├── queue_di.dart
│               │   ├── queue_route.dart
│               │   └── features/
│               │       └── queue/
│               │           └── pages/
│               │               └── queue_take_page.dart
│               ├── settings/
│               │   ├── settings_di.dart
│               │   ├── settings_route.dart
│               │   └── features/
│               │       └── theme/
│               │           └── pages/
│               │               └── theme_mode_page.dart
│               ├── subscription/
│               │   ├── subscription_di.dart
│               │   ├── subscription_route.dart
│               │   └── features/
│               │       └── payment/
│               │           └── pages/
│               │               └── payment_status_page.dart
│               ├── task/
│               │   ├── task_di.dart
│               │   ├── task_route.dart
│               │   └── features/
│               │       └── task/
│               │           └── pages/
│               │               └── task_create_page.dart
│               └── travel/
│                   ├── travel_di.dart
│                   ├── travel_route.dart
│                   └── features/
│                       └── destination/
│                           └── pages/
│                               └── destination_page.dart
├── modules/
│   ├── attendance/
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── attendance.dart
│   │       └── src/
│   │           ├── features/
│   │           │   └── attendance/
│   │           │       ├── attendance_feature.dart
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   │   └── attendance_type_converter.dart
│   │           │       │   ├── datasources/
│   │           │       │   │   ├── attendance_remote_data_source.dart
│   │           │       │   │   └── attendance_remote_data_source_impl.dart
│   │           │       │   ├── dtos/
│   │           │       │   │   └── attendance_dto.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── attendance_repository_impl.dart
│   │           │       │   ├── requests/
│   │           │       │   └── responses/
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   │   └── attendance_entity.dart
│   │           │       │   ├── enums/
│   │           │       │   │   └── attendance_type.dart
│   │           │       │   ├── params/
│   │           │       │   ├── repositories/
│   │           │       │   │   └── attendance_repository.dart
│   │           │       │   └── usecases/
│   │           │       │       └── attendance_list_use_case.dart
│   │           │       ├── logic/
│   │           │       │   └── list/
│   │           │       │       ├── attendance_list_cubit.dart
│   │           │       │       └── attendance_list_state.dart
│   │           │       └── ui/
│   │           │           ├── extensions/
│   │           │           │   └── attendance_type_x.dart
│   │           │           └── list/
│   │           │               ├── views/
│   │           │               │   └── attendance_list_view.dart
│   │           │               └── widgets/
│   │           │                   ├── attendance_list_content.dart
│   │           │                   ├── attendance_list_empty_feedback.dart
│   │           │                   ├── attendance_list_error_feedback.dart
│   │           │                   ├── attendance_list_skeleton.dart
│   │           │                   └── parts/
│   │           │                       ├── attendance_list_item.dart
│   │           │                       └── attendance_list_item_skeleton.dart
│   │           └── shared/
│   │               ├── data/
│   │               │   └── errors/
│   │               │       └── attendance_exception.dart
│   │               ├── domain/
│   │               │   └── errors/
│   │               │       └── attendance_failure.dart
│   │               ├── logic/
│   │               └── ui/
│   │                   └── extensions/
│   │                       └── attendance_failure_x.dart
│   ├── finance/
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── finance.dart
│   │       └── src/
│   │           ├── features/
│   │           │   └── wallet/
│   │           │       ├── wallet_feature.dart
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   ├── datasources/
│   │           │       │   │   ├── wallet_remote_data_source.dart
│   │           │       │   │   └── wallet_remote_data_source_impl.dart
│   │           │       │   ├── dtos/
│   │           │       │   ├── repositories/
│   │           │       │   │   └── wallet_repository_impl.dart
│   │           │       │   ├── requests/
│   │           │       │   │   └── wallet_delete_request.dart
│   │           │       │   └── responses/
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   ├── enums/
│   │           │       │   ├── params/
│   │           │       │   │   └── wallet_delete_param.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── wallet_repository.dart
│   │           │       │   └── usecases/
│   │           │       │       └── wallet_delete_use_case.dart
│   │           │       ├── logic/
│   │           │       │   └── delete/
│   │           │       │       ├── wallet_delete_cubit.dart
│   │           │       │       └── wallet_delete_state.dart
│   │           │       └── ui/
│   │           │           └── delete/
│   │           │               └── widgets/
│   │           │                   ├── wallet_delete_dialog.dart
│   │           │                   └── wallet_delete_popup_menu_item.dart
│   │           └── shared/
│   │               ├── data/
│   │               │   └── errors/
│   │               │       └── finance_exception.dart
│   │               ├── domain/
│   │               │   └── errors/
│   │               │       └── finance_failure.dart
│   │               ├── logic/
│   │               └── ui/
│   │                   └── extensions/
│   │                       └── finance_failure_x.dart
│   ├── inbox/
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── inbox.dart
│   │       └── src/
│   │           ├── features/
│   │           │   └── inbox/
│   │           │       ├── inbox_feature.dart
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   ├── datasources/
│   │           │       │   │   ├── inbox_remote_data_source.dart
│   │           │       │   │   └── inbox_remote_data_source_impl.dart
│   │           │       │   ├── dtos/
│   │           │       │   ├── repositories/
│   │           │       │   │   └── inbox_repository_impl.dart
│   │           │       │   ├── requests/
│   │           │       │   └── responses/
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   ├── enums/
│   │           │       │   ├── params/
│   │           │       │   ├── repositories/
│   │           │       │   │   └── inbox_repository.dart
│   │           │       │   └── usecases/
│   │           │       │       └── inbox_mark_all_read_use_case.dart
│   │           │       ├── logic/
│   │           │       │   └── mark_all_read/
│   │           │       │       ├── inbox_mark_all_read_cubit.dart
│   │           │       │       └── inbox_mark_all_read_state.dart
│   │           │       └── ui/
│   │           │           └── mark_all_read/
│   │           │               └── widgets/
│   │           │                   └── inbox_mark_all_read_popup_menu_item.dart
│   │           └── shared/
│   │               ├── data/
│   │               │   └── errors/
│   │               │       └── inbox_exception.dart
│   │               ├── domain/
│   │               │   └── errors/
│   │               │       └── inbox_failure.dart
│   │               ├── logic/
│   │               └── ui/
│   │                   └── extensions/
│   │                       └── inbox_failure_x.dart
│   ├── location/
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── location.dart
│   │       └── src/
│   │           ├── features/
│   │           │   └── city/
│   │           │       ├── city_feature.dart
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   ├── datasources/
│   │           │       │   │   ├── city_remote_data_source.dart
│   │           │       │   │   └── city_remote_data_source_impl.dart
│   │           │       │   ├── dtos/
│   │           │       │   │   └── city_dto.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── city_repository_impl.dart
│   │           │       │   ├── requests/
│   │           │       │   │   └── city_list_request.dart
│   │           │       │   └── responses/
│   │           │       │       └── city_list_response.dart
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   │   └── city_entity.dart
│   │           │       │   ├── enums/
│   │           │       │   ├── params/
│   │           │       │   │   └── city_list_param.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── city_repository.dart
│   │           │       │   └── usecases/
│   │           │       │       └── city_list_use_case.dart
│   │           │       ├── logic/
│   │           │       │   └── list/
│   │           │       │       ├── city_list_cubit.dart
│   │           │       │       └── city_list_state.dart
│   │           │       └── ui/
│   │           │           └── list/
│   │           │               ├── views/
│   │           │               │   └── city_list_view.dart
│   │           │               └── widgets/
│   │           │                   ├── city_list_content.dart
│   │           │                   ├── city_list_empty_feedback.dart
│   │           │                   ├── city_list_error_feedback.dart
│   │           │                   ├── city_list_skeleton.dart
│   │           │                   └── parts/
│   │           │                       ├── city_list_item.dart
│   │           │                       └── city_list_item_skeleton.dart
│   │           └── shared/
│   │               ├── data/
│   │               │   └── errors/
│   │               │       └── location_exception.dart
│   │               ├── domain/
│   │               │   └── errors/
│   │               │       └── location_failure.dart
│   │               ├── logic/
│   │               └── ui/
│   │                   └── extensions/
│   │                       └── location_failure_x.dart
│   ├── note/
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── note.dart
│   │       └── src/
│   │           ├── features/
│   │           │   └── note/
│   │           │       ├── note_feature.dart
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   ├── datasources/
│   │           │       │   │   ├── local/
│   │           │       │   │   │   ├── note_local_data_source.dart
│   │           │       │   │   │   └── note_local_data_source_impl.dart
│   │           │       │   │   └── remote/
│   │           │       │   │       ├── note_remote_data_source.dart
│   │           │       │   │       └── note_remote_data_source_impl.dart
│   │           │       │   ├── dtos/
│   │           │       │   │   └── note_dto.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── note_repository_impl.dart
│   │           │       │   ├── requests/
│   │           │       │   └── responses/
│   │           │       │       └── note_list_response.dart
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   │   └── note_entity.dart
│   │           │       │   ├── enums/
│   │           │       │   ├── params/
│   │           │       │   ├── repositories/
│   │           │       │   │   └── note_repository.dart
│   │           │       │   └── usecases/
│   │           │       │       └── note_list_use_case.dart
│   │           │       ├── logic/
│   │           │       │   └── list/
│   │           │       │       ├── note_list_cubit.dart
│   │           │       │       └── note_list_state.dart
│   │           │       └── ui/
│   │           │           └── list/
│   │           │               ├── views/
│   │           │               │   └── note_list_view.dart
│   │           │               └── widgets/
│   │           │                   ├── note_list_content.dart
│   │           │                   ├── note_list_empty_feedback.dart
│   │           │                   ├── note_list_error_feedback.dart
│   │           │                   └── note_list_skeleton.dart
│   │           └── shared/
│   │               ├── data/
│   │               │   └── errors/
│   │               │       └── note_exception.dart
│   │               ├── domain/
│   │               │   └── errors/
│   │               │       └── note_failure.dart
│   │               ├── logic/
│   │               └── ui/
│   │                   └── extensions/
│   │                       └── note_failure_x.dart
│   ├── product/
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── product.dart
│   │       └── src/
│   │           ├── features/
│   │           │   └── product/
│   │           │       ├── product_feature.dart
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   ├── datasources/
│   │           │       │   │   ├── product_remote_data_source.dart
│   │           │       │   │   └── product_remote_data_source_impl.dart
│   │           │       │   ├── dtos/
│   │           │       │   │   └── product_dto.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── product_repository_impl.dart
│   │           │       │   ├── requests/
│   │           │       │   │   └── product_detail_request.dart
│   │           │       │   └── responses/
│   │           │       │       └── product_detail_response.dart
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   │   └── product_entity.dart
│   │           │       │   ├── enums/
│   │           │       │   ├── params/
│   │           │       │   │   └── product_detail_param.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── product_repository.dart
│   │           │       │   └── usecases/
│   │           │       │       └── product_detail_use_case.dart
│   │           │       ├── logic/
│   │           │       │   └── detail/
│   │           │       │       ├── product_detail_cubit.dart
│   │           │       │       └── product_detail_state.dart
│   │           │       └── ui/
│   │           │           └── detail/
│   │           │               ├── views/
│   │           │               │   └── product_detail_view.dart
│   │           │               └── widgets/
│   │           │                   ├── product_detail_content.dart
│   │           │                   ├── product_detail_error.dart
│   │           │                   └── product_detail_skeleton.dart
│   │           └── shared/
│   │               ├── data/
│   │               │   └── errors/
│   │               │       └── product_exception.dart
│   │               ├── domain/
│   │               │   └── errors/
│   │               │       └── product_failure.dart
│   │               ├── logic/
│   │               └── ui/
│   │                   └── extensions/
│   │                       └── product_failure_x.dart
│   ├── queue/
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── queue.dart
│   │       └── src/
│   │           ├── features/
│   │           │   └── queue/
│   │           │       ├── queue_feature.dart
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   │   └── queue_status_converter.dart
│   │           │       │   ├── datasources/
│   │           │       │   │   ├── queue_remote_data_source.dart
│   │           │       │   │   └── queue_remote_data_source_impl.dart
│   │           │       │   ├── dtos/
│   │           │       │   │   └── queue_dto.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── queue_repository_impl.dart
│   │           │       │   ├── requests/
│   │           │       │   └── responses/
│   │           │       │       └── queue_take_response.dart
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   │   └── queue_entity.dart
│   │           │       │   ├── enums/
│   │           │       │   │   └── queue_status.dart
│   │           │       │   ├── params/
│   │           │       │   ├── repositories/
│   │           │       │   │   └── queue_repository.dart
│   │           │       │   └── usecases/
│   │           │       │       └── queue_take_use_case.dart
│   │           │       ├── logic/
│   │           │       │   └── take/
│   │           │       │       ├── queue_take_cubit.dart
│   │           │       │       └── queue_take_state.dart
│   │           │       └── ui/
│   │           │           ├── shared/
│   │           │           │   └── extensions/
│   │           │           │       └── queue_status_x.dart
│   │           │           └── take/
│   │           │               ├── views/
│   │           │               │   └── queue_take_view.dart
│   │           │               └── widgets/
│   │           │                   ├── queue_take_button.dart
│   │           │                   ├── queue_take_content.dart
│   │           │                   ├── queue_take_error_feedback.dart
│   │           │                   ├── queue_take_initial_feedback.dart
│   │           │                   └── queue_take_skeleton.dart
│   │           └── shared/
│   │               ├── data/
│   │               │   └── errors/
│   │               │       └── queue_exception.dart
│   │               ├── domain/
│   │               │   └── errors/
│   │               │       └── queue_failure.dart
│   │               ├── logic/
│   │               └── ui/
│   │                   └── extensions/
│   │                       └── queue_failure_x.dart
│   ├── settings/
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── settings.dart
│   │       └── src/
│   │           ├── features/
│   │           │   └── theme/
│   │           │       ├── theme_feature.dart
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   │   └── app_theme_mode_converter.dart
│   │           │       │   ├── datasources/
│   │           │       │   │   ├── theme_local_data_source.dart
│   │           │       │   │   └── theme_local_data_source_impl.dart
│   │           │       │   ├── dtos/
│   │           │       │   ├── repositories/
│   │           │       │   │   └── theme_repository_impl.dart
│   │           │       │   ├── requests/
│   │           │       │   └── responses/
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   ├── enums/
│   │           │       │   │   └── app_theme_mode.dart
│   │           │       │   ├── params/
│   │           │       │   ├── repositories/
│   │           │       │   │   └── theme_repository.dart
│   │           │       │   └── usecases/
│   │           │       │       └── theme_mode_load_use_case.dart
│   │           │       ├── logic/
│   │           │       │   └── mode/
│   │           │       │       └── theme_mode_cubit.dart
│   │           │       └── ui/
│   │           │           ├── mode/
│   │           │           │   ├── views/
│   │           │           │   │   └── theme_mode_view.dart
│   │           │           │   └── widgets/
│   │           │           │       └── theme_mode_content.dart
│   │           │           └── shared/
│   │           │               └── extensions/
│   │           │                   └── app_theme_mode_x.dart
│   │           └── shared/
│   │               ├── data/
│   │               │   └── errors/
│   │               │       └── settings_exception.dart
│   │               ├── domain/
│   │               │   └── errors/
│   │               │       └── settings_failure.dart
│   │               ├── logic/
│   │               └── ui/
│   │                   └── extensions/
│   │                       └── settings_failure_x.dart
│   ├── subscription/
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── subscription.dart
│   │       └── src/
│   │           ├── features/
│   │           │   └── payment/
│   │           │       ├── payment_feature.dart
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   │   └── payment_status_converter.dart
│   │           │       │   ├── datasources/
│   │           │       │   │   ├── payment_remote_data_source.dart
│   │           │       │   │   └── payment_remote_data_source_impl.dart
│   │           │       │   ├── dtos/
│   │           │       │   │   └── payment_dto.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── payment_repository_impl.dart
│   │           │       │   ├── requests/
│   │           │       │   │   └── payment_status_request.dart
│   │           │       │   └── responses/
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   │   └── payment_entity.dart
│   │           │       │   ├── enums/
│   │           │       │   │   └── payment_status.dart
│   │           │       │   ├── params/
│   │           │       │   │   └── payment_status_param.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── payment_repository.dart
│   │           │       │   └── usecases/
│   │           │       │       └── payment_status_use_case.dart
│   │           │       ├── logic/
│   │           │       │   └── status/
│   │           │       │       ├── payment_status_cubit.dart
│   │           │       │       └── payment_status_state.dart
│   │           │       └── ui/
│   │           │           ├── shared/
│   │           │           │   └── extension/
│   │           │           │       └── payment_status_x.dart
│   │           │           └── status/
│   │           │               ├── views/
│   │           │               │   └── payment_status_view.dart
│   │           │               └── widgets/
│   │           │                   ├── payment_status_content.dart
│   │           │                   ├── payment_status_error_feedback.dart
│   │           │                   └── payment_status_skeleton.dart
│   │           └── shared/
│   │               ├── data/
│   │               │   └── errors/
│   │               │       └── subscription_exception.dart
│   │               ├── domain/
│   │               │   └── errors/
│   │               │       └── subscription_failure.dart
│   │               ├── logic/
│   │               └── ui/
│   │                   └── extensions/
│   │                       └── subscription_failure_x.dart
│   ├── task/
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── task.dart
│   │       └── src/
│   │           ├── features/
│   │           │   └── task/
│   │           │       ├── task_feature.dart
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   │   └── task_status_converter.dart
│   │           │       │   ├── datasources/
│   │           │       │   │   ├── task_remote_data_source.dart
│   │           │       │   │   └── task_remote_data_source_impl.dart
│   │           │       │   ├── dtos/
│   │           │       │   │   └── task_dto.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── task_repository_impl.dart
│   │           │       │   ├── requests/
│   │           │       │   │   └── task_create_request.dart
│   │           │       │   └── responses/
│   │           │       │       └── task_create_response.dart
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   │   └── task_entity.dart
│   │           │       │   ├── enums/
│   │           │       │   │   └── task_status.dart
│   │           │       │   ├── params/
│   │           │       │   │   └── task_create_param.dart
│   │           │       │   ├── repositories/
│   │           │       │   │   └── task_repository.dart
│   │           │       │   └── usecases/
│   │           │       │       └── task_create_use_case.dart
│   │           │       ├── logic/
│   │           │       │   └── create/
│   │           │       │       ├── task_create_cubit.dart
│   │           │       │       ├── task_create_form_cubit.dart
│   │           │       │       ├── task_create_form_state.dart
│   │           │       │       └── task_create_state.dart
│   │           │       └── ui/
│   │           │           ├── create/
│   │           │           │   ├── views/
│   │           │           │   │   └── task_create_view.dart
│   │           │           │   └── widgets/
│   │           │           │       ├── task_create_button.dart
│   │           │           │       └── task_create_form.dart
│   │           │           └── shared/
│   │           │               └── widgets/
│   │           │                   ├── task_description_field.dart
│   │           │                   └── task_title_field.dart
│   │           └── shared/
│   │               ├── data/
│   │               │   └── errors/
│   │               │       └── task_exception.dart
│   │               ├── domain/
│   │               │   └── errors/
│   │               │       └── task_failure.dart
│   │               ├── logic/
│   │               └── ui/
│   │                   └── extensions/
│   │                       └── task_failure_x.dart
│   └── travel/
│       ├── analysis_options.yaml
│       ├── build.yaml
│       ├── pubspec.yaml
│       └── lib/
│           ├── travel.dart
│           └── src/
│               ├── features/
│               │   └── destination/
│               │       ├── destination_feature.dart
│               │       ├── data/
│               │       │   ├── converters/
│               │       │   ├── datasources/
│               │       │   │   ├── destination_remote_data_source.dart
│               │       │   │   └── destination_remote_data_source_impl.dart
│               │       │   ├── dtos/
│               │       │   │   └── destination_dto.dart
│               │       │   ├── repositories/
│               │       │   │   └── destination_repository_impl.dart
│               │       │   ├── requests/
│               │       │   └── responses/
│               │       │       └── destination_popular_response.dart
│               │       ├── domain/
│               │       │   ├── entities/
│               │       │   │   └── destination_entity.dart
│               │       │   ├── enums/
│               │       │   ├── params/
│               │       │   ├── repositories/
│               │       │   │   └── destination_repository.dart
│               │       │   └── usecases/
│               │       │       └── destination_popular_use_case.dart
│               │       ├── logic/
│               │       │   └── popular/
│               │       │       ├── destination_popular_cubit.dart
│               │       │       └── destination_popular_state.dart
│               │       └── ui/
│               │           └── popular/
│               │               └── widgets/
│               │                   ├── destination_popular_content.dart
│               │                   ├── destination_popular_empty_feedback.dart
│               │                   ├── destination_popular_error_feedback.dart
│               │                   ├── destination_popular_section.dart
│               │                   ├── destination_popular_skeleton.dart
│               │                   └── parts/
│               │                       ├── destination_popular_item.dart
│               │                       └── destination_popular_item_skeleton.dart
│               └── shared/
│                   ├── data/
│                   │   └── errors/
│                   │       └── travel_exception.dart
│                   ├── domain/
│                   │   └── errors/
│                   │       └── travel_failure.dart
│                   ├── logic/
│                   └── ui/
│                       └── extensions/
│                           └── travel_failure_x.dart
└── packages/
    ├── app_core/
    │   ├── analysis_options.yaml
    │   ├── pubspec.yaml
    │   └── lib/
    │       ├── app_core.dart
    │       └── src/
    │           ├── data/
    │           │   ├── repository_exception_handler.dart
    │           │   ├── converters/
    │           │   │   └── utc_date_time_converter.dart
    │           │   └── errors/
    │           │       ├── app_exception.dart
    │           │       └── core_exception.dart
    │           ├── database/
    │           │   └── database_client.dart
    │           ├── domain/
    │           │   ├── result.dart
    │           │   ├── use_case.dart
    │           │   └── errors/
    │           │       ├── core_failure.dart
    │           │       └── failure.dart
    │           ├── logging/
    │           │   └── app_logger.dart
    │           ├── network/
    │           │   ├── api_client.dart
    │           │   ├── api_response.dart
    │           │   └── network_info.dart
    │           └── storage/
    │               ├── local_storage.dart
    │               └── secure_storage.dart
    ├── app_l10n/
    │   ├── analysis_options.yaml
    │   ├── l10n.yaml
    │   ├── pubspec.yaml
    │   └── lib/
    │       ├── app_l10n.dart
    │       ├── l10n/
    │       │   ├── app_en.arb
    │       │   └── app_id.arb
    │       └── src/
    │           ├── extensions/
    │           │   └── l10n_x.dart
    │           └── generated/
    │               ├── app_localizations.dart
    │               ├── app_localizations_en.dart
    │               └── app_localizations_id.dart
    └── app_ui/
        ├── analysis_options.yaml
        ├── pubspec.yaml
        ├── assets/
        │   └── fonts/
        │       └── inter/
        │           ├── Inter-Bold.ttf
        │           ├── Inter-Light.ttf
        │           ├── Inter-Medium.ttf
        │           ├── Inter-Regular.ttf
        │           └── Inter-SemiBold.ttf
        └── lib/
            ├── app_ui.dart
            └── src/
                ├── extensions/
                │   ├── color_scheme_x.dart
                │   ├── color_x.dart
                │   ├── snackbar_x.dart
                │   ├── string_color_x.dart
                │   └── text_style_x.dart
                ├── theme/
                │   ├── app_theme.dart
                │   └── components/
                │       ├── app_border_theme.dart
                │       ├── app_button_theme.dart
                │       ├── app_card_theme.dart
                │       ├── app_color_theme.dart
                │       ├── app_divider_theme.dart
                │       ├── app_input_theme.dart
                │       ├── app_nav_bar_theme.dart
                │       └── app_text_theme.dart
                ├── tokens/
                │   ├── app_colors.dart
                │   ├── app_radius.dart
                │   ├── app_spacing.dart
                │   └── app_typography.dart
                └── widgets/
                    ├── buttons/
                    │   ├── app_submit_check_button.dart
                    │   └── app_submit_filled_button.dart
                    ├── cards/
                    │   └── app_card.dart
                    ├── dialog/
                    │   └── app_confirmation_dialog.dart
                    ├── feedback/
                    │   ├── app_empty_feedback.dart
                    │   ├── app_error_feedback.dart
                    │   ├── app_feedback.dart
                    │   ├── app_loading.dart
                    │   ├── app_loading_mini.dart
                    │   ├── app_loading_overlay.dart
                    │   └── app_shimmer.dart
                    ├── images/
                    │   └── app_network_image.dart
                    ├── inputs/
                    │   ├── app_color_field.dart
                    │   ├── app_date_time_field.dart
                    │   ├── app_dropdown_field.dart
                    │   ├── app_input_field_action.dart
                    │   └── app_text_field.dart
                    ├── layouts/
                    │   ├── app_bottom_container.dart
                    │   ├── app_gap.dart
                    │   ├── app_section.dart
                    │   └── app_section_header.dart
                    ├── leading/
                    │   ├── app_leading.dart
                    │   ├── app_leading_icon.dart
                    │   ├── app_leading_id.dart
                    │   └── app_leading_index.dart
                    ├── texts/
                    │   └── app_clickable_text.dart
                    └── tiles/
                        ├── app_action_tile.dart
                        ├── app_info_tile.dart
                        ├── app_info_tile_skeleton.dart
                        ├── app_list_tile.dart
                        ├── app_list_tile_skeleton.dart
                        └── app_option_tile.dart
```
