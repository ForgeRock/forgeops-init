/*
 * Copyright 2016-2017 ForgeRock AS. All Rights Reserved
 *
 * Use of this code requires a commercial software license with ForgeRock AS.
 * or with one of its affiliates. All use shall be exclusively subject
 * to such license between the licensee and ForgeRock AS.
 */
var base64 = Packages.org.forgerock.util.encode.Base64url,
    dataStoreToken = (httpRequest.getHeaders().getFirst('X-OpenIDM-DataStoreToken').toString()+""),
    id_token = openidm.action("identityProviders", "getDataStoreContent", {token: dataStoreToken}).id_token,
    idpConfig = properties.idpConfig,
    referer = (httpRequest.getHeaders().getFirst('Referer').toString()+""),
    parts = id_token.split('.'),
    claimsContent = parts[1],
    claims = JSON.parse(new java.lang.String(base64.decode(claimsContent))),
    session_token = claims.sessionTokenId || id_token,
    modifiedMap = {};

//console.log(JSON.stringify(claims, null, 4))
try {
    var response = openidm.action("external/rest", "call", {
        "url": sessionValidationBaseEndpoint + session_token + "?_action=validate",
        "headers" : {
            "Accept-API-Version" : "protocol=1.0,resource=1.0"
        },
        "method": "POST"
    });

    if (!response.valid) {
        throw {
            "code": 401,
            "message": "OpenAM session invalid"
        };
    }
} catch (e) {
    throw {
        "code": 401,
        "message": "OpenAM session invalid"
    };
}


if (security.authenticationId.toLowerCase() === "amadmin") {
    security.authorization = {
        "id" : "openidm-admin",
        "component" : "endpoint/static/user",
        "roles" : ["openidm-admin", "openidm-authorized"],
        "moduleId" : security.authorization.moduleId
    };
} else {
    var _ = require('lib/lodash'),
       managedUser = openidm.query("managed/user", { '_queryFilter' : '/userName eq "' + security.authenticationId  + '"' }, ["*","authzRoles"]);

    if (managedUser.result.length === 0) {
        throw {
            "code" : 401,
            "message" : "Access denied, managed/user entry is not found"
        };
    }

    if (managedUser.result[0].accountStatus !== "active") {
        throw {
            "code" : 401,
            "message" : "Access denied, user inactive"
        };
    }

    security.authorization = {
        "id": managedUser.result[0]._id,
        "moduleId" : security.authorization.moduleId,
        "component": "managed/user",
        "roles": managedUser.result[0].authzRoles ?
            _.uniq(
                security.authorization.roles.concat(
                    _.map(managedUser.result[0].authzRoles, function (r) {
                        // appending empty string gets the value from java into a format more familiar to JS
                        return org.forgerock.json.resource.ResourcePath.valueOf(r._ref).leaf() + "";
                    })
                )
            ) :
            security.authorization.roles
    };

    security.authorization = require('auth/customAuthz').setProtectedAttributes(security).authorization;
}

if (idpConfig.endSessionEndpoint) {
    Object.keys(security.authorization).forEach(function (k) {
        modifiedMap[k] = security.authorization[k];
    });
    modifiedMap.logoutUrl = idpConfig.endSessionEndpoint +
        "?id_token_hint=" + id_token +
        // Internet Explorer 11 (and possibly others) will include the hash fragment in the referer
        // We have to strip it out to get the basic URL for the UI context.
        "&post_logout_redirect_uri=" + referer.replace(/#.*/, '');
    security.authorization = modifiedMap;
}
security;
