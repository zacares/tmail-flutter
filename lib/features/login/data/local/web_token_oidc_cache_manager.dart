import 'package:core/utils/app_logger.dart';
import 'package:model/oidc/token_oidc.dart';
import 'package:tmail_ui_user/features/login/data/extensions/token_oidc_cache_extension.dart';
import 'package:tmail_ui_user/features/login/data/local/token_oidc_cache_manager.dart';
import 'package:tmail_ui_user/features/login/data/model/token_oidc_cache.dart';
import 'package:tmail_ui_user/features/login/domain/exceptions/authentication_exception.dart';
import 'package:universal_html/html.dart';

class WebTokenOidcCacheManager extends TokenOidcCacheManager {
  const WebTokenOidcCacheManager(super.tokenOidcCacheClient);

  static const _sessionStorageTokenKey = 'twake_mail_token_session_storage';

  @override
  Future<TokenOIDC> getTokenOidc(String tokenIdHash) async {
    log('WebTokenOidcCacheManager::getTokenOidc(): tokenIdHash: $tokenIdHash');
    final tokenHiveCache = await tokenOidcCacheClient.getItem(tokenIdHash);
    final tokenSessionStorageCache = window.sessionStorage[_sessionStorageTokenKey];
    log('WebTokenOidcCacheManager::getTokenOidc(): tokenHiveCache: $tokenHiveCache');
    log('WebTokenOidcCacheManager::getTokenOidc(): tokenSessionStorageCache: $tokenSessionStorageCache');
    if (tokenHiveCache == null) {
      throw NotFoundStoredTokenException();
    } else {
      return TokenOidcCache(
        tokenSessionStorageCache ?? 'dummy_token',
        tokenHiveCache.tokenId,
        tokenHiveCache.refreshToken,
        expiredTime: tokenSessionStorageCache != null
          ? tokenHiveCache.expiredTime
          : DateTime.now().subtract(const Duration(hours: 1)),
      ).toTokenOidc();
    }
  }

  @override
  Future<void> persistOneTokenOidc(TokenOIDC tokenOIDC) async {
    log('TokenOidcCacheManager::persistOneTokenOidc(): $tokenOIDC');
    await tokenOidcCacheClient.clearAllData();
    log('TokenOidcCacheManager::persistOneTokenOidc(): key: ${tokenOIDC.tokenId.uuid}');
    log('TokenOidcCacheManager::persistOneTokenOidc(): key\'s hash: ${tokenOIDC.tokenIdHash}');
    log('TokenOidcCacheManager::persistOneTokenOidc(): token: ${tokenOIDC.token}');
    final tokenHiveCache = TokenOidcCache(
      '',
      tokenOIDC.tokenId.uuid,
      tokenOIDC.refreshToken,
      expiredTime: tokenOIDC.expiredTime,
    );
    await tokenOidcCacheClient.insertItem(tokenOIDC.tokenIdHash, tokenHiveCache);
    window.sessionStorage[_sessionStorageTokenKey] = tokenOIDC.token;
    log('TokenOidcCacheManager::persistOneTokenOidc(): done');
  }

  @override
  Future<void> deleteTokenOidc() async {
    await tokenOidcCacheClient.clearAllData();
    window.sessionStorage.remove(_sessionStorageTokenKey);
  }
}