/// Nombres de tablas, columnas y claves usadas en Supabase y modelos de datos.
/// Usar siempre estas constantes en datasources y models en lugar de strings
/// literales, para evitar typos y facilitar refactors.
class RC {
  RC._();

  // ── HTTP status codes ──────────────────────────────────────────────────────
  static const int codeSuccess = 200;
  static const int codeSuccessCreated = 201;
  static const int codeSuccessAccepted = 202;
  static const int codeSuccessNoContent = 204;
  static const int codeBadRequest = 400;
  static const int codeUnauthorized = 401;
  static const int codeForbidden = 403;
  static const int codeNotFound = 404;
  static const int codeConflict = 409;
  static const int codeHostUnable = 500;

  static const String unableHostMessage = 'Failed host lookup:';
  static const String softwareCausedConnectionAbort =
      'Software caused connection abort';

  // ── Columnas comunes (compartidas por varias tablas) ───────────────────────
  static const String id = 'id';
  static const String createdAt = 'created_at';
  static const String active = 'active';

  // ── Tabla: users ───────────────────────────────────────────────────────────
  static const String tableUsers = 'users';

  static const String userLastLogin = 'last_login';
  static const String userContactId = 'contact_id';

  // ── Tabla: contact ─────────────────────────────────────────────────────────
  static const String tableContact = 'contact';

  static const String contactOwnerUserId = 'owner_user_id';
  static const String contactName = 'name';
  static const String contactPhone = 'phone';
  static const String contactEmail = 'email';
  static const String contactPhoto = 'photo';
  static const String contactNotes = 'notes';
  static const String contactTags = 'tags';
  static const String contactAddress = 'address';
  static const String contactCountry = 'country';
  static const String contactDeactivatedAt = 'deactivated_at';
  static const String contactIsContactRole = 'is_contact_role';

  // ── Tabla: card ────────────────────────────────────────────────────────────
  static const String tableCard = 'card';

  static const String cardContactId = 'contact_id';
  static const String cardName = 'name';
  static const String cardNumber = 'number';
  static const String cardDescription = 'description';
  static const String cardBank = 'bank';
  static const String cardCurrency = 'currency';

  // ── Tabla: contact_role ────────────────────────────────────────────────────
  static const String tableContactRole = 'contact_role';

  static const String contactRoleRoleId = 'role_id';
  static const String contactRoleAssignedAt = 'assigned_at';

  // ── Tabla: role ────────────────────────────────────────────────────────────
  static const String tableRole = 'role';

  static const String roleKey = 'key';
  static const String roleNameEn = 'name_en';
  static const String roleNameEs = 'name_es';

  // ── Tabla: relationship ────────────────────────────────────────────────────
  static const String tableRelationship = 'relationship';

  static const String relationshipContactId1 = 'contact_id1';
  static const String relationshipRelationship1Id = 'relationship1_id';
  static const String relationshipContactId2 = 'contact_id2';
  static const String relationshipRelationship2Id = 'relationship2_id';

  // ── Tabla: relationship_type ───────────────────────────────────────────────
  static const String tableRelationshipType = 'relationship_type';

  // ── Tabla: frequency_analysis ─────────────────────────────────────────────
  static const String tableFrequencyAnalysis = 'frequency_analysis';

  static const String frequencyLastRecharge = 'last_recharge';
  static const String frequencyDays = 'frequency_days';
  static const String frequencyNextExpected = 'next_expected';
  static const String frequencyStdDeviation = 'std_deviation';
  static const String frequencyTotalRecharges = 'total_recharges';
  static const String frequencyAvgAmount = 'avg_amount';

  // ── Tabla: transaction ─────────────────────────────────────────────────────
  static const String tableTransaction = 'transaction';

  static const String transactionAmount = 'amount';
  static const String transactionDate = 'date';
  static const String transactionPaymentMethod = 'payment_method';
  static const String transactionDescription = 'description';
  static const String transactionSenderId = 'sender_id';
  static const String transactionReceiverId = 'receiver_id';
  static const String transactionSentAmount = 'sent_amount';
  static const String transactionReceivedAmount = 'received_amount';
  static const String transactionExchangeRate = 'exchange_rate';
  static const String transactionTransferMethod = 'transfer_method';
  static const String transactionStatus = 'transaction_status';
  static const String transactionIntermediaryId = 'intermediary_id';

  // ── Tabla: kv_store ────────────────────────────────────────────────────────
  static const String tableKvStore = 'kv_store';

  static const String kvStoreKey = 'key';
  static const String kvStoreValue = 'value';

  static const String name= 'name';
  static const String phone= 'phone';
  static const String email= 'email';
  static const String photo= 'photo';
  static const String notes= 'notes';
  static const String tags=  'tags';
  static const String address= 'address';
  static const String country= 'country';
  static const String created_at= 'created_at';

  // ── Supabase Auth user metadata ────────────────────────────────────────────
  // Claves usadas en user.userMetadata y toJson() de UserModel
  static const String fullName = 'full_name';
  static const String avatarUrl = 'avatar_url';

  // ── SharedPreferences keys (Settings) ─────────────────────────────────────
  static const String prefKeyTheme = 'settings_theme';
  static const String prefKeyLocale = 'settings_locale';
}