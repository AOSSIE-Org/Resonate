// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get title => 'Resonate';

  @override
  String get roomDescription =>
      'Sé educado y respeta la opinión de los demás. Evita comentarios groseros.';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get passwordEmpty => 'La contraseña no puede estar vacía';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get passwordsNotMatch => 'Las contraseñas no coinciden';

  @override
  String get userCreatedStories => 'Historias creadas por el usuario';

  @override
  String get yourStories => 'Tus historias';

  @override
  String get userNoStories => 'El usuario no ha creado ninguna historia';

  @override
  String get youNoStories => 'No has creado ninguna historia';

  @override
  String get follow => 'Seguir';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get verifyEmail => 'Verificar correo';

  @override
  String get verified => 'Verificado';

  @override
  String get profile => 'Perfil';

  @override
  String get userLikedStories => 'Historias que le gustan al usuario';

  @override
  String get yourLikedStories => 'Historias que te gustan';

  @override
  String get userNoLikedStories =>
      'Al usuario no le ha gustado ninguna historia';

  @override
  String get youNoLikedStories => 'No te ha gustado ninguna historia';

  @override
  String get live => 'En vivo';

  @override
  String get upcoming => 'Próximas';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'No hay sala disponible',
      'false': 'No hay salas próximas disponibles',
      'other': 'No hay información de sala disponible',
    });
    return '$_temp0\n¡Empieza añadiendo una abajo!';
  }

  @override
  String get user1 => 'Usuario 1';

  @override
  String get user2 => 'Usuario 2';

  @override
  String get you => 'Tú';

  @override
  String get areYouSure => '¿Estás seguro?';

  @override
  String get loggingOut => 'Estás cerrando sesión en Resonate.';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get incorrectEmailOrPassword => 'Correo o contraseña incorrectos';

  @override
  String get passwordShort => 'La contraseña tiene menos de 8 caracteres';

  @override
  String get tryAgain => '¡Inténtalo de nuevo!';

  @override
  String get success => 'Éxito';

  @override
  String get passwordResetSent =>
      '¡Correo de restablecimiento de contraseña enviado!';

  @override
  String get error => 'Error';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get enterNewPassword => 'Ingresa tu nueva contraseña';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get setNewPassword => 'Establecer nueva contraseña';

  @override
  String get emailChanged => 'Correo cambiado';

  @override
  String get emailChangeSuccess => '¡Correo cambiado exitosamente!';

  @override
  String get failed => 'Fallido';

  @override
  String get emailChangeFailed => 'No se pudo cambiar el correo';

  @override
  String get oops => '¡Ups!';

  @override
  String get emailExists => 'El correo ya existe';

  @override
  String get changeEmail => 'Cambiar correo';

  @override
  String get enterValidEmail =>
      'Por favor ingresa una dirección de correo válida';

  @override
  String get newEmail => 'Nuevo correo';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get emailChangeInfo =>
      'Por seguridad adicional, debes proporcionar la contraseña actual de tu cuenta al cambiar tu dirección de correo. Después de cambiar el correo, usa el correo actualizado para futuros inicios de sesión.';

  @override
  String get oauthUsersMessage =>
      '(Solo para usuarios que iniciaron sesión con Google o Github)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'Para cambiar tu correo, ingresa una nueva contraseña en el campo \"Contraseña actual\". Asegúrate de recordar esta contraseña, ya que la necesitarás para futuros cambios de correo. En adelante, puedes iniciar sesión usando Google/GitHub o tu nueva combinación de correo y contraseña.';

  @override
  String get resonateTagline =>
      'Entra en un mundo de conversaciones\nsin límites.';

  @override
  String get signInWithEmail => 'Iniciar sesión con correo';

  @override
  String get or => 'O';

  @override
  String get continueWith => 'Continuar con';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get continueWithGitHub => 'Continuar con GitHub';

  @override
  String get resonateLogo => 'Logo de Resonate';

  @override
  String get iAlreadyHaveAnAccount => 'Ya tengo una cuenta';

  @override
  String get createNewAccount => 'Crear nueva cuenta';

  @override
  String get userProfile => 'Perfil de usuario';

  @override
  String get passwordIsStrong => 'La contraseña es segura';

  @override
  String get admin => 'Administrador';

  @override
  String get moderator => 'Moderador';

  @override
  String get speaker => 'Orador';

  @override
  String get listener => 'Oyente';

  @override
  String get removeModerator => 'Quitar moderador';

  @override
  String get kickOut => 'Expulsar';

  @override
  String get addModerator => 'Agregar moderador';

  @override
  String get addSpeaker => 'Agregar orador';

  @override
  String get makeListener => 'Hacer oyente';

  @override
  String get pairChat => 'Chat por parejas';

  @override
  String get chooseIdentity => 'Elegir identidad';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get noConnection => 'Sin conexión';

  @override
  String get loadingDialog => 'Diálogo de carga';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get enterValidEmailAddress => 'Ingresa una dirección de correo válida';

  @override
  String get email => 'Correo';

  @override
  String get passwordRequirements =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get includeNumericDigit => 'Incluir al menos un dígito numérico';

  @override
  String get includeUppercase => 'Incluir al menos una letra mayúscula';

  @override
  String get includeLowercase => 'Incluir al menos una letra minúscula';

  @override
  String get includeSymbol => 'Incluir al menos un símbolo';

  @override
  String get signedUpSuccessfully => 'Registro exitoso';

  @override
  String get newAccountCreated => 'Has creado una nueva cuenta exitosamente';

  @override
  String get signUp => 'Registrarse';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get settings => 'Configuración';

  @override
  String get accountSettings => 'Configuración de la cuenta';

  @override
  String get account => 'Cuenta';

  @override
  String get appSettings => 'Configuración de la app';

  @override
  String get themes => 'Temas';

  @override
  String get about => 'Acerca de';

  @override
  String get other => 'Otro';

  @override
  String get contribute => 'Contribuir';

  @override
  String get appPreferences => 'Preferencias de la app';

  @override
  String get transcriptionModel => 'Modelo de transcripción';

  @override
  String get transcriptionModelDescription =>
      'Elige el modelo de IA para la transcripción de voz. Los modelos más grandes son más precisos pero más lentos y requieren más almacenamiento.';

  @override
  String get whisperModelTiny => 'Diminuto';

  @override
  String get whisperModelTinyDescription =>
      'Más rápido, menos preciso (~39 MB)';

  @override
  String get whisperModelBase => 'Base';

  @override
  String get whisperModelBaseDescription =>
      'Velocidad y precisión equilibradas (~74 MB)';

  @override
  String get whisperModelSmall => 'Pequeño';

  @override
  String get whisperModelSmallDescription =>
      'Buena precisión, más lento (~244 MB)';

  @override
  String get whisperModelMedium => 'Mediano';

  @override
  String get whisperModelMediumDescription =>
      'Alta precisión, más lento (~769 MB)';

  @override
  String get whisperModelLargeV1 => 'Grande V1';

  @override
  String get whisperModelLargeV1Description =>
      'Más preciso, más lento (~1.55 GB)';

  @override
  String get whisperModelLargeV2 => 'Grande V2';

  @override
  String get whisperModelLargeV2Description =>
      'Modelo grande mejorado con mayor precisión (~1.55 GB)';

  @override
  String get modelDownloadInfo =>
      'Los modelos se descargan la primera vez que se usan. Recomendamos usar Base, Pequeño o Mediano. Los modelos grandes requieren dispositivos de gama muy alta.';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get participants => 'Participantes';

  @override
  String get delete => 'eliminar';

  @override
  String get leave => 'salir';

  @override
  String get leaveButton => 'Salir';

  @override
  String get findingRandomPartner => 'Buscando un compañero aleatorio para ti';

  @override
  String get quickFact => 'Dato rápido';

  @override
  String get cancel => 'Cancelar';

  @override
  String get hide => 'Eliminar';

  @override
  String get removeRoom => 'Eliminar sala';

  @override
  String get removeRoomFromList => 'Eliminar de la lista';

  @override
  String get removeRoomConfirmation =>
      '¿Estás seguro de que quieres eliminar esta sala próxima de tu lista?';

  @override
  String get completeYourProfile => 'Completa tu perfil';

  @override
  String get uploadProfilePicture => 'Subir foto de perfil';

  @override
  String get enterValidName => 'Ingresa un nombre válido';

  @override
  String get name => 'Nombre';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get enterValidDOB => 'Ingresa una fecha de nacimiento válida';

  @override
  String get dateOfBirth => 'Fecha de nacimiento';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get next => 'Siguiente';

  @override
  String get noStoriesExist => 'No existen historias para presentar';

  @override
  String get enterVerificationCode => 'Ingresa tu\ncódigo de verificación';

  @override
  String get verificationCodeSent =>
      'Enviamos un código de verificación de 6 dígitos a\n';

  @override
  String get verificationComplete => 'Verificación completa';

  @override
  String get verificationCompleteMessage =>
      'Felicidades, has verificado tu correo';

  @override
  String get verificationFailed => 'Verificación fallida';

  @override
  String get otpMismatch => 'El OTP no coincide, por favor intenta de nuevo';

  @override
  String get otpResent => 'OTP reenviado';

  @override
  String get requestNewCode => 'Solicitar un nuevo código';

  @override
  String get requestNewCodeIn => 'Solicitar un nuevo código en';

  @override
  String get clickPictureCamera => 'Tomar foto con la cámara';

  @override
  String get pickImageGallery => 'Elegir imagen de la galería';

  @override
  String get deleteMyAccount => 'Eliminar mi cuenta';

  @override
  String get createNewRoom => 'Crear nueva sala';

  @override
  String get pleaseEnterScheduledDateTime =>
      'Por favor ingresa la fecha y hora programadas';

  @override
  String get scheduleDateTimeLabel => 'Fecha y hora programadas';

  @override
  String get enterTags => 'Ingresa etiquetas';

  @override
  String get joinCommunity => 'Unirse a la comunidad';

  @override
  String get followUsOnX => 'Síguenos en X';

  @override
  String get joinDiscordServer => 'Unirse al servidor de Discord';

  @override
  String get noLyrics => 'Sin letra';

  @override
  String noStoriesInCategory(String categoryName) {
    return 'Actualmente no existen historias en la categoría $categoryName para presentar';
  }

  @override
  String get newChapters => 'Nuevos capítulos';

  @override
  String get helpToGrow => 'Ayuda a crecer';

  @override
  String get share => 'Compartir';

  @override
  String get rate => 'Calificar';

  @override
  String get aboutResonate => 'Acerca de Resonate';

  @override
  String get description => 'Descripción';

  @override
  String get confirm => 'Confirmar';

  @override
  String get classic => 'Clásico';

  @override
  String get time => 'Tiempo';

  @override
  String get vintage => 'Vintage';

  @override
  String get amber => 'Ámbar';

  @override
  String get forest => 'Bosque';

  @override
  String get cream => 'Crema';

  @override
  String get none => 'ninguno';

  @override
  String checkOutGitHub(String url) {
    return 'Echa un vistazo a nuestro repositorio de GitHub: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'logo de aossie';

  @override
  String get errorLoadPackageInfo =>
      'No se pudo cargar la información del paquete';

  @override
  String get searchFailed =>
      'No se pudieron buscar salas. Por favor intenta de nuevo.';

  @override
  String get updateAvailable => 'Actualización disponible';

  @override
  String get newVersionAvailable => '¡Una nueva versión está disponible!';

  @override
  String get upToDate => 'Actualizado';

  @override
  String get latestVersion => 'Estás usando la versión más reciente';

  @override
  String get profileCreatedSuccessfully => 'Perfil creado exitosamente';

  @override
  String get invalidScheduledDateTime => 'Fecha y hora programadas inválidas';

  @override
  String get scheduledDateTimePast =>
      'La fecha y hora programadas no pueden estar en el pasado';

  @override
  String get joinRoom => 'Unirse a la sala';

  @override
  String get unknownUser => 'Desconocido';

  @override
  String get canceled => 'cancelado';

  @override
  String get english => 'en';

  @override
  String get emailVerificationRequired => 'Verificación de correo requerida';

  @override
  String get verify => 'Verificar';

  @override
  String get audioRoom => 'Sala de audio';

  @override
  String toRoomAction(String action) {
    return 'Para $action la sala';
  }

  @override
  String get mailSentMessage => 'correo enviado';

  @override
  String get disconnected => 'desconectado';

  @override
  String get micOn => 'micrófono';

  @override
  String get speakerOn => 'altavoz';

  @override
  String get endChat => 'finalizar-chat';

  @override
  String get monthJan => 'Ene';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Abr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Ago';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dic';

  @override
  String get register => 'Registrarse';

  @override
  String get newToResonate => '¿Nuevo en Resonate? ';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get checking => 'Verificando...';

  @override
  String get forgotPasswordMessage =>
      'Ingresa tu dirección de correo registrada para restablecer tu contraseña.';

  @override
  String get usernameUnavailable => '¡Nombre de usuario no disponible!';

  @override
  String get usernameInvalidOrTaken =>
      'Este nombre de usuario es inválido o ya está tomado.';

  @override
  String get otpResentMessage =>
      'Por favor revisa tu correo para obtener un nuevo OTP.';

  @override
  String get connectionError =>
      'Hay un error de conexión. Por favor verifica tu internet e intenta de nuevo.';

  @override
  String get seconds => 'segundos.';

  @override
  String get unsavedChangesWarning =>
      'Si continúas sin guardar, los cambios no guardados se perderán.';

  @override
  String get deleteAccountPermanent =>
      'Esta acción eliminará tu cuenta permanentemente. Es un proceso irreversible. Eliminaremos tu nombre de usuario, dirección de correo y todos los demás datos asociados a tu cuenta. No podrás recuperarla.';

  @override
  String get giveGreatName => 'Dale un gran nombre...';

  @override
  String get joinCommunityDescription =>
      'Al unirte a la comunidad puedes aclarar tus dudas, sugerir nuevas funciones, reportar problemas que hayas enfrentado y más.';

  @override
  String get resonateDescription =>
      'Resonate es una plataforma de redes sociales donde cada voz es valorada. Comparte tus pensamientos, historias y experiencias con otros. Comienza tu viaje de audio ahora. Sumérgete en diversas discusiones y temas. Encuentra salas que resuenen contigo y conviértete en parte de la comunidad. ¡Únete a la conversación! Explora salas, conecta con amigos y comparte tu voz con el mundo.';

  @override
  String get resonateFullDescription =>
      'Resonate es una plataforma de redes sociales revolucionaria basada en voz donde cada voz importa. \nÚnete a conversaciones de audio en tiempo real, participa en discusiones diversas y conéctate con personas afines. Nuestra plataforma ofrece:\n- Salas de audio en vivo con discusiones basadas en temas\n- Redes sociales fluidas a través de la voz\n- Moderación de contenido impulsada por la comunidad\n- Compatibilidad multiplataforma\n- Conversaciones privadas cifradas de extremo a extremo\n\nDesarrollado por la comunidad de código abierto AOSSIE, priorizamos la privacidad del usuario y el desarrollo impulsado por la comunidad. ¡Únete a nosotros para dar forma al futuro del audio social!';

  @override
  String get stable => 'Estable';

  @override
  String get usernameCharacterLimit =>
      'El nombre de usuario debe contener más de 5 caracteres.';

  @override
  String get submit => 'Enviar';

  @override
  String get anonymous => 'Anónimo';

  @override
  String get noSearchResults => 'Sin resultados de búsqueda';

  @override
  String get searchRooms => 'Buscar salas...';

  @override
  String get searchingRooms => 'Buscando salas...';

  @override
  String get clearSearch => 'Limpiar búsqueda';

  @override
  String get searchError => 'Error de búsqueda';

  @override
  String get searchRoomsError =>
      'No se pudieron buscar las salas. Por favor intenta de nuevo.';

  @override
  String get searchUpcomingRoomsError =>
      'No se pudieron buscar las salas próximas. Por favor intenta de nuevo.';

  @override
  String get search => 'Buscar';

  @override
  String get clear => 'Limpiar';

  @override
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  ) {
    return '🚀 ¡Echa un vistazo a esta increíble sala: $roomName!\n\n📖 Descripción: $description\n👥 ¡Únete a $participants participantes ahora!';
  }

  @override
  String participantsCount(int count) {
    return '$count Participantes';
  }

  @override
  String get join => 'Unirse';

  @override
  String get invalidTags => 'Etiqueta inválida:';

  @override
  String get cropImage => 'Recortar imagen';

  @override
  String get profileSavedSuccessfully => 'Perfil actualizado';

  @override
  String get profileUpdatedSuccessfully =>
      'Todos los cambios se guardaron exitosamente.';

  @override
  String get profileUpToDate => 'Perfil actualizado';

  @override
  String get noChangesToSave =>
      'No se hicieron nuevos cambios, nada que guardar.';

  @override
  String get connectionFailed => 'Conexión fallida';

  @override
  String get unableToJoinRoom =>
      'No se pudo unir a la sala. Por favor verifica tu red e intenta de nuevo.';

  @override
  String get connectionLost => 'Conexión perdida';

  @override
  String get unableToReconnect =>
      'No se pudo reconectar a la sala. Por favor intenta volver a unirte.';

  @override
  String get invalidFormat => '¡Formato inválido!';

  @override
  String get usernameAlphanumeric =>
      'El nombre de usuario debe ser alfanumérico y no debe contener caracteres especiales.';

  @override
  String get userProfileCreatedSuccessfully =>
      'Tu perfil de usuario se ha creado exitosamente.';

  @override
  String get emailVerificationMessage =>
      'Para continuar, verifica tu dirección de correo.';

  @override
  String addNewChaptersToStory(String storyName) {
    return 'Agregar nuevos capítulos a $storyName';
  }

  @override
  String get currentChapters => 'Capítulos actuales';

  @override
  String get sourceCodeOnGitHub => 'Código fuente en GitHub';

  @override
  String get createAChapter => 'Crear un capítulo';

  @override
  String get chapterTitle => 'Título del capítulo *';

  @override
  String get aboutRequired => 'Acerca de *';

  @override
  String get changeCoverImage => 'Cambiar imagen de portada';

  @override
  String get uploadAudioFile => 'Subir archivo de audio';

  @override
  String get uploadLyricsFile => 'Subir archivo de letra';

  @override
  String get createChapter => 'Crear capítulo';

  @override
  String audioFileSelected(String fileName) {
    return 'Archivo de audio seleccionado: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'Archivo de letra seleccionado: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'Por favor completa todos los campos obligatorios y sube tu archivo de audio y archivo de letra';

  @override
  String get scheduled => 'Programada';

  @override
  String get ok => 'OK';

  @override
  String get roomDescriptionOptional => 'Descripción de la sala (opcional)';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get createYourStory => 'Crea tu historia';

  @override
  String get titleRequired => 'Título *';

  @override
  String get category => 'Categoría *';

  @override
  String get addChapter => 'Agregar capítulo';

  @override
  String get createStory => 'Crear historia';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'Por favor completa todos los campos obligatorios, agrega al menos un capítulo y selecciona una imagen de portada.';

  @override
  String get toConfirmType => 'Para confirmar, escribe';

  @override
  String get inTheBoxBelow => 'en el cuadro de abajo';

  @override
  String get iUnderstandDeleteMyAccount => 'Entiendo, eliminar mi cuenta';

  @override
  String get whatDoYouWantToListenTo => '¿Qué quieres escuchar?';

  @override
  String get categories => 'Categorías';

  @override
  String get stories => 'Historias';

  @override
  String get someSuggestions => 'Algunas sugerencias';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get skip => 'Omitir';

  @override
  String get welcomeToResonate => 'Bienvenido a Resonate';

  @override
  String get exploreDiverseConversations => 'Explora conversaciones diversas';

  @override
  String get yourVoiceMatters => 'Tu voz importa';

  @override
  String get joinConversationExploreRooms =>
      '¡Únete a la conversación! Explora salas, conecta con amigos y comparte tu voz con el mundo.';

  @override
  String get diveIntoDiverseDiscussions =>
      'Sumérgete en diversas discusiones y temas. \nEncuentra salas que resuenen contigo y conviértete en parte de la comunidad.';

  @override
  String get atResonateEveryVoiceValued =>
      'En Resonate, cada voz es valorada. Comparte tus pensamientos, historias y experiencias con otros. Comienza tu viaje de audio ahora.';

  @override
  String get notifications => 'Notificaciones';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username te mencionó en una sala próxima: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username te mencionó en la sala: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return 'A $username le gustó tu historia: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username se suscribió a tu sala: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username comenzó a seguirte';
  }

  @override
  String get youHaveNewNotification => 'Tienes una nueva notificación';

  @override
  String get hangOnGoodThingsTakeTime =>
      'Espera, las cosas buenas toman tiempo 🔍';

  @override
  String get resonateOpenSourceProject =>
      'Resonate es un proyecto de código abierto mantenido por AOSSIE. Visita nuestro github para contribuir.';

  @override
  String get mute => 'Silenciar';

  @override
  String get speakerLabel => 'Altavoz';

  @override
  String get end => 'Terminar';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get discard => 'DESCARTAR';

  @override
  String get save => 'GUARDAR';

  @override
  String get changeProfilePicture => 'Cambiar foto de perfil';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get remove => 'Eliminar';

  @override
  String created(String date) {
    return 'Creado $date';
  }

  @override
  String get chapters => 'Capítulos';

  @override
  String get deleteStory => 'Eliminar historia';

  @override
  String createdBy(String creatorName) {
    return 'Creado por $creatorName';
  }

  @override
  String get start => 'Comenzar';

  @override
  String get unsubscribe => 'Cancelar suscripción';

  @override
  String get subscribe => 'Suscribirse';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'Drama',
      'comedy': 'Comedia',
      'horror': 'Terror',
      'romance': 'Romance',
      'thriller': 'Suspenso',
      'spiritual': 'Espiritual',
      'other': 'Otro',
    });
    return '$_temp0';
  }

  @override
  String chooseTheme(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'classicTheme': 'Clásico',
      'timeTheme': 'Tiempo',
      'vintageTheme': 'Vintage',
      'amberTheme': 'Ámbar',
      'forestTheme': 'Bosque',
      'creamTheme': 'Crema',
      'other': 'Otro',
    });
    return '$_temp0';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count minutos',
      one: 'hace 1 minuto',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count horas',
      one: 'hace 1 hora',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String get by => 'por';

  @override
  String get likes => 'Me gusta';

  @override
  String get lengthMinutes => 'min';

  @override
  String get requiredField => 'Campo obligatorio';

  @override
  String get onlineUsers => 'Usuarios en línea';

  @override
  String get noOnlineUsers => 'No hay usuarios en línea actualmente';

  @override
  String get chooseUser => 'Elige un usuario para chatear';

  @override
  String get quickMatch => 'Emparejamiento rápido';

  @override
  String get story => 'Historia';

  @override
  String get user => 'Usuario';

  @override
  String get following => 'Siguiendo';

  @override
  String get followers => 'Seguidores';

  @override
  String get friendRequests => 'Solicitudes de amistad';

  @override
  String get friendRequestSent => 'Solicitud de amistad enviada';

  @override
  String friendRequestSentTo(String username) {
    return 'Tu solicitud de amistad a $username ha sido enviada.';
  }

  @override
  String get friendRequestCancelled => 'Solicitud de amistad cancelada';

  @override
  String friendRequestCancelledTo(String username) {
    return 'Tu solicitud de amistad a $username ha sido cancelada.';
  }

  @override
  String get requested => 'Solicitada';

  @override
  String get friends => 'Amigos';

  @override
  String get addFriend => 'Agregar amigo';

  @override
  String get friendRequestAccepted => 'Solicitud de amistad aceptada';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'Ahora eres amigo de $username.';
  }

  @override
  String get friendRequestDeclined => 'Solicitud de amistad rechazada';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'Has rechazado la solicitud de amistad de $username.';
  }

  @override
  String get accept => 'Aceptar';

  @override
  String get callDeclined => 'Llamada rechazada';

  @override
  String callDeclinedTo(String username) {
    return 'El usuario $username rechazó la llamada.';
  }

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String get updateNow => 'Actualizar ahora';

  @override
  String get updateLater => 'Más tarde';

  @override
  String get updateSuccessful => 'Actualización exitosa';

  @override
  String get updateSuccessfulMessage =>
      '¡Resonate se ha actualizado exitosamente!';

  @override
  String get updateCancelled => 'Actualización cancelada';

  @override
  String get updateCancelledMessage => 'El usuario canceló la actualización';

  @override
  String get updateFailed => 'Actualización fallida';

  @override
  String get updateFailedMessage =>
      'Error al actualizar. Por favor intenta actualizar manualmente desde Play Store.';

  @override
  String get updateError => 'Error de actualización';

  @override
  String get updateErrorMessage =>
      'Ocurrió un error durante la actualización. Por favor intenta de nuevo.';

  @override
  String get platformNotSupported => 'Plataforma no soportada';

  @override
  String get platformNotSupportedMessage =>
      'La verificación de actualizaciones solo está disponible en dispositivos Android';

  @override
  String get updateCheckFailed => 'Error al verificar actualización';

  @override
  String get updateCheckFailedMessage =>
      'No se pudo verificar si hay actualizaciones. Por favor intenta de nuevo más tarde.';

  @override
  String get upToDateTitle => '¡Estás actualizado!';

  @override
  String get upToDateMessage =>
      'Estás usando la versión más reciente de Resonate';

  @override
  String get updateAvailableTitle => '¡Actualización disponible!';

  @override
  String get updateAvailableMessage =>
      'Una nueva versión de Resonate está disponible en Play Store';

  @override
  String get updateFeaturesImprovement =>
      '¡Obtén las últimas funciones y mejoras!';

  @override
  String get failedToRemoveRoom => 'Error al eliminar la sala';

  @override
  String get roomRemovedSuccessfully =>
      'Sala eliminada de tu lista exitosamente';

  @override
  String get alert => 'Alerta';

  @override
  String get removedFromRoom => 'Has sido reportado o eliminado de la sala';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'Acoso / Discurso de odio',
      'abuse': 'Contenido abusivo / Violencia',
      'spam': 'Spam / Estafas / Fraude',
      'impersonation': 'Suplantación de identidad / Cuentas falsas',
      'illegal': 'Actividades ilegales',
      'selfharm': 'Autolesión / Suicidio / Salud mental',
      'misuse': 'Uso indebido de la plataforma',
      'other': 'Otro',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate =>
      'Has recibido múltiples reportes de usuarios y has sido bloqueado de usar Resonate. Por favor contacta a AOSSIE si crees que esto es un error.';

  @override
  String get reportParticipant => 'Reportar participante';

  @override
  String get selectReportType => 'Por favor selecciona un tipo de reporte';

  @override
  String get reportSubmitted => 'Reporte enviado exitosamente';

  @override
  String get reportFailed => 'Error al enviar el reporte';

  @override
  String get additionalDetailsOptional => 'Detalles adicionales (opcional)';

  @override
  String get submitReport => 'Enviar reporte';

  @override
  String get actionBlocked => 'Acción bloqueada';

  @override
  String get cannotStopRecording =>
      'No puedes detener la grabación manualmente, la grabación se detendrá cuando se cierre la sala.';

  @override
  String get liveChapter => 'Capítulo en vivo';

  @override
  String get viewOrEditLyrics => 'Ver o editar letra';

  @override
  String get close => 'Cerrar';

  @override
  String get verifyChapterDetails => 'Verificar detalles del capítulo';

  @override
  String get author => 'Autor';

  @override
  String get startLiveChapter => 'Iniciar un capítulo en vivo';

  @override
  String get fillAllFields =>
      'Por favor completa todos los campos obligatorios';

  @override
  String get noRecordingError =>
      'No has grabado nada para el capítulo. Por favor graba un capítulo antes de salir de la sala';
}
