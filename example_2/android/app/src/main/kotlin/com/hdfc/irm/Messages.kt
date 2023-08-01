// Autogenerated from Pigeon (v10.1.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.hdfc.irm

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

enum class MSALLoginPrompt(val raw: Int) {
  CONSENT(0),
  CREATE(1),
  LOGIN(2),
  SELECTACCOUNT(3),
  WHENREQUIRED(4);

  companion object {
    fun ofRaw(raw: Int): MSALLoginPrompt? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

enum class MAMEnrollmentStatus(val raw: Int) {
  AUTHORIZATION_NEEDED(0),
  NOT_LICENSED(1),
  ENROLLMENT_SUCCEEDED(2),
  ENROLLMENT_FAILED(3),
  WRONG_USER(4),
  MDM_ENROLLED(5),
  UNENROLLMENT_SUCCEEDED(6),
  UNENROLLMENT_FAILED(7),
  PENDING(8),
  COMPANY_PORTAL_REQUIRED(9);

  companion object {
    fun ofRaw(raw: Int): MAMEnrollmentStatus? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

enum class MSALErrorType(val raw: Int) {
  INTUNEAPPPROTECTIONPOLICYREQUIRED(0),
  USERCANCELLEDSIGNINREQUEST(1),
  UNKNOWN(2);

  companion object {
    fun ofRaw(raw: Int): MSALErrorType? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class AcquireTokenParams (
  val scopes: List<String?>,
  val correlationId: String? = null,
  val authority: String? = null,
  val loginHint: String? = null,
  val prompt: MSALLoginPrompt? = null,
  val extraScopesToConsent: List<String?>? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): AcquireTokenParams {
      val scopes = list[0] as List<String?>
      val correlationId = list[1] as String?
      val authority = list[2] as String?
      val loginHint = list[3] as String?
      val prompt: MSALLoginPrompt? = (list[4] as Int?)?.let {
        MSALLoginPrompt.ofRaw(it)
      }
      val extraScopesToConsent = list[5] as List<String?>?
      return AcquireTokenParams(scopes, correlationId, authority, loginHint, prompt, extraScopesToConsent)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      scopes,
      correlationId,
      authority,
      loginHint,
      prompt?.raw,
      extraScopesToConsent,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class AcquireTokenSilentlyParams (
  val aadId: String,
  val scopes: List<String?>,
  val correlationId: String? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): AcquireTokenSilentlyParams {
      val aadId = list[0] as String
      val scopes = list[1] as List<String?>
      val correlationId = list[2] as String?
      return AcquireTokenSilentlyParams(aadId, scopes, correlationId)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      aadId,
      scopes,
      correlationId,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MAMEnrollmentStatusResult (
  val result: MAMEnrollmentStatus? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MAMEnrollmentStatusResult {
      val result: MAMEnrollmentStatus? = (list[0] as Int?)?.let {
        MAMEnrollmentStatus.ofRaw(it)
      }
      return MAMEnrollmentStatusResult(result)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      result?.raw,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MSALApiException (
  val errorCode: String,
  val message: String? = null,
  val stackTraceAsString: String

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MSALApiException {
      val errorCode = list[0] as String
      val message = list[1] as String?
      val stackTraceAsString = list[2] as String
      return MSALApiException(errorCode, message, stackTraceAsString)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      errorCode,
      message,
      stackTraceAsString,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MSALErrorResponse (
  val errorType: MSALErrorType

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MSALErrorResponse {
      val errorType = MSALErrorType.ofRaw(list[0] as Int)!!
      return MSALErrorResponse(errorType)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      errorType.raw,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MSALUserAccount (
  val authority: String,
  /** aadid */
  val id: String,
  val idToken: String? = null,
  val tenantId: String,
  /** upn */
  val username: String

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MSALUserAccount {
      val authority = list[0] as String
      val id = list[1] as String
      val idToken = list[2] as String?
      val tenantId = list[3] as String
      val username = list[4] as String
      return MSALUserAccount(authority, id, idToken, tenantId, username)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      authority,
      id,
      idToken,
      tenantId,
      username,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MSALUserAuthenticationDetails (
  val accessToken: String,
  val account: MSALUserAccount,
  val authenticationScheme: String,
  val correlationId: Long? = null,
  val expiresOnISO8601: String,
  val scope: List<String?>

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MSALUserAuthenticationDetails {
      val accessToken = list[0] as String
      val account = MSALUserAccount.fromList(list[1] as List<Any?>)
      val authenticationScheme = list[2] as String
      val correlationId = list[3].let { if (it is Int) it.toLong() else it as Long? }
      val expiresOnISO8601 = list[4] as String
      val scope = list[5] as List<String?>
      return MSALUserAuthenticationDetails(accessToken, account, authenticationScheme, correlationId, expiresOnISO8601, scope)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      accessToken,
      account.toList(),
      authenticationScheme,
      correlationId,
      expiresOnISO8601,
      scope,
    )
  }
}

@Suppress("UNCHECKED_CAST")
private object IntuneApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          AcquireTokenParams.fromList(it)
        }
      }
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          AcquireTokenSilentlyParams.fromList(it)
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MAMEnrollmentStatusResult.fromList(it)
        }
      }
      131.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MSALApiException.fromList(it)
        }
      }
      132.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MSALErrorResponse.fromList(it)
        }
      }
      133.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MSALUserAccount.fromList(it)
        }
      }
      134.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MSALUserAuthenticationDetails.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is AcquireTokenParams -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      is AcquireTokenSilentlyParams -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      is MAMEnrollmentStatusResult -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      is MSALApiException -> {
        stream.write(131)
        writeValue(stream, value.toList())
      }
      is MSALErrorResponse -> {
        stream.write(132)
        writeValue(stream, value.toList())
      }
      is MSALUserAccount -> {
        stream.write(133)
        writeValue(stream, value.toList())
      }
      is MSALUserAuthenticationDetails -> {
        stream.write(134)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface IntuneApi {
  fun registerAuthentication(callback: (Result<Boolean>) -> Unit)
  fun registerAccountForMAM(upn: String, aadId: String, tenantId: String, authorityURL: String, callback: (Result<Boolean>) -> Unit)
  fun unregisterAccountFromMAM(upn: String, aadId: String, callback: (Result<Boolean>) -> Unit)
  fun getRegisteredAccountStatus(upn: String, aadId: String, callback: (Result<MAMEnrollmentStatusResult>) -> Unit)
  fun createMicrosoftPublicClientApplication(publicClientApplicationConfiguration: Map<String, Any?>, forceCreation: Boolean, enableLogs: Boolean, callback: (Result<Boolean>) -> Unit)
  fun getAccounts(aadId: String?, callback: (Result<List<MSALUserAccount?>>) -> Unit)
  fun acquireToken(params: AcquireTokenParams, callback: (Result<Boolean>) -> Unit)
  fun acquireTokenSilently(params: AcquireTokenSilentlyParams, callback: (Result<Boolean>) -> Unit)
  fun signOut(aadId: String?, callback: (Result<Boolean>) -> Unit)

  companion object {
    /** The codec used by IntuneApi. */
    val codec: MessageCodec<Any?> by lazy {
      IntuneApiCodec
    }
    /** Sets up an instance of `IntuneApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: IntuneApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneApi.registerAuthentication", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.registerAuthentication() { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneApi.registerAccountForMAM", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val upnArg = args[0] as String
            val aadIdArg = args[1] as String
            val tenantIdArg = args[2] as String
            val authorityURLArg = args[3] as String
            api.registerAccountForMAM(upnArg, aadIdArg, tenantIdArg, authorityURLArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneApi.unregisterAccountFromMAM", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val upnArg = args[0] as String
            val aadIdArg = args[1] as String
            api.unregisterAccountFromMAM(upnArg, aadIdArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneApi.getRegisteredAccountStatus", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val upnArg = args[0] as String
            val aadIdArg = args[1] as String
            api.getRegisteredAccountStatus(upnArg, aadIdArg) { result: Result<MAMEnrollmentStatusResult> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneApi.createMicrosoftPublicClientApplication", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val publicClientApplicationConfigurationArg = args[0] as Map<String, Any?>
            val forceCreationArg = args[1] as Boolean
            val enableLogsArg = args[2] as Boolean
            api.createMicrosoftPublicClientApplication(publicClientApplicationConfigurationArg, forceCreationArg, enableLogsArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneApi.getAccounts", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val aadIdArg = args[0] as String?
            api.getAccounts(aadIdArg) { result: Result<List<MSALUserAccount?>> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneApi.acquireToken", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val paramsArg = args[0] as AcquireTokenParams
            api.acquireToken(paramsArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneApi.acquireTokenSilently", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val paramsArg = args[0] as AcquireTokenSilentlyParams
            api.acquireTokenSilently(paramsArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneApi.signOut", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val aadIdArg = args[0] as String?
            api.signOut(aadIdArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
@Suppress("UNCHECKED_CAST")
private object IntuneFlutterApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MAMEnrollmentStatusResult.fromList(it)
        }
      }
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MSALApiException.fromList(it)
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MSALErrorResponse.fromList(it)
        }
      }
      131.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MSALUserAccount.fromList(it)
        }
      }
      132.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MSALUserAuthenticationDetails.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is MAMEnrollmentStatusResult -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      is MSALApiException -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      is MSALErrorResponse -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      is MSALUserAccount -> {
        stream.write(131)
        writeValue(stream, value.toList())
      }
      is MSALUserAuthenticationDetails -> {
        stream.write(132)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated class from Pigeon that represents Flutter messages that can be called from Kotlin. */
@Suppress("UNCHECKED_CAST")
class IntuneFlutterApi(private val binaryMessenger: BinaryMessenger) {
  companion object {
    /** The codec used by IntuneFlutterApi. */
    val codec: MessageCodec<Any?> by lazy {
      IntuneFlutterApiCodec
    }
  }
  fun onEnrollmentNotification(enrollmentResultArg: MAMEnrollmentStatusResult, callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneFlutterApi.onEnrollmentNotification", codec)
    channel.send(listOf(enrollmentResultArg)) {
      callback()
    }
  }
  fun onUnexpectedEnrollmentNotification(callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneFlutterApi.onUnexpectedEnrollmentNotification", codec)
    channel.send(null) {
      callback()
    }
  }
  fun onMsalException(exceptionArg: MSALApiException, callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneFlutterApi.onMsalException", codec)
    channel.send(listOf(exceptionArg)) {
      callback()
    }
  }
  fun onErrorType(responseArg: MSALErrorResponse, callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneFlutterApi.onErrorType", codec)
    channel.send(listOf(responseArg)) {
      callback()
    }
  }
  fun onUserAuthenticationDetails(detailsArg: MSALUserAuthenticationDetails, callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneFlutterApi.onUserAuthenticationDetails", codec)
    channel.send(listOf(detailsArg)) {
      callback()
    }
  }
  fun onSignOut(callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.example.IntuneFlutterApi.onSignOut", codec)
    channel.send(null) {
      callback()
    }
  }
}
