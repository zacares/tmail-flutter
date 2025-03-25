import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:tmail_ui_user/features/caching/utils/caching_constants.dart';
import 'package:jmap_dart_client/http/converter/email_id_nullable_converter.dart';
import 'package:jmap_dart_client/jmap/mail/email/email.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:model/email/email_action_type.dart';
import 'package:tmail_ui_user/features/composer/presentation/model/screen_display_mode.dart';

part 'local_email_draft.g.dart';

@HiveType(typeId: CachingConstants.LOCAL_EMAIL_DRAFT_CACHE_ID)
class LocalEmailDraft with EquatableMixin {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String composerId;

  @HiveField(2)
  final DateTime savedTime;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final bool? hasRequestReadReceipt;

  @HiveField(5)
  final bool? isMarkAsImportant;

  @HiveField(6)
  final String? displayMode;

  @HiveField(7)
  final int? composerIndex;

  @HiveField(8)
  final int? draftHash;

  @HiveField(9)
  final String? actionType;

  @HiveField(10)
  final String? draftEmailId;

  LocalEmailDraft({
    required this.id,
    required this.composerId,
    required this.savedTime,
    this.email,
    this.hasRequestReadReceipt,
    this.isMarkAsImportant,
    this.displayMode,
    this.composerIndex,
    this.draftHash,
    this.actionType,
    this.draftEmailId,
  });

  @override
  List<Object?> get props => [
    id,
    savedTime,
    email,
    hasRequestReadReceipt,
    isMarkAsImportant,
    displayMode,
    composerIndex,
    composerId,
    draftHash,
    actionType,
    draftEmailId,
  ];
}
