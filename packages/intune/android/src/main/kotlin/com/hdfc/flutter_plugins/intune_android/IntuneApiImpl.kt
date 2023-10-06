/*
 * Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

package com.hdfc.flutter_plugins.intune_android

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.microsoft.identity.client.AcquireTokenParameters
import com.microsoft.identity.client.AcquireTokenSilentParameters
import com.microsoft.identity.client.IAuthenticationResult
import com.microsoft.identity.client.IMultipleAccountPublicClientApplication
import com.microsoft.identity.client.IPublicClientApplication
import com.microsoft.identity.client.ISingleAccountPublicClientApplication
import com.microsoft.identity.client.MultipleAccountPublicClientApplication
import com.microsoft.identity.client.Prompt
import com.microsoft.identity.client.SilentAuthenticationCallback
import com.microsoft.identity.client.exception.MsalException
import com.microsoft.identity.client.exception.MsalUiRequiredException
import com.microsoft.intune.mam.client.app.MAMComponents
import com.microsoft.intune.mam.client.app.offline.OfflineComponents
import com.microsoft.intune.mam.client.notification.MAMNotificationReceiverRegistry
import com.microsoft.intune.mam.policy.MAMEnrollmentManager
import com.microsoft.intune.mam.policy.MAMServiceAuthenticationCallback
import com.microsoft.intune.mam.policy.notification.MAMEnrollmentNotification
import com.microsoft.intune.mam.policy.notification.MAMNotification
import com.microsoft.intune.mam.policy.notification.MAMNotificationType
import java.util.UUID

class IntuneApiImpl(private val context: Context, private val reply: IntuneReply) : IntuneApi {
    companion object {
        const val TAG = "IntuneApiImpl"

        private fun getEnrollmentManager(): MAMEnrollmentManager? {
            return MAMComponents.get(MAMEnrollmentManager::class.java)
        }

        private fun getNotificationRegistry(): MAMNotificationReceiverRegistry? {
            return MAMComponents.get(MAMNotificationReceiverRegistry::class.java)
        }

        private fun enrollmentStatusResultFromEnrollmentManagerResult(result: MAMEnrollmentManager.Result): MAMEnrollmentStatus {
            return when (result) {
                MAMEnrollmentManager.Result.AUTHORIZATION_NEEDED -> MAMEnrollmentStatus.AUTHORIZATION_NEEDED
                MAMEnrollmentManager.Result.NOT_LICENSED -> MAMEnrollmentStatus.NOT_LICENSED
                MAMEnrollmentManager.Result.ENROLLMENT_SUCCEEDED -> MAMEnrollmentStatus.ENROLLMENT_SUCCEEDED
                MAMEnrollmentManager.Result.ENROLLMENT_FAILED -> MAMEnrollmentStatus.ENROLLMENT_FAILED
                MAMEnrollmentManager.Result.WRONG_USER -> MAMEnrollmentStatus.WRONG_USER
                MAMEnrollmentManager.Result.MDM_ENROLLED -> MAMEnrollmentStatus.MDM_ENROLLED
                MAMEnrollmentManager.Result.UNENROLLMENT_SUCCEEDED -> MAMEnrollmentStatus.UNENROLLMENT_SUCCEEDED
                MAMEnrollmentManager.Result.UNENROLLMENT_FAILED -> MAMEnrollmentStatus.UNENROLLMENT_FAILED
                MAMEnrollmentManager.Result.PENDING -> MAMEnrollmentStatus.PENDING
                MAMEnrollmentManager.Result.COMPANY_PORTAL_REQUIRED -> MAMEnrollmentStatus.COMPANY_PORTAL_REQUIRED
            }
        }
    }

    private var activity: Activity? = null
    private var publicClientApplication: IPublicClientApplication? = null

    fun setActivity(a: Activity?) {
        activity = a
    }

    override fun registerAuthentication(callback: (Result<Boolean>) -> Unit) {
        try {
            callback(Result.success(registerAuthentication()))
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun registerAuthentication(): Boolean {
        val app = publicClientApplication
        if (app == null) {
            Log.w(TAG, "PUBLIC CLIENT APP NOT INITIALIZED")
            return false
        }
        OfflineComponents.initialize(context)

        // Registers a MAMAuthenticationCallback, which will try to acquire access tokens for MAM.
        // This is necessary for proper MAM integration.
        // Registers a MAMAuthenticationCallback, which will try to acquire access tokens for MAM.
        // This is necessary for proper MAM integration.
        val mgr = getEnrollmentManager()
        if (mgr == null) {
            Log.i(TAG, "Enrollment manager is null")
            return false
        }

        mgr.registerAuthenticationCallback(object : MAMServiceAuthenticationCallback {
            override fun acquireToken(upn: String, aadId: String, resourceId: String): String? {
                try {
                    // Create the MSAL scopes by using the default scope of the passed in resource id.
                    val scopes = arrayListOf("$resourceId/.default")
                    val result = IntuneUtils(app, reply).acquireTokenSilent(aadId, scopes)
                    val accessToken = result?.accessToken
                    if (accessToken != null) return accessToken
                } catch (e: Throwable) {
                    Log.e(TAG, "Failed to get token for MAM Service", e)
                    return null
                }
                Log.w(TAG, "Failed to get token for MAM Service - no result from MSAL")
                return null
            }
        })

        /* This section shows how to register a MAMNotificationReceiver, so you can perform custom
             * actions based on MAM enrollment notifications.
             * More information is available here:
             * https://docs.microsoft.com/en-us/intune/app-sdk-android#types-of-notifications */

        /* This section shows how to register a MAMNotificationReceiver, so you can perform custom
             * actions based on MAM enrollment notifications.
             * More information is available here:
             * https://docs.microsoft.com/en-us/intune/app-sdk-android#types-of-notifications */
        val notificationRegistry = getNotificationRegistry()!!
        notificationRegistry.registerReceiver({ notification: MAMNotification? ->
            if (notification is MAMEnrollmentNotification) {
                when (val result = notification.enrollmentResult) {
                    null -> Handler(Looper.getMainLooper()).post {
                        reply.onEnrollmentNotification(null)
                    }
                    else -> Handler(Looper.getMainLooper()).post {
                        reply.onEnrollmentNotification(enrollmentStatusResultFromEnrollmentManagerResult(result))
                    }
                }
            } else {
                Log.w(TAG, "Unknown notification received of type: ${notification?.type?.name}, content: ${notification.toString()}")
                Handler(Looper.getMainLooper()).post { reply.onUnexpectedEnrollmentNotification() }
            }
            true
        }, MAMNotificationType.MAM_ENROLLMENT_RESULT)

        return true
    }

    override fun registerAccountForMAM(upn: String, aadId: String, tenantId: String, authorityURL: String, callback: (Result<Boolean>) -> Unit) {
        try {
            callback(Result.success(registerAccountForMAM(upn, aadId, tenantId, authorityURL)))
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun registerAccountForMAM(upn: String, aadId: String, tenantId: String, authorityURL: String): Boolean {
        val mEnrollmentManager = getEnrollmentManager() ?: return false
        // Register the account for MAM.
        mEnrollmentManager.registerAccountForMAM(upn, aadId, tenantId, authorityURL)
        return true
    }

    override fun unregisterAccountFromMAM(upn: String, callback: (Result<Boolean>) -> Unit) {
        try {
            callback(Result.success(unregisterAccountFromMAM(upn)))
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun unregisterAccountFromMAM(upn: String): Boolean {
        val mEnrollmentManager = getEnrollmentManager() ?: return false
        mEnrollmentManager.unregisterAccountForMAM(upn)
        return true
    }

    override fun getRegisteredAccountStatus(upn: String, callback: (Result<MAMEnrollmentStatusResult>) -> Unit) {
        try {
            callback(Result.success(MAMEnrollmentStatusResult(getRegisteredAccountStatus(upn))))
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun getRegisteredAccountStatus(upn: String): MAMEnrollmentStatus? {
        val mEnrollmentManager = getEnrollmentManager() ?: return null
        return when (val status = mEnrollmentManager.getRegisteredAccountStatus(upn)) {
            null -> null
            else -> enrollmentStatusResultFromEnrollmentManagerResult(status)
        }
    }

    override fun getAccounts(callback: (Result<List<MSALUserAccount>>) -> Unit) {
        val app = publicClientApplication
        try {
            if (app is IMultipleAccountPublicClientApplication) {
                val accounts = app.accounts.map { account ->
                    MSALUserAccount(
                            authority = account.authority,
                            id = account.id,
                            tenantId = account.tenantId,
                            username = account.username,
                    )
                }
                return callback(Result.success(accounts))
            } else if (app is ISingleAccountPublicClientApplication) {
                val account = app.currentAccount?.currentAccount
                if (account != null) {
                    return callback(Result.success(listOf(MSALUserAccount(
                            authority = account.authority,
                            id = account.id,
                            tenantId = account.tenantId,
                            username = account.username,
                    ))))
                }
            }
            return callback(Result.failure(UnknownError()))
        } catch (e: Throwable) {
            Log.e(TAG, "Failed to get accounts", e)
            return callback(Result.failure(e))
        }
    }

    override fun createMicrosoftPublicClientApplication(publicClientApplicationConfiguration: Map<String, Any?>, forceCreation: Boolean, enableLogs: Boolean, callback: (Result<Boolean>) -> Unit) {
        try {
            if (enableLogs) {
                val msalLogger = com.microsoft.identity.client.Logger.getInstance()
                msalLogger.setEnableLogcatLog(true)
                msalLogger.setLogLevel(com.microsoft.identity.client.Logger.LogLevel.VERBOSE)
                msalLogger.setEnablePII(true)
            }
            if (publicClientApplication != null && !forceCreation) {
                Log.i(TAG, "Public client already exists. Use forceCreation to recreate the client")
                return callback(Result.success(true))
            }

            // Key-values that match PublicClientApplicationConfiguration's properties
            val configFile = MSALConfigParser.parse(publicClientApplicationConfiguration)
            val applicationCreatedListener = object : IPublicClientApplication.ApplicationCreatedListener {
                override fun onCreated(application: IPublicClientApplication?) {
                    if (application != null) {
                        publicClientApplication = application
                        callback(Result.success(true))
                    } else {
                        callback(Result.success(false))
                    }
                }

                override fun onError(exception: MsalException?) {
                    Handler(Looper.getMainLooper()).post{ reply.onMsalException(exception) }
                    if (exception != null) {
                        callback(Result.failure(exception))
                    } else {
                        Log.d(TAG, "Error thrown without exception")
                        callback(Result.failure(UnknownError()))
                    }
                }
            }

            MultipleAccountPublicClientApplication.create(
                    context, configFile, applicationCreatedListener,
            )
        } catch (e: Throwable) {
            Log.e(TAG, "Failed to initialize", e)
            callback(Result.failure(e))
        }
    }

    override fun acquireToken(params: AcquireTokenParams, callback: (Result<Boolean>) -> Unit) {
        val app = publicClientApplication

        Log.i(TAG, "signIn: Starting interactive auth")
        if (app == null) {
            Log.i(TAG, "signIn: Initialize public client application required")
            callback(Result.success(false))
            return
        }

        Thread {
            try {
                var paramsBuilder = AcquireTokenParameters.Builder()
                        .withScopes(params.scopes)
                        .withCallback(object : com.microsoft.identity.client.AuthenticationCallback {
                            override fun onError(exc: MsalException?) {
                                Handler(Looper.getMainLooper()).post{ reply.onMsalException(exc) }
                            }

                            override fun onSuccess(result: IAuthenticationResult) {
                                Handler(Looper.getMainLooper()).post{ reply.onMSALAuthenticationResult(result) }
                            }

                            override fun onCancel() {
                                Handler(Looper.getMainLooper()).post{ reply.onErrorType(MSALErrorType.USERCANCELLEDSIGNINREQUEST) }
                            }
                        })
                        .startAuthorizationFromActivity(activity!!)
                if (params.authority != null) {
                    paramsBuilder = paramsBuilder.fromAuthority(params.authority)
                }
                if (params.correlationId != null) {
                    paramsBuilder = paramsBuilder.withCorrelationId(UUID.fromString(params.correlationId))
                }
                if (params.loginHint != null) {
                    paramsBuilder = paramsBuilder.withLoginHint(params.loginHint)
                }
                if (params.prompt != null) {
                    paramsBuilder = paramsBuilder.withPrompt(when (params.prompt) {
                        MSALLoginPrompt.CONSENT -> Prompt.CONSENT
                        MSALLoginPrompt.CREATE -> Prompt.CREATE
                        MSALLoginPrompt.LOGIN -> Prompt.LOGIN
                        MSALLoginPrompt.SELECTACCOUNT -> Prompt.SELECT_ACCOUNT
                        MSALLoginPrompt.WHENREQUIRED -> Prompt.WHEN_REQUIRED
                    })
                }
                if (params.extraScopesToConsent != null) {
                    paramsBuilder = paramsBuilder.withOtherScopesToAuthorize(params.extraScopesToConsent)
                }
                app.acquireToken(paramsBuilder.build())
                callback(Result.success(true))
            } catch (e: MsalException) {
                Log.e(TAG, "signIn: Failed MSAL sign in", e)
                callback(Result.failure(e))
                Handler(Looper.getMainLooper()).post{ reply.onMsalException(e) }
            } catch (e: InterruptedException) {
                Log.e(TAG, "signIn: Failed MSAL sign in", e)
                callback(Result.failure(e))
            } catch (e: Throwable) {
                callback(Result.failure(e))
            }
        }.start()
    }

    override fun acquireTokenSilently(params: AcquireTokenSilentlyParams, callback: (Result<Boolean>) -> Unit) {
        val app = publicClientApplication
        if (app == null) {
            Log.i(TAG, "signOut: public client application was not initialized")
            return callback(Result.success(false))
        }
        val account = IntuneUtils(app, reply).getAccount(params.aadId)
        if (account == null) {
            Handler(Looper.getMainLooper()).post{ reply.onMsalException(MsalUiRequiredException(MsalUiRequiredException.NO_ACCOUNT_FOUND, "no account found for ${params.aadId}")) }
            return callback(Result.success(false))
        }

        Thread {
            var paramsBuilder = AcquireTokenSilentParameters.Builder()
                    .withScopes(params.scopes)
                    .forAccount(account)
                    .fromAuthority(account.authority)
                    .withCallback(object : SilentAuthenticationCallback {
                        override fun onError(exc: MsalException?) {
                            Handler(Looper.getMainLooper()).post{ reply.onMsalException(exc) }
                        }

                        override fun onSuccess(result: IAuthenticationResult?) {
                            if (result == null) {
                                Handler(Looper.getMainLooper()).post{ reply.onErrorType(MSALErrorType.UNKNOWN) }
                            } else {
                                Handler(Looper.getMainLooper()).post { reply.onMSALAuthenticationResult(result) }
                            }
                        }
                    })
            if (params.correlationId != null) {
                paramsBuilder = paramsBuilder.withCorrelationId(UUID.fromString(params.correlationId))
            }
            app.acquireTokenSilentAsync(paramsBuilder.build())
            Handler(context.mainLooper).post { callback(Result.success(true)) }
        }.start()
    }

    override fun signOut(aadId: String?, callback: (Result<Boolean>) -> Unit) {
        Thread {
            when (val app = publicClientApplication) {
                null -> {
                    Log.i(TAG, "signOut: public client application was not initialized")
                    callback(Result.success(false))
                }

                is ISingleAccountPublicClientApplication -> {
                    app.signOut(object : ISingleAccountPublicClientApplication.SignOutCallback {
                        override fun onSignOut() {
                            Handler(context.mainLooper).post {
                                callback(Result.success(true))
                            }
                            Handler(Looper.getMainLooper()).post{ reply.onSignOut() }
                            Log.i(TAG, "signOut: complete")
                        }

                        override fun onError(exception: MsalException) {
                            Handler(context.mainLooper).post { callback(Result.success(false)) }
                            Handler(Looper.getMainLooper()).post{ reply.onMsalException(exception) }
                        }
                    })
                }

                is IMultipleAccountPublicClientApplication -> {
                    val account = if (aadId == null) {
                        app.accounts.firstOrNull()
                    } else {
                        app.getAccount(aadId)
                    }
                    app.removeAccount(account, object : IMultipleAccountPublicClientApplication.RemoveAccountCallback {
                        override fun onRemoved() {
                            Handler(context.mainLooper).post { callback(Result.success(true)) }
                            Log.i(TAG, "signOut: complete")
                        }

                        override fun onError(exception: MsalException) {
                            Handler(context.mainLooper).post { callback(Result.success(false)) }
                            Handler(Looper.getMainLooper()).post{ reply.onMsalException(exception) }
                        }
                    })
                }

                else -> {
                    Log.i(TAG, "signOut: unknown account type")
                    Handler(context.mainLooper).post { callback(Result.success(false)) }
                }
            }
        }.start()
    }
}